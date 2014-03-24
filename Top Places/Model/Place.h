//
//  Place.h
//  Top Places
//
//  Created by Angela Cartagena on 3/24/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Place : NSObject

@property (strong, nonatomic) NSString *placeId;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *titleLocation;
@property (strong, nonatomic) NSString *subtitleLocation;

+ (id) placeWithDictionary:(NSDictionary *)placeDict;

@end
