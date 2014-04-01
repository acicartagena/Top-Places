//
//  Region+Flickr.m
//  Top Places
//
//  Created by Angela Cartagena on 3/28/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "Region+Flickr.h"
#import "FlickrFetcher.h"
#import "FlickrFetchManager.h"
#import "FlickrDBManager.h"

static dispatch_queue_t _getPlaceInfoQueue;

@implementation Region (Flickr)

+ (dispatch_queue_t)getPlaceInfoQueue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _getPlaceInfoQueue = dispatch_queue_create(QUEUE_GET_PLACE_INFO, DISPATCH_QUEUE_SERIAL);
    });
    return _getPlaceInfoQueue;
}

+ (Region *)regionWithPlaceId:(NSString *)placeId inManagedObjectContext:(NSManagedObjectContext *)context
{
    Region *region  = nil;
    
    if (![placeId length]){
        return region;
    }
    region = [NSEntityDescription insertNewObjectForEntityForName:@"Region" inManagedObjectContext:context];
    region.placeId = placeId;
    region.photographerCount = @1;
    [region fetchAndUpdateRegionName];

    return region;
    
}

- (void) fetchAndUpdateRegionName
{
    NSURL *fetchRegionName = [FlickrFetcher URLforInformationAboutPlace:self.placeId];
    NSLog(@"Region+Flickr: fetchAndUpdateRegionName: url: %@",fetchRegionName);
    
    __weak typeof(self) weakSelf = self;
    
    dispatch_queue_t fetchQ = [[self class] getPlaceInfoQueue];
    dispatch_async(fetchQ, ^{
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        NSData *jsonResults = [NSData dataWithContentsOfURL:fetchRegionName];
        if (!jsonResults){
            return;
        }
        
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:jsonResults options:0 error:NULL];
        if (![dataDictionary isKindOfClass:[NSDictionary class]]){
            return;
        }
        
        NSString *regionName = [FlickrFetcher extractRegionNameFromPlaceInformation:dataDictionary];
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
        request.predicate = [NSPredicate predicateWithFormat:@"name == %@", regionName];
        NSError *error;
        NSArray *array = [weakSelf.managedObjectContext executeFetchRequest:request error:&error];
        if (!array){
            return;
        }
        
        [self.managedObjectContext performBlockAndWait:^{
            if (array.count > 0){
                Region *originalRegion = [array lastObject];
                [originalRegion addPhoto:weakSelf.photo];
                [originalRegion addPhotographer:weakSelf.photographer];
                originalRegion.placeId = [dataDictionary valueForKeyPath:FLICKR_PLACE_REGION_PLACE_ID];
                originalRegion.photographerCount = @(weakSelf.photographer.count + [originalRegion.photographerCount intValue]);
                [weakSelf.managedObjectContext deleteObject:weakSelf];
//                [[FlickrDBManager sharedDBManager] forceSaveUIManagedDocumentInContextBlock:YES];
            }else{
                weakSelf.name = regionName;
                [[FlickrDBManager sharedDBManager] forceSaveUIManagedDocumentInContextBlock:YES];
            }
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
    });
}

@end
