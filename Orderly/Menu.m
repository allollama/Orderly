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

@synthesize dictionary;

- (instancetype) init {
    if (self = [super init]) {
        NSLog(@"initializing menu");
        dictionary = [NSDictionary dictionaryWithXMLFile:@"/Users/ashsehatti/Desktop/testMenu.xml"];
        NSArray* keys = [dictionary allKeys];
        for (int i = 0; i < keys.count; i++) {
            if (![keys[i] isEqualToString:@"__name"]) {
                NSLog(@"%@", keys[i]);
                NSEnumerator* foodEnum = [[dictionary objectForKey:keys[i]] objectEnumerator];
                for (id foodItem in foodEnum) {
                    NSLog(@"%@", foodItem);
                }
            }
        }
    }
    return self;
}

@end
