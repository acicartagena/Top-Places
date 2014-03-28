//
//  Region+Flickr.m
//  Top Places
//
//  Created by Angela Cartagena on 3/28/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "Region+Flickr.h"
#import "FlickrFetcher.h"

@implementation Region (Flickr)

+ (Region *)regionWithPlaceId:(NSString *)placeId inManagedObjectContext:(NSManagedObjectContext *)context
{
    Region *region  = nil;
    
    if (![placeId length]){
        return region;
    }

    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
    request.predicate = [NSPredicate predicateWithFormat:@" placeId == %@", placeId];
    
    NSError *error;
    NSArray *matches = [context executeFetchRequest:request error:&error];
    
    if (!matches){
        //handle error
    }else if (matches.count > 0){
        region = matches.lastObject;
        if (!region.name){
            [region fetchAndUpdateRegionName];
        }
    }else{
        region = [NSEntityDescription insertNewObjectForEntityForName:@"Region" inManagedObjectContext:context];
        region.placeId = placeId;
        [region fetchAndUpdateRegionName];
    }

    return region;
    
}

- (void) fetchAndUpdateRegionName
{
    NSURL *fetchRegionName = [FlickrFetcher URLforInformationAboutPlace:self.placeId];
    NSLog(@"Region+Flickr: fetchAndUpdateRegionName: url: %@",fetchRegionName);
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfig];
    NSURLSessionDataTask *task = [session dataTaskWithURL:fetchRegionName completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSLog(@"data: %@", dataDictionary);
        
        if ([dataDictionary isKindOfClass:[NSDictionary class]]){
            self.name = [FlickrFetcher extractRegionNameFromPlaceInformation:dataDictionary];
        }
    }];
    [task resume];
}

@end
