//
//  Menu.h
//  Orderly
//
//  Created by Ashley Sehatti on 2/1/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MenuItem.h"

@interface Menu : NSObject

@property NSMutableDictionary* menu;
@property NSUInteger numOfSections;
@property NSMutableArray* categories;

@end
