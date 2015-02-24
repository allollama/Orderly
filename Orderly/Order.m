//
//  Order.m
//  OmniSplit
//
//  Created by Ashley Sehatti on 1/29/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import "Order.h"
#import "MenuItem.h"

@implementation Order

@synthesize menuItems, status;

- (instancetype) init
{
    if (self = [super init]) {
        menuItems = [[NSMutableArray alloc] init];
        self.status = ORDERING;
    }
    return self;
}

- (float) totalPrice
{
    
    float price = 0;
    for (MenuItem *item in menuItems) {
        price += item.price;
    }
    return price;
}

@end
