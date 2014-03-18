//
//  URLFetchManager.m
//  Top Places
//
//  Created by Angela Cartagena on 3/18/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "URLFetchManager.h"

static URLFetchManager *_instance = nil;

@implementation URLFetchManager

+ (id)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[URLFetchManager alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self){
        
    }
    return self;
}
@end
