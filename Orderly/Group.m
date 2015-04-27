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
    PFObject * newObject = [PFObject objectWithClassName:@"CurrentOrder"];
    newObject[@"channel"] = channel;
    newObject[@"userId"] = [appDelegate.thisUser iD];
    newObject[@"currentOrder"] = @"{}";
    
    [newObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (!succeeded) {
            if ([error.description isEqualToString:@"duplicate"]) {
                NSLog(@"Duplicate userId. Attemting with new identifier...");
                [appDelegate.thisUser computeNewId];
                [self joinChannelWithRestaurauntId:restaurantId
                                  andOrderingGroup:orderingGroup];
            }
            else
                NSLog(error.description);
        }
        else {
            NSLog(@"Added user to group order.");
            self.iD = channel;
            //Send push notification to all group members to update their orders
            [self sendSilentPushToGroup: channel];
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
    [members removeAllObjects];
    //get a list of group members from server (an array with just their ids)
    //use addGroupMember method that takes an iD for each user - but don't send this user
    [self updateOrder];
    
}

- (int) hasGroupMemberWithID: (NSString*) _iD {
    for (int i = 0; i < members.count; i++) {
        if (((User*)members[i]).iD == _iD)
            return i;
    }
    return -1; //group doesn't already have member with that id
}

- (void) addGroupMemberWithID: (NSString*) _iD {
    if ([self hasGroupMemberWithID:_iD] == -1) {
        User* user = [[User alloc] initWithID:_iD];
        [self addGroupMember:user];
    }
}

- (void) addGroupMember:(User *)user {
    if ([self hasGroupMemberWithID:user.iD] == -1) {
        [members addObject:user];
        [self updateOrder];
    }
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
