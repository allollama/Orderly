//
//  Restaurants.m
//  OmniSplit
//
//  Created by Jordan Buschman on 3/5/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Restaurants.h"

Restaurants * restaurants;

@implementation Restaurants

@synthesize loaded, restaurantList;

-(instancetype) init {
    self = [super init];
    self.loaded = false;
    self.restaurantList = [[NSMutableArray alloc] init];
    return self;
}

-(void) getRestaurants {
    NSString * url = @"https://omnisplit.com/api/restaurants";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setHTTPMethod:@"GET"];
    [request setURL:[NSURL URLWithString:url]];
    
    NSError *error = nil;
    NSHTTPURLResponse *responseCode = nil;
    
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:&responseCode error:&error];
    
    if([responseCode statusCode] != 200){
        NSLog(@"Error getting %@, HTTP status code %li", url, (long)[responseCode statusCode]);
        return;
    }
    if (error)
        NSLog(@"%@", error);
    
    self.loaded = true;
    
    NSError *jsonParsingError = nil;
    
    NSMutableArray *arrayResponse = [NSJSONSerialization JSONObjectWithData:response
                                                                    options:0
                                                                      error:&jsonParsingError];
    
    if (jsonParsingError)
        NSLog(@"%@", jsonParsingError);
    
    restaurantList = arrayResponse;
}

+(Restaurants *) globalRestaurants {
    if (!restaurants)
        restaurants = [[Restaurants alloc] init];
    
    return restaurants;
}

@end