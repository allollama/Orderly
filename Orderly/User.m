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

- (void) joinGroup: (Group*) theGroup {
    group = theGroup;
    [group addGroupMember:self];
}

- (void) leaveGroup {
    NSLog(@"This method is a stub");
    //ping group to remove this user
}

- (void) addItemToOrder:(MenuItem *) foodItem {
    [order.menuItems addObject:foodItem];
    [group updateOrder];
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
    order.status = SUBMITTED; //JORDAN: send a message to server
    [group submitOrder];
}

@end
