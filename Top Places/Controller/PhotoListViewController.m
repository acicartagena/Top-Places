//
//  PhotoListViewController.m
//  Top Places
//
//  Created by Angela Cartagena on 3/18/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "PhotoListViewController.h"
#import "Photo.h"
#import "FlickrFetcher.h"
#import "PhotoViewController.h"
#import "PlacePhotosViewController.h"

@interface PhotoListViewController ()

@end

@implementation PhotoListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self getPhotos];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.photoArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TABLE_CELL_PHOTO forIndexPath:indexPath];
    
    // Configure the cell...
    Photo *photo = self.photoArray[indexPath.row];
    cell.textLabel.text = photo.title;
    cell.detailTextLabel.text = photo.description;
    
    return cell;
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]] && [segue.identifier isEqualToString:SEGUE_PHOTO]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            PhotoViewController *vc = [segue destinationViewController];
            //TODO: coredata please
            Photo* photo =self.photoArray[indexPath.row];
            vc.photo = photo;
            vc.navigationItem.title = vc.photo.title;
            
            [self saveToRecentViewedPhotos:photo];
            
        }
    }
}

- (void)saveToRecentViewedPhotos:(Photo *)photo
{
    return;
}

@end
