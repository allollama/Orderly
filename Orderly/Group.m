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

@synthesize iD, order, members; //JORDAN take a look at this whole file

- (instancetype) initWithID:(NSString *)_iD {
    if (self = [super init]) {
        iD = _iD;
        members = [[NSMutableArray alloc] init];
        order = [[Order alloc] init];
        //check if group has already been created with that iD
        if (false /*group already made*/) {
            [self updateGroupFromServer];
        }
        else {
            //send message to server to create group
        }
    }
    return self;
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
