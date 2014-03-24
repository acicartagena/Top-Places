//
//  Photo.m
//  Top Places
//
//  Created by Angela Cartagena on 3/24/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "Photo.h"
#import "FlickrFetcher.h"

@implementation Photo

+ (id)photoWithDictionary:(NSDictionary *)photoDict
{
    Photo *photo = [[Photo alloc] init];
    photo.photoId = photoDict[FLICKR_PHOTO_ID];
    photo.title = photoDict[FLICKR_PHOTO_TITLE];
    photo.description = photoDict[FLICKR_PHOTO_DESCRIPTION];
    photo.farm = photoDict[@"farm"];
    photo.server = photoDict[@"server"];
    photo.secret = photoDict[@"secret"];
    photo.originalSecret = photoDict[@"originalsecret"];
    photo.originalFormat = photoDict[@"originalformat"];
    photo.owner = photoDict[@"ownername"];
    
    return photo;
}

- (NSString *)title
{
    if (!_title || [_title isEqualToString:@""]){
        if (!_description || [_description isEqualToString:@""]){
            _title = @"Unknown";
        }else{
            _title = _description;
        }
    }
    return _title;
}

@end
