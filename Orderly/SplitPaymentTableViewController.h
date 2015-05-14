//
//  SplitPaymentTableViewController.h
//  OmniSplit
//
//  Created by Ashley Sehatti on 4/23/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface SplitPaymentTableViewController : UITableViewController

@property User* user;

-(void)pay;
- (void)split:(id)sender;
- (void)split:(int)index byAmount:(float)theAmount;
- (void)addPartial:(MenuItem*)foodItem byAmount:(float)theAmount;

@end
