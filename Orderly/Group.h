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
@property NSDictionary* peopleDictionary;

- (instancetype) initWithID: (NSString*) _iD;

- (void) joinChannelWithRestaurauntId: (NSString *) restaurantId
                     andOrderingGroup: orderingGroup;
- (void) leaveChannel;
- (void) leaveChannelImmidiately;

- (void) updateGroupFromServer;
- (void) addGroupMemberWithID: (NSString*) _iD
                    withOrder: (NSString*) jsonOrder;
- (void) addGroupMember: (User *) user;
- (void) addItemToOrder: (NSString *) foodName;
- (void) removeItemFromOrder: (NSString *) foodName;
- (void) removeGroupMemberWithID: (NSString*) _iD;
- (NSArray*) listOfUsersWithoutSelf: (User*) aUser;
- (void) updateOrder;
- (void) orderCompleted;
- (BOOL) submitOrder;

@end
