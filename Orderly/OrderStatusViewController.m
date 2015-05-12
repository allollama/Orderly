//
//  OrderStatusViewController.m
//  OmniSplit
//
//  Created by Ashley Sehatti on 3/2/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import <Parse/Parse.h>
#import "Group.h"
#import "AppDelegate.h"
#import "OrderStatusViewController.h"
#import "OrderStatusView.h"
#import "SplitPaymentTableViewController.h"
#import "Order.h"

@interface OrderStatusViewController ()

@end

@implementation OrderStatusViewController

NSTimer* aTimer;
OrderStatusView* v;
double rotate;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"Elegant_Background-7"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    self.navigationController.navigationBarHidden = YES;
    
    v = [[OrderStatusView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.1, self.view.frame.size.height * 0.3, self.view.frame.size.width * 0.8, self.view.frame.size.width * 0.8)];
    [self.view addSubview:v];
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.1, self.view.frame.size.height * 0.15, self.view.frame.size.width * 0.8, 45)];
    label.text = @"Order Pending";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Avenir" size:30];
    [self.view addSubview:label];
    rotate = 0;
    aTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(rotateView) userInfo:nil repeats:YES];
    // Do any additional setup after loading the view.
}

- (void)rotateView {
    rotate += ((3.14 * 1)/ 180);
    v.transform = CGAffineTransformMakeRotation(rotate);
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    User* user = appDelegate.thisUser;
    if (user.group.order.status == SUBMITTED) {
        [self goToPayment];
    }
}

- (void)goToPayment {
    [aTimer invalidate];
    SplitPaymentTableViewController *vc = [[SplitPaymentTableViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
