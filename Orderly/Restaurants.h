//
//  Restaurants.h
//  OmniSplit
//
//  Created by Jordan Buschman on 3/5/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Restaurants : NSObject

@property BOOL loaded;
@property (strong) NSMutableArray *restaurantList;

-(instancetype) init;
-(void) getRestaurants;

+(Restaurants *) globalRestaurants;

@end