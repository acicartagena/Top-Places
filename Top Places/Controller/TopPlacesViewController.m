//
//  TopPlacesViewController.m
//  Top Places
//
//  Created by Angela Cartagena on 3/18/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "TopPlacesViewController.h"
#import "PlacePhotosViewController.h"
#import "FlickrFetcher.h"
#import "Place.h"

static NSString *const PLACE_ID_KEY = @"place_id";
static NSString *const TITLE_KEY = @"title location";
static NSString *const COUNTRY_KEY = @"country";
static NSString *const SUBTITLE_KEY = @"subtitle location";

@interface TopPlacesViewController ()

@property (strong, nonatomic) __block NSMutableArray *places;
@property (strong, nonatomic) NSArray *countries;
@property (strong, nonatomic) Place *selectedPlace;

@end

@implementation TopPlacesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Top Places";
    
}
//
//- (void)getPhotos
//{
//    NSURL *url = [FlickrFetcher URLforTopPlaces];
//    
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration ephemeralSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
//    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
//    NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
//        NSLog(@"data: %@", dataDictionary);
//        
//        //parse data
//        //TODO: coredata please
//        if ([dataDictionary isKindOfClass:[NSDictionary class]] && [dataDictionary[@"places"] isKindOfClass:[NSDictionary class]]){
//            NSMutableArray *tempPlaces = [[NSMutableArray alloc] init];
//            for (NSDictionary *placeDict in [dataDictionary valueForKeyPath:FLICKR_RESULTS_PLACES]){
//                [tempPlaces addObject:[Place placeWithDictionary:placeDict]];
//            }
//            
//            NSArray *countries = [[tempPlaces valueForKeyPath:@"@distinctUnionOfObjects.country"] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
//            for (NSString *keyCountry in countries){
//                NSArray *placesInCountry = [tempPlaces filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"country = %@",keyCountry]];
//                [self.places addObject:@{@"country":keyCountry,@"places":placesInCountry}];
//            }
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self.tableView reloadData];
//                [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
//            });
//        }
//    }];
//    [task resume];
//}

//- (NSMutableArray *)places
//{
//    if (!_places){
//        _places = [[NSMutableArray alloc] initWithCapacity:100];
//    }
//    return _places;
//}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TABLE_CELL_ID_TOP_PLACES forIndexPath:indexPath];
    
    Region *region = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = region.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%i photographers",region.photographer.count];
    
    return cell;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]] && [segue.identifier isEqualToString:SEGUE_PLACE_PHOTOS] && [segue.destinationViewController isKindOfClass:[PlacePhotosViewController class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            PlacePhotosViewController *vc = [segue destinationViewController];

            vc.region = [self.fetchedResultsController objectAtIndexPath:indexPath];
            vc.navigationItem.title = [NSString stringWithFormat:@"%@'s Photos",vc.region.name];
        }
    }
}


@end
