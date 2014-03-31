//
//  PlacePhotosViewController.h
//  Top Places
//
//  Created by Angela Cartagena on 3/24/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "PhotoListViewController.h"
#import "Region.h"

@interface PlacePhotosViewController : PhotoListViewController


@property (strong, nonatomic) Region *region;
@property (strong, nonatomic) NSString *placeId;



@end
