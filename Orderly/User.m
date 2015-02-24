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

@implementation User

@synthesize iD, order, group;

- (instancetype) initWithID: (NSString*) _id {
    if (self = [super init]) {
        iD = _id;
    }
    return self;
}

- (void) joinGroup: (Group*) theGroup {
    group = theGroup;
    [group addGroupMember:self];
    //launch menu
}

@end
