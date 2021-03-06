//
//  Menu.h
//  OmniSplit
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
@property NSMutableArray* categoriesDescription;
@property NSString* restaurant;

-(instancetype) init; //temporary method - delete once below works
-(instancetype) initWithPath:(NSString*) filePath; //doesn't work yet

-(MenuItem *) menuItemForName: (NSString*) itemName;

@end
