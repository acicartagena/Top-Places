//
//  PhotoPreviewCell.h
//  Top Places
//
//  Created by Angela Cartagena on 4/2/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoPreviewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbnail;
@property (weak, nonatomic) IBOutlet UILabel *photoTitleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleTextLabel;


@end
