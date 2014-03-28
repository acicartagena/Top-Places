//
//  FlickrDBManager.h
//  Top Places
//
//  Created by Angela Cartagena on 3/28/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrDBManager : NSObject


@property (nonatomic, readonly) BOOL isDocumentReady;
@property (strong, nonatomic) NSManagedObjectContext *context;

+ (id)sharedDBManager;

@end
