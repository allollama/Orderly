//
//  Menu.m
//  Orderly
//
//  Created by Ashley Sehatti on 2/1/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import "Menu.h"
#import "XMLDictionary.h"

@implementation Menu

@synthesize menu, numOfSections, categories;

- (instancetype) init {
    if (self = [super init]) {
        menu = [[NSMutableDictionary alloc]init];
        categories = [[NSMutableArray alloc]init];
        NSDictionary* dictionary = [NSDictionary dictionaryWithXMLFile:@"/Users/ashsehatti/Desktop/testMenu.xml"];
        NSArray* keys = [dictionary allKeys];
        numOfSections = keys.count - 1;
        for (int i = 0; i < keys.count; i++) {
            if (![keys[i] isEqualToString:@"__name"]) {
                NSMutableDictionary* categoryDictionary = [[NSMutableDictionary alloc]init];
                NSDictionary* category = [dictionary objectForKey:keys[i]];
                NSArray* foodKeys = [category allKeys];
                for (int j = 0; j < foodKeys.count; j++) {
                    NSDictionary* foodItem = [category objectForKey:foodKeys[j]];
                    MenuItem* menuItem = [[MenuItem alloc]initWithPrice:[[foodItem objectForKey:@"price"] floatValue] andName:[foodItem objectForKey:@"name"] andDescription:[foodItem objectForKey:@"description"]];
                    NSLog(@"%@ %@", menuItem.descrp, [foodItem objectForKey:@"description"]);
                    [categoryDictionary setObject:menuItem forKey:foodKeys[j]];
                }
                [menu setObject:categoryDictionary forKey:keys[i]];
                [categories addObject:keys[i]];
            }
        }
    }
    NSLog(@"%@", menu);
    return self;
}

@end
