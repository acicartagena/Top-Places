//
//  Constants.h
//  Top Places
//
//  Created by Angela Cartagena on 3/18/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import <Foundation/Foundation.h>

//table cell identifiers
static NSString *const TABLE_CELL_ID_TOP_PLACES  = @"TopPlacesCell";
static NSString *const TABLE_CELL_ID_MOST_RECENT = @"MostRecentCell";
static NSString *const TABLE_CELL_PHOTO = @"PhotoCell";

//segue identifiers
static NSString *const SEGUE_PLACE_PHOTOS = @"Get Place Photos";
static NSString *const SEGUE_PHOTO = @"Get Photo";

static int const MAX_PLACE_PHOTOS_COUNT = 50;
static int const MAX_MOST_RECENT_VIEWED_COUNT = 20;

static NSString *const MOST_RECENT_PHOTOS_VIEWED_KEY = @"MostRecentPhotosViewedArray";

static NSString *const FLICKR_PHOTO_PHOTO_URL = @"photoUrl";
static NSString *const FLICKR_PHOTO_DATE_VIEWED = @"dateViewed";


static NSString *const APP_BACKGROUND_PHOTO_FETCH = @"TopPlacesPhotoFetch";

static NSString *const NOTIFICATION_CONTEXT_IS_AVAILABLE = @"ContextIsReadyNotification";
static NSString *const CONTEXT_KEY = @"context";

#define QUEUE_GET_PLACE_INFO "GetPlaceInfoQueue"
