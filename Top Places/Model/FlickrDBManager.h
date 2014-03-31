//
//  FlickrDBManager.h
//  Top Places
//
//  Created by Angela Cartagena on 3/28/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FlickrDBManager : NSObject

@property (strong, nonatomic) UIManagedDocument *document;
@property (nonatomic, readonly) BOOL isDocumentReady;
@property (strong, nonatomic) NSManagedObjectContext *context;

+ (id)sharedDBManager;

- (void)forceSaveUIManagedDocumentInContextBlock:(BOOL) inContextBlock;

@end
