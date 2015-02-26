//
//  MenuTableViewController.h
//  OmniSplit
//
//  Created by Ashley Sehatti on 2/17/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Menu.h"
#import "Order.h"

@interface MenuTableViewController : UITableViewController

@property Menu* menu;
@property Order* order;

-(void)reviewOrder;

@end
