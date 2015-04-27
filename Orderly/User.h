//
//  User.h
//  OmniSplit
//
//  Created by Ashley Sehatti on 1/29/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuItem.h"

@class Order;
@class Group;

@interface User : NSObject

@property NSString* iD;
@property Order* order;
@property Group* group;

- (instancetype) initWithID: (NSString*) _id;
- (void) joinGroup: (Group*) theGroup;
- (void) leaveGroup;
- (void) addItemToOrder: (MenuItem*) foodItem;
- (void) removeItemFromOrder: (MenuItem*) foodItem;
- (void) submitOrder;

- (void) computeNewId;

@end
