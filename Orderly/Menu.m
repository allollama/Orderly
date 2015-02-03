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
        dictionary = [NSDictionary dictionaryWithXMLFile:@"/Users/ashsehatti/Desktop/testMenu.xml"];
        id y = [dictionary valueForKey:@"appetizers"];
        NSEnumerator *enumerator = [y objectEnumerator];
        id value;
        
        while ((value = [enumerator nextObject])) {
            /* code that acts on the dictionary’s values */
            NSLog(@"%@", [value objectForKey:@"name"]);
        }
        //NSLog([y objectForKey:@"name"]);
    }
    return self;
}

@end
