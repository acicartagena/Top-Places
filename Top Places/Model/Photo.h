//
//  Photo.h
//  Top Places
//
//  Created by Angela Cartagena on 3/31/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photographer, Region;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSDate * lastViewed;
@property (nonatomic, retain) NSString * photoId;
@property (nonatomic, retain) NSString * photoUrl;
@property (nonatomic, retain) NSString * subtitle;
@property (nonatomic, retain) NSData * thumbnail;
@property (nonatomic, retain) NSString * thumbnailUrl;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) Photographer *photographer;
@property (nonatomic, retain) Region *region;

@end
