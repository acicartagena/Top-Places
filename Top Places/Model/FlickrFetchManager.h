//
//  FlickrFetchManager.h
//  Top Places
//
//  Created by Angela Cartagena on 3/28/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrFetchManager : NSObject <NSURLSessionDownloadDelegate>

@property (copy, nonatomic) void (^flickrDownloadBackgroundURLSessionCompletionHandler)();

+ (instancetype)sharedFetchManager;

- (void)startBackgroundSessionFlickrFetch;
- (void)startEphemeralSessionFlickrFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHanlder;

@end
