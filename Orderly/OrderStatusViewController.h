//
//  OrderStatusViewController.h
//  OmniSplit
//
//  Created by Ashley Sehatti on 3/2/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderStatusViewController : UIViewController

//this will show the order status and the server will call orderCompleted to go to payment screen

- (IBAction)goToPayment;

- (void) orderCompleted;
- (void) rotateView;

@end
