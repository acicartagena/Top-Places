//
//  Photo+Flickr.m
//  Top Places
//
//  Created by Angela Cartagena on 3/28/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "Photo+Flickr.h"

#import "FlickrFetcher.h"
#import "FlickrDBManager.h"
#import "Photographer+Flickr.h"
#import "Region+Flickr.h"

@implementation Photo (Flickr)

+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary
        inManagedObjectContext:(NSManagedObjectContext *)context
               checkIfExisting:(BOOL)checkIfExisting
{
    Photo *photo = nil;
    
    if (checkIfExisting){
        
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
        request.predicate = [NSPredicate predicateWithFormat:@"photoId == %@",photoDictionary[FLICKR_PHOTO_ID]];
        
        NSError *error;
        NSArray *matches = [context executeFetchRequest:request error:&error];
        photo = [matches lastObject];
    }
    
    photo = photo ? photo:[Photo photoWithFlickrInfo:photoDictionary inManagedObjectContext:context];
    return photo;
}


+ (Photo *)photoWithFlickrInfo:(NSDictionary *)photoDictionary
        inManagedObjectContext:(NSManagedObjectContext *)context
{

    Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo"
                                          inManagedObjectContext:context];
    
    photo.photoId = photoDictionary[FLICKR_PHOTO_ID];
    photo.title = [photoDictionary valueForKeyPath:FLICKR_PHOTO_TITLE];
    photo.subtitle = [photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    photo.photoUrl = [[FlickrFetcher URLforPhoto:photoDictionary format:FlickrPhotoFormatLarge] absoluteString];
    
    NSString *photographerName = [photoDictionary valueForKeyPath:FLICKR_PHOTO_OWNER];
    photo.photographer = [Photographer photographerWithName:photographerName
                                inManagedObjectContext:context];
    NSString *placeId = [photoDictionary valueForKeyPath:FLICKR_PHOTO_PLACE_ID];
    photo.region = [Region regionWithPlaceId:placeId inManagedObjectContext:context];
    
    if (photo.region && photo.photographer){
        [photo.region addPhotographerObject:photo.photographer];
    }
    
    return photo;
}

+ (void)loadPhotosFromFlickrArray:(NSArray *)photos // of Flickr NSDictionary
         intoManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *photoIds = [photos valueForKey:FLICKR_PHOTO_ID];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@" photoId in %@",photoIds];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    NSMutableArray *photosMutable = [photos mutableCopy];
    if (matches){
        [photosMutable removeObjectsInArray:matches];
    }
    
    for (NSDictionary *photoDict in photosMutable){
        [Photo photoWithFlickrInfo:photoDict inManagedObjectContext:context checkIfExisting:NO];
    }
}

@end
