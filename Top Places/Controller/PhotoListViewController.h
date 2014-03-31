//
//  PhotoListViewController.h
//  Top Places
//
//  Created by Angela Cartagena on 3/18/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataTableViewController.h"

@interface PhotoListViewController : CoreDataTableViewController

@property (strong, nonatomic) __block NSArray *photoArray;

@end
