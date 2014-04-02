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
#import "PhotoPreviewCell.h"
#import "Photo+Flickr.h"

@interface PhotoListViewController ()

@end

@implementation PhotoListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    self.tableView.rowHeight = PHOTO_TABLE_VIEW_CELL_HEIGHT;
}


#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoPreviewCell *cell = [tableView dequeueReusableCellWithIdentifier:TABLE_CELL_PHOTO forIndexPath:indexPath];
    
    // Configure the cell...
    Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.photoTitleTextLabel.text= photo.title;
    cell.subtitleTextLabel.text = photo.photoId;
    cell.thumbnail.image = [photo getThumbnail];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // get the Detail view controller in our UISplitViewController (nil if not in one)
    id detail = self.splitViewController.viewControllers[1];
    // if Detail is a UINavigationController, look at its root view controller to find it
    if ([detail isKindOfClass:[UINavigationController class]]) {
        detail = [((UINavigationController *)detail).viewControllers firstObject];
    }
    // is the Detail is an ImageViewController?
    if ([detail isKindOfClass:[PhotoViewController class]]) {
        Photo *photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
        ((PhotoViewController *)detail).photo = photo;
        ((PhotoViewController *)detail).navigationItem.title = photo.title;
    }
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]] && [segue.identifier isEqualToString:SEGUE_PHOTO]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            PhotoViewController *vc = [segue destinationViewController];

            Photo* photo = [self.fetchedResultsController objectAtIndexPath:indexPath];
            vc.photo = photo;
            vc.navigationItem.title = vc.photo.title;
        }
    }
}


@end
