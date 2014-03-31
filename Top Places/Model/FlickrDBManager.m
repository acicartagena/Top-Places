//
//  FlickrDBManager.m
//  Top Places
//
//  Created by Angela Cartagena on 3/28/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "FlickrDBManager.h"
#import "XXManagedDocument.h"

@interface FlickrDBManager ()

@property (nonatomic, readwrite) BOOL isDocumentReady;
@property (strong, nonatomic) NSURL *url;

@end

static FlickrDBManager *_instance = nil;

@implementation FlickrDBManager

+ (id)sharedDBManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[FlickrDBManager alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self){
        self.url = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject] URLByAppendingPathComponent:@"Flickr"];
        self.document = [[XXManagedDocument alloc] initWithFileURL:self.url];
        self.document.persistentStoreOptions = @{NSMigratePersistentStoresAutomaticallyOption:@(YES),NSInferMappingModelAutomaticallyOption:@(YES)};
        [self openOrCreateManagedDocument:self.url];
        self.isDocumentReady = NO;

    }
    return self;
}

- (void)openOrCreateManagedDocument:(NSURL *)url
{
    //open file
    if ([[NSFileManager defaultManager] fileExistsAtPath:[url path]]){
        [self.document openWithCompletionHandler:^(BOOL success) {
            if (success && self.document.documentState == UIDocumentStateNormal){
                self.isDocumentReady = YES;
            }
        }];
    }else{
        //create file
        [self.document saveToURL:url forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            if (success && self.document.documentState == UIDocumentStateNormal){
                self.isDocumentReady = YES;
            }
        }];
        
    }
}

//overwrite to send a notification if document is ready?
- (void)setIsDocumentReady:(BOOL)isDocumentReady
{
    _isDocumentReady = isDocumentReady;
    if (isDocumentReady){
        self.context = self.document.managedObjectContext;
    }
}

- (void)setContext:(NSManagedObjectContext *)context
{
    _context = context;
    if (context){
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CONTEXT_IS_AVAILABLE object:nil userInfo:@{CONTEXT_KEY:context}];
    }
    
}

- (void)forceSaveUIManagedDocumentInContextBlock:(BOOL) inContextBlock
{
    if (inContextBlock){
        [self forceSaveUIManagedDocument];
    }else{
        if (self.context){
            [self.context performBlockAndWait:^{
                [self forceSaveUIManagedDocument];
            }];
        }
    }
}

- (void)forceSaveUIManagedDocument
{
    [self.document updateChangeCount:UIDocumentChangeDone];
    [self.document savePresentedItemChangesWithCompletionHandler:^(NSError *errorOrNil) {
        if (errorOrNil){
            NSLog(@"error on saving: %@", errorOrNil);
        }
    }];
}


@end
