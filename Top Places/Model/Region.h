//
//  Region.h
//  Top Places
//
//  Created by Angela Cartagena on 3/31/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo, Photographer;

@interface Region : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * placeId;
@property (nonatomic, retain) NSNumber * photographerCount;
@property (nonatomic, retain) NSSet *photo;
@property (nonatomic, retain) NSSet *photographer;
@end

@interface Region (CoreDataGeneratedAccessors)

- (void)addPhotoObject:(Photo *)value;
- (void)removePhotoObject:(Photo *)value;
- (void)addPhoto:(NSSet *)values;
- (void)removePhoto:(NSSet *)values;

- (void)addPhotographerObject:(Photographer *)value;
- (void)removePhotographerObject:(Photographer *)value;
- (void)addPhotographer:(NSSet *)values;
- (void)removePhotographer:(NSSet *)values;

@end
