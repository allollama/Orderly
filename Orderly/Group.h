//
//  Group.h
//  OmniSplit
//
//  Created by Ashley Sehatti on 1/29/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//
//  Check server database for table code - if not found, create a Group and add the user.
//  If found, just add user.
//

#import <Foundation/Foundation.h>

@class Order;
@class User;

@interface Group : NSObject

@property Order* order;
@property NSMutableArray* members;

- (void) addGroupMember: (User*) user;
- (void) removeGroupMember: (NSString*) iD;
- (void) updateOrder;
- (void) orderCompleted;

@end
