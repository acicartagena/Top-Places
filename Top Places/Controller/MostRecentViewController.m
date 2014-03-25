//
//  MostRecentViewController.m
//  Top Places
//
//  Created by Angela Cartagena on 3/18/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "MostRecentViewController.h"

@interface MostRecentViewController ()

@end

@implementation MostRecentViewController

- (void)getPhotos
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *tempPhotos = [[NSMutableArray alloc] initWithCapacity:MAX_MOST_RECENT_VIEWED_COUNT];
    if ([[userDefaults objectForKey:MOST_RECENT_PHOTOS_VIEWED_KEY] isKindOfClass:[NSArray class]]){
        for (NSDictionary *photoDict in [userDefaults objectForKey:MOST_RECENT_PHOTOS_VIEWED_KEY]){
            [tempPhotos addObject:[Photo photoWithDictionary:photoDict]];
        }
        self.photoArray = [tempPhotos copy];
    }
    [self.tableView reloadData];
}

@end
