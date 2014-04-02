//
//  MostRecentViewController.m
//  Top Places
//
//  Created by Angela Cartagena on 3/18/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "MostRecentViewController.h"
#import "FlickrFetchManager.h"
#import "FlickrDBManager.h"

@interface MostRecentViewController ()

@end

@implementation MostRecentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Most Recent";
    
    //setup fetch results controller
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Photo"];
    request.predicate = [NSPredicate predicateWithFormat:@"lastViewed != nil"];
    request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"lastViewed" ascending:NO]];
    request.fetchLimit = MAX_MOST_RECENT_VIEWED_COUNT;
    
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

@end
