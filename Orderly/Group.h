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

@property NSString* iD;
@property Order* order;
@property NSMutableArray* members;

- (instancetype) initWithID: (NSString*) _iD;

- (void) updateGroupFromServer;
- (void) addGroupMemberWithID: (NSString*) _iD;
- (void) addGroupMember: (User *) user;
- (void) removeGroupMemberWithID: (NSString*) _iD;
- (void) updateOrder;
- (void) orderCompleted;

@end
