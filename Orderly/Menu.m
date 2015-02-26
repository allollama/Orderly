//
//  Menu.m
//  OmniSplit
//
//  Created by Ashley Sehatti on 2/1/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import "Menu.h"
#import "XMLDictionary.h"

@implementation Menu

@synthesize menu, numOfSections, categories, categoriesDescription;

- (instancetype) init {
    if (self = [super init]) {
        menu = [[NSMutableDictionary alloc]init];
        categories = [[NSMutableArray alloc]init];
        categoriesDescription = [[NSMutableArray alloc]init];
        //NSDictionary* dictionary = [NSDictionary dictionaryWithXMLFile:@"/Users/ashsehatti/Desktop/testMenu.xml"];
        NSError *jsonError;
        NSString *jsonString = [[NSString alloc] initWithContentsOfFile:@"/Users/ashsehatti/Desktop/WhiteElephant.txt" encoding:NSUTF8StringEncoding error:NULL];
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&jsonError];
        NSArray* cats = [dictionary objectForKey:@"group"];
        numOfSections = cats.count;
        for (int i = 0; i < cats.count; i++) {
            NSMutableDictionary* categoryDictionary = [[NSMutableDictionary alloc]init];
            NSArray* foodItems = [cats[i] objectForKey:@"item"];
            for (int j = 0; j < foodItems.count; j++) {
                NSDictionary* foodItem = foodItems[j];
                MenuItem* menuItem = [[MenuItem alloc]initWithPrice:[[foodItem objectForKey:@"price"] floatValue] andName:[foodItem objectForKey:@"name"] andDescription:[foodItem objectForKey:@"description"]];
                [categoryDictionary setObject:menuItem forKey:[foodItem objectForKey:@"name"]];
            }
            [menu setObject:categoryDictionary forKey:[cats[i] objectForKey:@"name"]];
            [categories addObject:[cats[i] objectForKey:@"name"]];
            [categoriesDescription addObject:[cats[i] objectForKey:@"description"]];
        }
    }
    return self;
}

@end
