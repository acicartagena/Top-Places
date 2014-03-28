//
//  FlickrDBManager.m
//  Top Places
//
//  Created by Angela Cartagena on 3/28/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "FlickrDBManager.h"

@interface FlickrDBManager ()

@property (nonatomic, readwrite) BOOL isDocumentReady;
@property (strong, nonatomic) UIManagedDocument *document;

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
        NSURL *url = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] firstObject] URLByAppendingPathComponent:@"Flicrk"];
        self.document = [[UIManagedDocument alloc] initWithFileURL:url];
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

@end
