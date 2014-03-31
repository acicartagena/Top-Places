//
//  FlickrFetchManager.h
//  Top Places
//
//  Created by Angela Cartagena on 3/28/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrFetchManager : NSObject <NSURLSessionDownloadDelegate>

+ (instancetype)sharedFetchManager;

- (void)startBackgroundSessionFlickrFetch;
- (dispatch_queue_t)getPlaceInfoQueue;

@end
