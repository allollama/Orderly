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

@interface OrderStatusViewController ()

@end

@implementation OrderStatusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)tempFunction {
    [self orderCompleted];
    UIStoryboard *storyboard = self.storyboard;
    UIViewController *presentVC = [storyboard instantiateViewControllerWithIdentifier:@"SplitPayment"];
    [self.navigationController pushViewController:presentVC animated:YES];
}

- (void)orderCompleted {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    PFQuery * query = [PFQuery queryWithClassName:@"CurrentOrder"];
    [query whereKey:@"channel" equalTo:[appDelegate.thisUser.group iD]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            BOOL orderDone = true;
            for (PFObject *object in objects) {
                if (object[@"submitted"] == [NSNumber numberWithBool:NO]) {
                    orderDone = false;
                    break;
                }
            }
            if (orderDone) { //Send push notification to tell everyone to move to payment
                NSDictionary *data = @{
                                       @"content-available": @1,
                                       @"sound": @"",
                                       @"category": @"MOVE_TO_PAYMENT",
                                       };
                
                PFPush *push = [[PFPush alloc] init];
                [push setChannels:@[ [appDelegate.thisUser.group iD] ]];
                [push setData:data];
                
                [push sendPushInBackground];
            }
        }
    }];

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
