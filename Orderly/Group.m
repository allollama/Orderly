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

@implementation Group

@synthesize order, members;

- (instancetype) init {
    if (self = [super init]) {
        members = [[NSMutableArray alloc] init];
        order = [[Order alloc] init];
    }
    return self;
}

- (void) addGroupMember: (User*) user {
    [members addObject:user];
}

- (void) removeGroupMember: (NSString*) iD {
    for (int i = 0; i < members.count; i++) {
        if (((User*)members[i]).iD == iD) {
            [members removeObjectAtIndex:i];
            break;
        }
    }
    [self updateOrder];
}

- (void) updateOrder {
    [order.menuItems removeAllObjects];
    for (User* user in members) {
        [order.menuItems addObjectsFromArray:user.order.menuItems];
    }
}

- (void) orderCompleted {
    order.status = COMPLETE;
}

- (BOOL) submitOrder {
    for (User* user in members) {
        if (user.order.status != SUBMITTED) {
            return false;
        }
    }
    //everyone has submitted their order
    //send order to restaurant
    order.status = SUBMITTED;
    return true;
}

@end
