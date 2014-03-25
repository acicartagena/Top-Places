//
//  PhotoViewController.h
//  Top Places
//
//  Created by Aci Cartagena on 3/24/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Photo.h"

@interface PhotoViewController : UIViewController<UIScrollViewDelegate, NSURLSessionDownloadDelegate>

@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) Photo *photo;

@end
