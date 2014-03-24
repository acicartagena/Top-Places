//
//  Photo.h
//  Top Places
//
//  Created by Angela Cartagena on 3/24/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Photo : NSObject

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *description;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *farm;
@property (strong, nonatomic) NSString *server;
@property (strong, nonatomic) NSString *photoId;
@property (strong, nonatomic) NSString *secret;
@property (strong, nonatomic) NSString *originalSecret;

+ (id)photoWithDictionary:(NSDictionary *)photoDict;

@end
