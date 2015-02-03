//
//  Order.h
//  Orderly
//
//  Created by Ashley Sehatti on 1/29/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Order : NSObject

typedef NS_ENUM(NSUInteger, statusCodes)
{
    ORDERING,
    SUBMITTED,
    INPROCESS,
    COMPLETE,
    PAID
};

@property NSMutableArray* menuItems;
@property NSUInteger status;

- (float) totalPrice;

@end
