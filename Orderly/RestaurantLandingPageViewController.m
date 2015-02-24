//
//  RestaurantLandingPageViewController.m
//  OmniSplit
//
//  Created by Ashley Sehatti on 2/23/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import "RestaurantLandingPageViewController.h"
#import "AppDelegate.h"
#import "Group.h"
#import "MenuTableViewController.h"

@interface RestaurantLandingPageViewController ()

@end

@implementation RestaurantLandingPageViewController

@synthesize groupTextField, thisUser;

-(IBAction)joinGroup {
    NSLog(@"%@", groupTextField.text);
    User* user1 = [[User alloc]initWithID:@"2345"];
    User* user2 = [[User alloc]initWithID:@"3456"];
    Group* group = [[Group alloc]init];
    [group addGroupMember:user1];
    [group addGroupMember:user2];
    [thisUser joinGroup:group];
    [self showMenu];
}

-(IBAction)showMenu {
    UIStoryboard *storyboard = self.storyboard;
    UIViewController *presentVC = [storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    [self.navigationController pushViewController:presentVC animated:YES];
    if (thisUser.group && [presentVC isKindOfClass:[MenuTableViewController class]]) {
        MenuTableViewController *menuVC = (MenuTableViewController *) presentVC;
        menuVC.order = thisUser.order;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    thisUser = delegate.thisUser;
    // Do any additional setup after loading the view.
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
