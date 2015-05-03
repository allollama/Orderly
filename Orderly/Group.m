//
//  Group.m
//  OmniSplit
//
//  Created by Ashley Sehatti on 1/29/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import "Group.h"
#import "User.h"
#import "Order.h"
#import "AppDelegate.h"
#import <stdlib.h>
#import <Parse/Parse.h>

@implementation Group

@synthesize iD, order, members; //JORDAN take a look at this whole file

- (instancetype) initWithID:(NSString *)_iD {
    if (self = [super init]) {
        iD = _iD;
        members = [[NSMutableArray alloc] init];
        order = [[Order alloc] init];
    }
    return self;
}

- (void) joinChannelWithRestaurauntId: (NSString *) restaurantId
                     andOrderingGroup: orderingGroup {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString * channel = [NSString stringWithFormat:@"%@%@%@", @"a", restaurantId, orderingGroup];

    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setObject:@[@"Global", channel]
                            forKey:@"channels"];
    [currentInstallation saveInBackground];
    NSLog(@"Joined channel %@", channel);
    
    //Add user to channel on Parse
    PFQuery * query = [PFQuery queryWithClassName:@"CurrentOrder"];
    [query whereKey:@"userId" equalTo:[appDelegate.thisUser iD]];
    
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (object != nil) { //Order exists, reset it
            [object setValue:@[] forKey:@"currentOrder"];
            [object setValue:channel forKey:@"channel"];
            [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                self.iD = channel;
                [self sendSilentPushToGroup: channel];
            }];
        }
        else { //User does not exist, create new order for them
            PFObject * newObject = [PFObject objectWithClassName:@"CurrentOrder"];
            [newObject setObject:channel forKey:@"channel"];
            [newObject setObject:[appDelegate.thisUser iD] forKey:@"userId"];
            [newObject setObject:@[] forKey:@"currentOrder"];
            [newObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
                self.iD = channel;
                [self sendSilentPushToGroup: channel];
            }];
        }
    }];
}

- (void) sendSilentPushToGroup: (NSString *) groupId {
    NSDictionary *data = @{
                           @"content-available": @1,
                           @"sound": @""
                           };
    
    PFPush *push = [[PFPush alloc] init];
    [push setChannels:@[ groupId ]];
    [push setData:data];
    [push sendPushInBackground];
}

- (void) leaveChannel {
    //Remove from ordering channel
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    currentInstallation.channels = @[ @"Global" ];
    [currentInstallation saveEventually];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PFQuery * query = [PFQuery queryWithClassName:@"CurrentOrder"];
    [query whereKey:@"userId" equalTo:[appDelegate.thisUser iD]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *object in objects) {
                NSString * channel = [object objectForKey:@"channel"];
                [object deleteInBackground];
                [self sendSilentPushToGroup: channel];
            }
            NSLog(@"Left channel.");
        }
        else {
            NSLog(@"Error leaving channel.");
        }
    }];
}

- (void) leaveChannelImmidiately {
    //Remove from ordering channel
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    currentInstallation.channels = @[ @"Global" ];
    [currentInstallation saveEventually];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PFQuery * query = [PFQuery queryWithClassName:@"CurrentOrder"];
    [query whereKey:@"userId" equalTo:[appDelegate.thisUser iD]];
    PFObject * object = [query getFirstObject];
    [object delete];
}

- (void) updateGroupFromServer {
    /*[members removeAllObjects];
    //get a list of group members from server (an array with just their ids)
    //use addGroupMember method that takes an iD for each user - but don't send this user
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PFQuery * query = [PFQuery queryWithClassName:@"CurrentOrder"];
    [query whereKey:@"channel" equalTo:[appDelegate.thisUser.group iD]];
    [query selectKeys:@[@"userId", @"currentOrder"]];
    [query findObjectsInBackgroundWithBlock: ^(NSArray *objects, NSError *error) {
        if (!error) {
            for (int i = 0; i < [objects count]; i++)
                [self addGroupMemberWithID:[objects[i] objectForKey:@"userId"]
                                 withOrder:[objects[i] objectForKey:@"currentOrder"]];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

    [self updateOrder];*/
}

- (int) hasGroupMemberWithID: (NSString*) _iD {
    for (int i = 0; i < members.count; i++) {
        if (((User*)members[i]).iD == _iD)
            return i;
    }
    return -1; //group doesn't already have member with that id
}

- (void) addGroupMemberWithID: (NSString*) _iD
                    withOrder: (NSString*) jsonOrder {
    if ([self hasGroupMemberWithID:_iD] == -1) {
        User* user = [[User alloc] initWithID:_iD];
        [user parseOrder:jsonOrder];
        [self addGroupMember:user];
    }
}

- (void) addGroupMember:(User *)user {
    if ([self hasGroupMemberWithID:user.iD] == -1) {
        [members addObject:user];
        [self updateOrder];
    }
}

- (void) addItemToOrder: (NSString *) foodName {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PFQuery * query = [PFQuery queryWithClassName:@"CurrentOrder"];
    [query whereKey:@"channel" equalTo:iD];
    [query whereKey:@"userId" equalTo:[appDelegate.thisUser iD]];
    [query selectKeys:@[@"currentOrder"]];
    [query getFirstObjectInBackgroundWithBlock: ^(PFObject *jsonObject, NSError *error) {
        if (!error) {
            //NSMutableArray * newOrder = [[NSMutableArray alloc] initWithObjects:jsonObject[@"currentOrder"], nil];
            BOOL itemFound = NO;
            for (int i = 0; i < [jsonObject[@"currentOrder"] count]; i++) {
                if ([jsonObject[@"currentOrder"][i][@"name"] isEqualToString:foodName]) { //Found food name, increment counter
                    [jsonObject[@"currentOrder"][i] setObject: [NSString stringWithFormat:@"%d", [jsonObject[@"currentOrder"][i][@"count"] intValue] + 1]
                                                       forKey: @"count"];
                    itemFound = YES;
                }
            }
            if (!itemFound) { //Food name not found, add new item to order
                [jsonObject[@"currentOrder"] addObject:[[NSMutableDictionary alloc] initWithObjects:@[foodName, @1]
                                                                         forKeys:@[@"name", @"count"]]]; //ERROR IS HERE
            }
            [jsonObject saveInBackgroundWithBlock:^(BOOL success, NSError *error) {
                if (!error) {
                    if (success) { //Item successfully added to order
                        NSLog(@"Item successfully added to order. Sending push notification...");
                        [self sendSilentPushToGroup:iD];
                    }
                }
            }];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void) removeGroupMemberWithID: (NSString*) _iD {
    //JORDAN: server will call this method
    int i = [self hasGroupMemberWithID:_iD];
    if (i >=0 ) {
        [members removeObjectAtIndex:i];
    }
    [self updateOrder];
}

- (void) updateOrder {
    [order.menuItems removeAllObjects];
    for (User* user in members) {
        [order.menuItems addObjectsFromArray:user.order.menuItems];
    }
}

- (BOOL) submitOrder {
    for (User* user in members) {
        if (user.order.status != SUBMITTED) {
            return false;
        }
    }
    //everyone has submitted their order
    //JORDAN: send order to restaurant
    order.status = SUBMITTED;
    return true;
}

- (void) orderCompleted {
    //JORDAN: server will call this method
    order.status = COMPLETE;
    //do other stuff
}

@end
