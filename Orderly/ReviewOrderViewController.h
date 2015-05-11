//
//  ReviewOrderViewController.h
//  OmniSplit
//
//  Created by Ashley Sehatti on 3/1/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"

@interface ReviewOrderViewController : UIViewController

@property User* user;

-(void)submitOrder;
-(void)populateView;

@end
