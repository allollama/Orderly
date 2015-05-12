//
//  RestaurantLandingPageViewController.h
//  OmniSplit
//
//  Created by Ashley Sehatti on 2/23/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Menu.h"

@interface RestaurantLandingPageViewController : UIViewController <UITextFieldDelegate>

-(void)joinGroup;
-(void)showMenu;

@property UILabel* restaurantName;
@property UILabel* restaurantInfo;
@property UITextField* groupTextField;

@property User* thisUser;
@property NSString* restaurantId;
@property NSString* _restaurantName;
@property NSString* _restaurantInfo;
@property Menu* theMenu;

@end
