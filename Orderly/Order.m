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

- (int) containsItem:(MenuItem *)foodItem {
    for (int i = 0; i < menuItems.count; i++) {
        if (((MenuItem*)menuItems[i]).name == foodItem.name) {
            return i;
        }
    }
    return -1;
}

- (float) totalPrice {
    
    float price = 0;
    for (MenuItem *item in menuItems) {
        price += item.price;
    }
    return price;
}

- (NSArray*) listOfUniqueItems {
    NSMutableArray* temp = [[NSMutableArray alloc]init];
    for (MenuItem* item in menuItems) {
        if (![temp containsObject:item]) {
            [temp addObject:item];
        }
    }
    return temp;
}

-(NSString*)description {
    return [NSString stringWithFormat:@"%@ price: %.02f", menuItems, [self totalPrice]];
}


@end
