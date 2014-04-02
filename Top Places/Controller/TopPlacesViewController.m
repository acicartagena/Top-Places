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
#import "FlickrDBManager.h"
#import "Photo.h"


static NSString *const PLACE_ID_KEY = @"place_id";
static NSString *const TITLE_KEY = @"title location";
static NSString *const COUNTRY_KEY = @"country";
static NSString *const SUBTITLE_KEY = @"subtitle location";

@interface TopPlacesViewController ()

@property (strong, nonatomic) __block NSMutableArray *places;
@property (strong, nonatomic) NSArray *countries;


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
    self.debug = YES;
    
    //setup fetch results controller
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Region"];
    request.predicate = [NSPredicate predicateWithFormat:@"name != nil"];
    request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"photographerCount" ascending:NO], [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    request.fetchLimit = MAX_PLACE_PHOTOS_COUNT;
    
    [self setupFetchResultsControllerWith:request];

    //remove empty cells at end of the table
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    
}

- (void)setupFetchResultsControllerWith:(NSFetchRequest *)request
{
    [[NSNotificationCenter defaultCenter] addObserverForName:NOTIFICATION_CONTEXT_IS_AVAILABLE object:nil queue:nil usingBlock:^(NSNotification *note) {
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:note.userInfo[CONTEXT_KEY]
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
        [self.tableView reloadData];
    }];
    
    NSManagedObjectContext *context = [[FlickrDBManager sharedDBManager] context];
    if (!self.fetchedResultsController && context){
        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                            managedObjectContext:context
                                                                              sectionNameKeyPath:nil
                                                                                       cacheName:nil];
        [self.tableView reloadData];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_CONTEXT_IS_AVAILABLE object:nil];
}


#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TABLE_CELL_ID_TOP_PLACES forIndexPath:indexPath];
    
    Region *region = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = region.name;
    cell.detailTextLabel.text = [region.photographerCount integerValue] > 1 ? [NSString stringWithFormat:@"%i active photographers",[region.photographerCount integerValue]]:[NSString stringWithFormat:@"%i active photographer",[region.photographerCount integerValue]];
    
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
