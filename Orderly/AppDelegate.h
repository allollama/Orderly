//
//  AppDelegate.h
//  OmniSplit
//
//  Created by Ashley Sehatti on 12/6/14.
//  Copyright (c) 2014 Santa Clara University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "User.h"
#import "Menu.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property User* thisUser;
@property Menu* theMenu;

@end