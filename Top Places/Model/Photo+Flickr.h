//
//  Photo+Flickr.h
//  Top Places
//
//  Created by Angela Cartagena on 3/28/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "Photo.h"

@interface Photo (Flickr)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary
        inManagedObjectContext:(NSManagedObjectContext *)context
               checkIfExisting:(BOOL)checkIfExisting;

//+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary
//        inManagedObjectContext:(NSManagedObjectContext *)context;



+ (void)loadPhotosFromFlickrArray:(NSArray *)photos // of Flickr NSDictionary
         intoManagedObjectContext:(NSManagedObjectContext *)context;

@end
