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

@synthesize groupTextField, thisUser, theMenu;

-(IBAction)joinGroup {
    NSLog(@"%@", groupTextField.text);
    Group* group = [[Group alloc]initWithID:groupTextField.text];
    [group addGroupMemberWithID:@"2345"];
    [group addGroupMemberWithID:@"3456"];
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
        menuVC.menu = theMenu;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    thisUser = delegate.thisUser;
    
    //JORDAN: once the following method works, this will replace the line underneath it
    //menu = [[Menu alloc]initWithPath:@"https://omnisplit.com/api/menu/54e6794d62fdbd0612cbd5a1"];
    theMenu = [[Menu alloc]init];
    delegate.theMenu = theMenu;
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
