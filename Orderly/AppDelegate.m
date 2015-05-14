//
//  AppDelegate.m
//  OmniSplit
//
//  Created by Ashley Sehatti on 12/6/14.
//  Copyright (c) 2014 Santa Clara University. All rights reserved.
//

#import "AppDelegate.h"
#import "Group.h"
#import "OrderStatusViewController.h"
#import "SplitPaymentTableViewController.h"
#import "ReviewOrderViewController.h"
#import "Order.h"

@implementation AppDelegate

@synthesize thisUser, theMenu;

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))handler
{
    //Silent push handler
    if([userInfo[@"aps"][@"content-available"] intValue] == 1) //it's the silent notification
    {
        if ([userInfo[@"aps"][@"category"] isEqualToString:@"UPDATE_INFO"] &&
            -            ![userInfo[@"id"] isEqualToString:[thisUser iD]]) { //Update notification
            NSLog(@"Updating group info...");
            [thisUser.group updateGroupFromServer];
        }
        else if ([userInfo[@"aps"][@"category"] isEqualToString:@"SPLIT_PAYMENT"] &&
                 [userInfo[@"group_members"] containsObject:[thisUser iD]] &&
                 ![userInfo[@"group_members"][0] isEqualToString:[thisUser iD]]) {
            //If you get a SPLIT_PAYMENT alert, you are in the list to split with, and you didn't send the SPLIT_PAYMENT alert
            
            NSArray * usersToSplit = userInfo[@"group_members"];
            NSString * foodName = userInfo[@"item_name"];
            UINavigationController* navc = (UINavigationController *) [application.windows[0] rootViewController];
            SplitPaymentTableViewController * vc = (SplitPaymentTableViewController* ) [navc visibleViewController];
            [vc addPartial:[theMenu menuItemForName:foodName] byAmount:[usersToSplit count]];
        }
        else if ([userInfo[@"aps"][@"category"] isEqualToString:@"MOVE_TO_PAYMENT"]) {
            thisUser.group.order.status = SUBMITTED;
            NSLog(@"ALL ORDERS HAVE BEEN SUBMITTED");
        }
        else {
            NSLog(@"Recieved silent push notification with no specified action (could be a push notification you just sent).");
        }
        
        handler(UIBackgroundFetchResultNewData);
        return;
    }
    else
    {
        handler(UIBackgroundFetchResultNoData);
        return;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSString *lastUserId = (NSString *)[[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
    if (lastUserId == nil)     // App first run: set up user defaults.
    {
        lastUserId = [NSString stringWithFormat:@"%@%u", @"b", arc4random_uniform(UINT32_MAX)];
    }
    [[NSUserDefaults standardUserDefaults] setObject:lastUserId forKey:@"userId"];
    
    thisUser = [[User alloc]initWithID:lastUserId];
    
    [Parse enableLocalDatastore];
    //Initialize parse
    [Parse setApplicationId:@"MVCMs63fngTKmMzuscAPyFPFN8faHDJyQAij7lXa"
                  clientKey:@"TrJEacJTH5XrXABEUjc6yOtYrnLdzSuhqJP79Rmz"];
    
    UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert |
                                                     UIUserNotificationTypeBadge |
                                                     UIUserNotificationTypeSound
                                          categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    currentInstallation.channels = @[ @"global" ];
    [currentInstallation saveInBackground];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    [PFPush handlePush:userInfo];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    NSLog(@"Saving group order...");
    [thisUser leaveGroup];
}

@end
