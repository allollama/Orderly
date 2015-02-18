//
//  MenuItem.h
//  Orderly
//
//  Created by Ashley Sehatti on 1/29/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuItem : NSObject

@property float price;
@property NSString* name;
@property NSString* descrp;

- (instancetype) initWithPrice:(float)_price andName:(NSString*)_name andDescription:(NSString*)_descrp;

@end
