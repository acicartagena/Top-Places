//
//  Region+Flickr.h
//  Top Places
//
//  Created by Angela Cartagena on 3/28/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "Region.h"

@interface Region (Flickr)

+ (Region *)regionWithPlaceId:(NSString *)placeId
       inManagedObjectContext:(NSManagedObjectContext *)context;

- (void) fetchAndUpdateRegionName;

@end
