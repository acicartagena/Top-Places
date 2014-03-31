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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"region == %@",self.region];
    request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES]];
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.region.managedObjectContext sectionNameKeyPath:nil
                                                                                   cacheName:nil];
//    [self.tableView reloadData];
}





@end
