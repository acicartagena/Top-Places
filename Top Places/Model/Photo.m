//
//  Photo.m
//  Top Places
//
//  Created by Angela Cartagena on 3/24/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "Photo.h"

@implementation Photo

+ (id)photoWithDictionary:(NSDictionary *)photoDict
{
    Photo *photo = [[Photo alloc] init];
    return photo;
}

- (NSString *)description
{
    if (!_description || [_description isEqualToString:@""]){
        return @"Unknown";
    }
    return _description;
}

@end
