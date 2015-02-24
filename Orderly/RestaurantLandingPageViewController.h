//
//  RestaurantLandingPageViewController.h
//  Orderly
//
//  Created by Ashley Sehatti on 2/23/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface RestaurantLandingPageViewController : UIViewController

-(IBAction)joinGroup;
-(IBAction)showMenu;

@property (nonatomic, weak) IBOutlet UITextField* groupTextField;
@property User* thisUser;

@end
