//
//  User.m
//  OmniSplit
//
//  Created by Ashley Sehatti on 1/29/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import "User.h"
#import "Group.h"
#import "Order.h"
#import "Menu.h"
#import "MenuItem.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>

@implementation User

@synthesize iD, order, group;

- (instancetype) initWithID: (NSString*) _id {
    if (self = [super init]) {
        iD = _id;
        order = [[Order alloc] init];
        AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        if (delegate.thisUser && self != delegate.thisUser) {
            //JORDAN pull order information from server instead of initializing all with rice in line below
            NSArray* menuItems = [[NSArray alloc] init];
                                  //initWithObjects:@"Jasmine Rice", nil];
            AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            Menu* menu = delegate.theMenu;
            for (int i = 0; i < menuItems.count; i++) {
                MenuItem* item = [menu menuItemForName:menuItems[i]];
                [self addItemToOrder:item];
            }
        }
    }
    return self;
}
- (void) computeNewId {
    self.iD = [NSString stringWithFormat:@"%@%u", @"b", arc4random_uniform(UINT32_MAX)];
}

- (void) joinGroup: (Group*) theGroup {
    group = theGroup;
    [group addGroupMember:self];
}

- (void) leaveGroup {
    [group leaveChannel];
    [order.menuItems removeAllObjects];
    [group removeGroupMemberWithID:iD];
    group = nil;
    
    NSLog(@"Done.");
}

- (void) addItemToOrder:(MenuItem *) foodItem {
    [order.menuItems addObject:foodItem];
    [group updateOrder];
}

- (void) parseOrder: (NSString*) jsonOrder {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSArray * newOrder = (NSArray *) jsonOrder;
    for (int i = 0; i < [newOrder count]; i++) {
        for (int j = 0; j < [newOrder[i][@"count"] intValue]; j++) {
            MenuItem * newItem = [appDelegate.theMenu menuItemForName:newOrder[i][@"name"]];
            [self addItemToOrder:newItem];
            
        }
    }
    
}

- (int) numberOfItemInOrder: (MenuItem*) foodItem {
    int num = 0;
    for (int i = 0; i < order.menuItems.count; i++) {
        if (order.menuItems[i] == foodItem) {
            num++;
        }
    }
    return num;
}

- (void) removeItemFromOrder: (MenuItem*) foodItem {
    for (int i = 0; i < order.menuItems.count; i++) {
        if (order.menuItems[i] == foodItem) {
            [order.menuItems removeObjectAtIndex:i];
            break;
        }
    }
    [group updateOrder];
}

- (void) submitOrder {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    order.status = SUBMITTED;
    
    PFQuery * query = [PFQuery queryWithClassName:@"CurrentOrder"];
    [query whereKey:@"userId" equalTo:[appDelegate.thisUser iD]];
    [query whereKey:@"channel" equalTo:[appDelegate.thisUser.group iD]];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
        if (!error) {
            [object setValue:[NSNumber numberWithBool:YES] forKey:@"submitted"];
            [object saveInBackground];
            
        }
        else {
            NSLog(@"Error submitting order.");
        }
    }];
    [self orderCompleted];
}

- (void)orderCompleted {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PFQuery * query = [PFQuery queryWithClassName:@"CurrentOrder"];
    [query whereKey:@"channel" equalTo:[appDelegate.thisUser.group iD]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            BOOL orderDone = true;
            for (PFObject *object in objects) {
                if (object[@"submitted"] == [NSNumber numberWithBool:NO]) {
                    orderDone = false;
                    break;
                }
            }
            if (orderDone) { //Send push notification to tell everyone to move to payment
                NSDictionary *data = @{
                                       @"content-available": @1,
                                       @"sound": @"",
                                       @"category": @"MOVE_TO_PAYMENT",
                                       };
                
                PFPush *push = [[PFPush alloc] init];
                [push setChannels:@[ [appDelegate.thisUser.group iD] ]];
                [push setData:data];
                
                [push sendPushInBackground];
            }
        }
    }];
    
}

@end
