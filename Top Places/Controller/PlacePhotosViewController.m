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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
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
        }

    }];
    [task resume];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
