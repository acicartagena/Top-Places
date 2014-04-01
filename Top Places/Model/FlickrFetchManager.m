//
//  FlickrFetchManager.m
//  Top Places
//
//  Created by Angela Cartagena on 3/28/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "FlickrFetchManager.h"
#import "FlickrFetcher.h"
#import "FlickrDBManager.h"
#import "Photo+Flickr.h"
#import "Region+Flickr.h"

@interface FlickrFetchManager ()
{
    dispatch_queue_t _getPlaceInfoQueue;
}

@property (strong, nonatomic) NSURLSession *backgroundSession;
@property (strong, nonatomic) NSURLSession *ephemeralSession;
@property (strong, nonatomic) NSTimer *backgroundSessionTimer;

@end

static FlickrFetchManager *_instance = nil;

@implementation FlickrFetchManager

+ (instancetype)sharedFetchManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[FlickrFetchManager alloc] init];
    });
    return _instance;
}


- (instancetype) init
{
    self = [super init];
    if (self){
        NSURLSessionConfiguration *backgroundConfig = [NSURLSessionConfiguration backgroundSessionConfiguration:APP_BACKGROUND_PHOTO_FETCH];
        self.backgroundSession = [NSURLSession sessionWithConfiguration:backgroundConfig delegate:self delegateQueue:nil];
        
        NSURLSessionConfiguration *ephemeralConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
        ephemeralConfig.allowsCellularAccess = NO;
        ephemeralConfig.timeoutIntervalForRequest = EPHEMERAL_SESSION_TIMEOUT_INTERVAL;
        self.ephemeralSession = [NSURLSession sessionWithConfiguration:ephemeralConfig];
        [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFICATION_CONTEXT_IS_AVAILABLE object:nil queue:nil usingBlock:^(NSNotification *note) {
            [self startBackgroundSessionFlickrFetch];
            
            [self.backgroundSessionTimer invalidate];
            self.backgroundSessionTimer = nil;
            
            self.backgroundSessionTimer = [NSTimer scheduledTimerWithTimeInterval:BACKGROUND_SESSION_FETCH_INTERVAL
                                                                           target:self
                                                                         selector:@selector(startBackgroundSessionFlickrFetch:)
                                                                         userInfo:nil
                                                                          repeats:YES];
        }];
    }
    return self;
}

- (void)startBackgroundSessionFlickrFetch:(NSTimer *)timer
{
    [self startBackgroundSessionFlickrFetch];
}

- (void)startBackgroundSessionFlickrFetch
{
    if (![[FlickrDBManager sharedDBManager] context]){
        return;
    }
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    [self.backgroundSession getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
        if (![downloadTasks count]){
            NSURLSessionDownloadTask *task = [self.backgroundSession downloadTaskWithURL:[FlickrFetcher URLforRecentGeoreferencedPhotos]];
            task.taskDescription = APP_BACKGROUND_PHOTO_FETCH;
            [task resume];
            
        }else{
            for (NSURLSessionDownloadTask *task in downloadTasks){
                [task resume];
            }
        }
    }];
}

- (void)startEphemeralSessionFlickrFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHanlder
{
    if (![[FlickrDBManager sharedDBManager] context]){
        completionHanlder(UIBackgroundFetchResultNoData);
        return;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[FlickrFetcher URLforRecentGeoreferencedPhotos]];
    NSURLSessionDownloadTask *task = [self.ephemeralSession downloadTaskWithRequest:request completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
        if (error){
            NSLog(@"background fetch failed: %@",[error localizedDescription]);
            completionHanlder(UIBackgroundFetchResultNoData);
        }else{
            [self loadPhotosFromURL:location withCompletionHandler:^{
                completionHanlder(UIBackgroundFetchResultNewData);
            }];
        }
    }];
}

- (void)loadPhotosFromURL:(NSURL *)localUrl withCompletionHandler:(void (^)()) completionHandler
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    if (![[FlickrDBManager sharedDBManager] context]){
        if (completionHandler){
            completionHandler();
        }
        return;
    }
    
    NSError *error;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:localUrl] options:0 error:&error];
    
    [[[FlickrDBManager sharedDBManager] context] performBlockAndWait:^{
        [Photo loadPhotosFromFlickrArray:[data valueForKeyPath:FLICKR_RESULTS_PHOTOS] intoManagedObjectContext:[[FlickrDBManager sharedDBManager] context]];
        [[FlickrDBManager sharedDBManager] forceSaveUIManagedDocumentInContextBlock:YES];
        if (completionHandler){
            completionHandler();
        }
    }];
    
    dispatch_queue_t fetchQ = [Region getPlaceInfoQueue];
    dispatch_async(fetchQ, ^{
        [[FlickrDBManager sharedDBManager] forceSaveUIManagedDocumentInContextBlock:NO];
    });
  
}

//background session, check for other ongoing download tasks
- (void)flickrDownloadTasksMightBeComplete
{
    if (self.flickrDownloadBackgroundURLSessionCompletionHandler) {
        [self.backgroundSession getTasksWithCompletionHandler:^(NSArray *dataTasks, NSArray *uploadTasks, NSArray *downloadTasks) {
            if (![downloadTasks count]) {
                void (^completionHandler)() = self.flickrDownloadBackgroundURLSessionCompletionHandler;
                self.flickrDownloadBackgroundURLSessionCompletionHandler = nil;
                if (completionHandler) {
                    completionHandler();
                }
            }
        }];
    }
}

#pragma mark - url session dleegates
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    if (session == self.backgroundSession || session == self.ephemeralSession){
        [self loadPhotosFromURL:location withCompletionHandler:^{
            [self flickrDownloadTasksMightBeComplete];
        }];
    }
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}


@end
