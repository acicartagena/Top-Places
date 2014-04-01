//
//  AppDelegate.m
//  Top Places
//
//  Created by Angela Cartagena on 3/18/14.
//  Copyright (c) 2014 acicartagena. All rights reserved.
//

#import "AppDelegate.h"
#import "FlickrDBManager.h"
#import "FlickrFetchManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //set up context
    [FlickrDBManager sharedDBManager];
    [[FlickrFetchManager sharedFetchManager] startBackgroundSessionFlickrFetch];
    
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[FlickrDBManager sharedDBManager] forceSaveUIManagedDocumentInContextBlock:NO];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    [[FlickrFetchManager sharedFetchManager] startEphemeralSessionFlickrFetchWithCompletionHandler:completionHandler];
}

- (void)application:(UIApplication *)application handleEventsForBackgroundURLSession:(NSString *)identifier completionHandler:(void (^)())completionHandler
{
    [[FlickrFetchManager sharedFetchManager] setFlickrDownloadBackgroundURLSessionCompletionHandler:completionHandler];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[FlickrDBManager sharedDBManager] forceSaveUIManagedDocumentInContextBlock:NO];
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
