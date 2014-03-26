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
    photo.originalSecret = photoDict[@"originalsecret"] ? photoDict[@"originalsecret"]: @"";
    photo.originalFormat = photoDict[@"originalformat"] ? photoDict[@"originalformat"]: @"";
    photo.owner = photoDict[@"ownername"];
    photo.photoUrl = photoDict[FLICKR_PHOTO_PHOTO_URL] ? [NSURL URLWithString:photoDict[FLICKR_PHOTO_PHOTO_URL]]:nil;
    
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

- (NSURL *)photoUrl
{
    if (!_photoUrl) {
        _photoUrl = [FlickrFetcher URLforPhoto:@{@"farm":self.farm, @"server":self.server, @"id":self.photoId, @"secret":self.secret, @"originalsecret":self.originalSecret, @"originalformat":self.originalFormat} format:FlickrPhotoFormatLarge];
    }
    return _photoUrl;
}


@end
