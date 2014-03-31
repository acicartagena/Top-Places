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

@interface FlickrFetchManager ()

@property (strong, nonatomic) NSURLSession *backgroundSession;
@property (strong, nonatomic) NSURLSession *ephemeralSession;

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
        
    }
    return self;
}

- (void)startBackgroundSessionFlickrFetch
{
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
