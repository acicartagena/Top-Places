//
//  PlacePhotosViewController.m
//  Top Places
//
//  Created by Angela Cartagena on 3/24/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "PlacePhotosViewController.h"
#import "FlickrFetcher.h"
#import "Photo.h"

@interface PlacePhotosViewController ()

@end

@implementation PlacePhotosViewController

- (void)getPhotos
{
    NSURL *url = [FlickrFetcher URLforPhotosInPlace:self.place.placeId maxResults:MAX_PLACE_PHOTOS_COUNT];
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
        NSLog(@"data: %@", dataDictionary);
        //parse data
        //TODO: coredata please
        if ([dataDictionary isKindOfClass:[NSDictionary class]] && [dataDictionary[@"photos"] isKindOfClass:[NSDictionary class]]){
            NSMutableArray *tempPhotos = [[NSMutableArray alloc] init];
            for (NSDictionary *photoDict in [dataDictionary valueForKeyPath:FLICKR_RESULTS_PHOTOS]){
                [tempPhotos addObject:[Photo photoWithDictionary:photoDict]];
            }
            self.photoArray = [tempPhotos copy];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
            });
        }
        
    }];
    [task resume];
}


//TODO: core data pleeeeaaase
- (void)saveToRecentViewedPhotos:(Photo *)photo
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSArray *recentPhotosArray = [userDefaults objectForKey:MOST_RECENT_PHOTOS_VIEWED_KEY];
    NSMutableArray *temp;
    if (!recentPhotosArray){
        temp = [[NSMutableArray alloc] initWithCapacity:1];
    }else{
        temp = [[NSMutableArray alloc] initWithArray:recentPhotosArray];
    }
    if (temp.count > MAX_MOST_RECENT_VIEWED_COUNT-1) {
        [temp removeObjectAtIndex:0];
    }
    if ([[temp valueForKey:FLICKR_PHOTO_PHOTO_URL] containsObject:photo.photoUrl.absoluteString]){
        return;
    }
    NSString *title = photo.title ? photo.title: @"";
    NSString *description = photo.description ? photo.description: @"";
    [temp addObject:@{FLICKR_PHOTO_TITLE:title, FLICKR_PHOTO_DESCRIPTION:description, FLICKR_PHOTO_PHOTO_URL:photo.photoUrl.absoluteString, FLICKR_PHOTO_DATE_VIEWED:[NSDate date]}];
    NSLog(@"TEMP ARRAY: %@",temp);
    [userDefaults setObject:temp forKey:MOST_RECENT_PHOTOS_VIEWED_KEY];
    [userDefaults synchronize];
}

@end
