//
//  MenuItem.m
//  Orderly
//
//  Created by Ashley Sehatti on 1/29/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import "MenuItem.h"

@implementation MenuItem

@synthesize price, name, descrp;

- (instancetype) init
{
    if (self = [super init]) {
    }
    return self;
}


- (instancetype) initWithPrice:(float)_price andName:(NSString*)_name andDescription:(NSString*)_descrp
{
    if (self = [super init]) {
        price = _price;
        name = _name;
        descrp = _descrp;
    }
    return self;
}

-(NSString*)description {
    return [NSString stringWithFormat:@"name: %@ description: %@ price: %.02f", name, descrp, price];
}


@end
