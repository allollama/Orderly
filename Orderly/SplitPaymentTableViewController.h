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
@property NSMutableArray* amounts;

-(void)pay;
- (void)split:(id)sender;

@end
