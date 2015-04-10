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

@interface RestaurantLandingPageViewController : UIViewController

-(IBAction)joinGroup;
-(IBAction)showMenu;

@property (weak, nonatomic) IBOutlet UILabel* restaurantName;
@property (weak, nonatomic) IBOutlet UILabel* restaurantInfo;

@property (nonatomic, weak) IBOutlet UITextField* groupTextField;
@property User* thisUser;
@property NSString* restaurantId;
@property NSString* _restaurantName;
@property NSString* _restaurantInfo;
@property Menu* theMenu;

@end
