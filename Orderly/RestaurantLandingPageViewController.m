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

@implementation RestaurantLandingPageViewController

@synthesize groupTextField, thisUser, theMenu, restaurantId, restaurantName, restaurantInfo, _restaurantInfo, _restaurantName;

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder]; //Hide text field
    if (![groupTextField.text isEqualToString:@""])
        [self showMenu];
    return true;
}

-(IBAction)joinGroup {
    if (![groupTextField.text isEqualToString:@""]) {
        [groupTextField resignFirstResponder];
        Group* group = [[Group alloc]initWithID:groupTextField.text];
        [thisUser joinGroup:group];
        //Subscribe to push notifications channel
        [group joinChannelWithRestaurauntId:restaurantId andOrderingGroup:groupTextField.text];
        [self showMenu];
    }
}

-(IBAction)showMenu {
    UIStoryboard *storyboard = self.storyboard;
    UIViewController *presentVC = [storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    [self.navigationController pushViewController:presentVC animated:YES];
    if ([presentVC isKindOfClass:[MenuTableViewController class]]) {
        MenuTableViewController *menuVC = (MenuTableViewController *) presentVC;
        menuVC.user = thisUser;
        menuVC.menu = theMenu;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.groupTextField.delegate = self;
    
    AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    thisUser = delegate.thisUser;
    
    theMenu = [[Menu alloc]initWithPath:[@"https://omnisplit.com/api/menu/" stringByAppendingString: restaurantId]];
               //54e6794d62fdbd0612cbd5a1"];
    //theMenu = [[Menu alloc]init];
    delegate.theMenu = theMenu;
    restaurantName.text = _restaurantName;
    restaurantInfo.text = _restaurantInfo;
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
