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
        self.ephemeralSession = [NSURLSession sessionWithConfiguration:ephemeralConfig];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFICATION_CONTEXT_IS_AVAILABLE object:nil queue:nil usingBlock:^(NSNotification *note) {
            [self startBackgroundSessionFlickrFetch];
            
            [self.backgroundSessionTimer invalidate];
            self.backgroundSessionTimer = nil;
            
            
        }];
    }
    return self;
}

- (void)startBackgroundSessionFlickrFetch
{
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

#pragma mark
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSError *error;
    NSDictionary *data = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfURL:location] options:0 error:&error];
//    NSLog(@"data: %@",data);
    [[[FlickrDBManager sharedDBManager] context] performBlockAndWait:^{
        [Photo loadPhotosFromFlickrArray:[data valueForKeyPath:FLICKR_RESULTS_PHOTOS] intoManagedObjectContext:[[FlickrDBManager sharedDBManager] context]];
        [[FlickrDBManager sharedDBManager] forceSaveUIManagedDocumentInContextBlock:YES];
    }];
    
    dispatch_queue_t fetchQ = [[FlickrFetchManager sharedFetchManager] getPlaceInfoQueue];
    dispatch_async(fetchQ, ^{
        [[FlickrDBManager sharedDBManager] forceSaveUIManagedDocumentInContextBlock:NO];
    });

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

- (dispatch_queue_t)getPlaceInfoQueue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _getPlaceInfoQueue = dispatch_queue_create(QUEUE_GET_PLACE_INFO, DISPATCH_QUEUE_SERIAL);
    });
    return _getPlaceInfoQueue;
}
@end
