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

static dispatch_queue_t _getThumbnailQueue;

@implementation Photo (Flickr)

+ (dispatch_queue_t) getThumbnailQueue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _getThumbnailQueue = dispatch_queue_create(QUEUE_GET_THUMBNAIL, DISPATCH_QUEUE_SERIAL);
    });
    return _getThumbnailQueue;
}

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
    photo.title = photoDictionary[FLICKR_PHOTO_TITLE];
    photo.subtitle = [photoDictionary valueForKeyPath:FLICKR_PHOTO_DESCRIPTION];
    NSLog(@"photo title: %@ subtitle: %@", photo.title, photo.subtitle);
    photo.photoUrl = [[FlickrFetcher URLforPhoto:photoDictionary format:FlickrPhotoFormatLarge] absoluteString];
    photo.thumbnailUrl = [[FlickrFetcher URLforPhoto:photoDictionary format:FlickrPhotoFormatSquare] absoluteString];
    
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
    //get existing photos, using photo ids
    NSArray *photoIds = [photos valueForKey:FLICKR_PHOTO_ID];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@" photoId in %@",photoIds];
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    //filter array using retrieved photo ids
    NSArray *matchesId = [matches valueForKey:@"photoId"];
    NSPredicate *existingIdsPredicate = [NSPredicate predicateWithFormat:@" NOT (id in %@)", matchesId];
    NSArray *photosToAdd = [photos filteredArrayUsingPredicate:existingIdsPredicate];
    
    for (NSDictionary *photoDict in photosToAdd){
        [Photo photoWithFlickrInfo:photoDict inManagedObjectContext:context checkIfExisting:NO];
    }
}

- (UIImage *)getThumbnail
{
    __block NSData *tempThumbnailData = self.thumbnail;
    __weak typeof(self) weakSelf = self;
    if (!tempThumbnailData){
        dispatch_queue_t fetchQ = [[self class] getThumbnailQueue];
        dispatch_async(fetchQ, ^{
            
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
            
            tempThumbnailData = [NSData dataWithContentsOfURL:[NSURL URLWithString:weakSelf.thumbnailUrl]];
            if (!tempThumbnailData){
                return;
            }
            
            [self.managedObjectContext performBlockAndWait:^{
                weakSelf.thumbnail = tempThumbnailData;
                [[FlickrDBManager sharedDBManager] forceSaveUIManagedDocumentInContextBlock:YES];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];

            }];
        });
        return nil;
    }
    UIImage *tempThumbnail = [UIImage imageWithData:tempThumbnailData];
    return tempThumbnail;
}

- (void)updateLastViewedDate:(NSDate *)date
{
    __weak typeof(self) weakSelf = self;
    [self.managedObjectContext performBlockAndWait:^{
        weakSelf.lastViewed = date;
        [[FlickrDBManager sharedDBManager] forceSaveUIManagedDocumentInContextBlock:YES];
    }];
}

@end
