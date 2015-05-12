//
//  Order.h
//  OmniSplit
//
//  Created by Ashley Sehatti on 1/29/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuItem.h"

@interface Order : NSObject

typedef NS_ENUM(NSUInteger, statusCodes)
{
    ORDERING,
    CHANGED,
    SUBMITTED,
    COMPLETE,
    PAID
};

@property NSMutableArray* menuItems;
@property NSUInteger status;

- (int) containsItem: (MenuItem*) foodItem;
- (float) totalPrice;
- (NSArray*) listOfUniqueItems;

@end
