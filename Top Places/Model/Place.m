//
//  Place.m
//  Top Places
//
//  Created by Angela Cartagena on 3/24/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "Place.h"

@implementation Place

+ (id) placeWithDictionary:(NSDictionary *)placeDict
{
    Place *place = [[Place alloc] init];
    
    NSArray *placeContent = [(NSString *)placeDict[@"_content"] componentsSeparatedByString:@", "];
    
    place.country = [placeContent lastObject];
    place.titleLocation = [placeContent firstObject];
    place.subtitleLocation = placeContent[1];
    place.placeId = placeDict[@"place_id"];
    
    return place;
}



@end
