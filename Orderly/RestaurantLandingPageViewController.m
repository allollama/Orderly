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
    [self joinGroup];
    return NO;
}

-(void)joinGroup {
    [groupTextField resignFirstResponder];
    if (![groupTextField.text isEqualToString:@""]) {
        Group* group = [[Group alloc]initWithID:groupTextField.text];
        [thisUser joinGroup:group];
        //Subscribe to push notifications channel
        [group joinChannelWithRestaurauntId:restaurantId andOrderingGroup:groupTextField.text];
        [self showMenu];
    }
}

-(void)showMenu {
    UIStoryboard *storyboard = self.storyboard;
    UIViewController *presentVC = [storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    self.navigationItem.title = @"";
    [self.navigationController pushViewController:presentVC animated:YES];
    if ([presentVC isKindOfClass:[MenuTableViewController class]]) {
        MenuTableViewController *menuVC = (MenuTableViewController *) presentVC;
        menuVC.user = thisUser;
        menuVC.menu = theMenu;
        menuVC.restaurantName = _restaurantName;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"Elegant_Background-7"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    self.navigationItem.title = _restaurantName;
    
    self.groupTextField.delegate = self;
    
    AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    thisUser = delegate.thisUser;
    
    theMenu = [[Menu alloc]initWithPath:[@"https://omnisplit.com/api/menu/" stringByAppendingString: restaurantId]];
    delegate.theMenu = theMenu;
    
    UILabel* restaurantNameAndInfo = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width* 0.1, self.view.frame.size.height * 0.15, self.view.frame.size.width * 0.8, self.view.frame.size.height * 0.20)];
    restaurantNameAndInfo.text = [NSString stringWithFormat:@"%@ \n\n %@", _restaurantName, _restaurantInfo];
    theMenu.restaurant = _restaurantName;
    self.navigationItem.title = _restaurantName;
    restaurantNameAndInfo.numberOfLines = 5;
    restaurantNameAndInfo.textAlignment = NSTextAlignmentCenter;
    restaurantNameAndInfo.font = [UIFont fontWithName:@"Avenir" size:20];
    restaurantNameAndInfo.layer.borderColor = [UIColor colorWithRed:103.0/255.0 green:4.0/255.0 blue:202.0/255.0 alpha:1].CGColor;
    restaurantNameAndInfo.layer.borderWidth = 2.0f;
    [self.view addSubview:restaurantNameAndInfo];
    
    groupTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.34, self.view.frame.size.height * 0.5, self.view.frame.size.width * 0.33, 30)];
    groupTextField.borderStyle = UITextBorderStyleRoundedRect;
    groupTextField.font = [UIFont fontWithName:@"Avenir" size:20];
    groupTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    groupTextField.keyboardType = UIKeyboardTypeDefault;
    groupTextField.returnKeyType = UIReturnKeyDone;
    groupTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    groupTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    groupTextField.delegate = self;
    [self.view addSubview:groupTextField];
    
    UIButton* joinGroupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [joinGroupButton setTitle:@"Join Ordering Group" forState:UIControlStateNormal];
    [joinGroupButton addTarget:self action:@selector(joinGroup) forControlEvents:UIControlEventTouchUpInside];
    [joinGroupButton setTitleColor:[UIColor colorWithRed:103.0/255.0 green:4.0/255.0 blue:202.0/255.0 alpha:1] forState:UIControlStateNormal];
    joinGroupButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:20];
    joinGroupButton.frame = CGRectMake(self.view.frame.size.width * 0.1, self.view.frame.size.height * 0.6, self.view.frame.size.width * 0.8, 30);
    [self.view addSubview:joinGroupButton];
    
    UIButton* viewMenuButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [viewMenuButton setTitle:@"View Menu" forState:UIControlStateNormal];
    [viewMenuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    [viewMenuButton setTitleColor:[UIColor colorWithRed:103.0/255.0 green:4.0/255.0 blue:202.0/255.0 alpha:1] forState:UIControlStateNormal];
    viewMenuButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:20];
    viewMenuButton.frame = CGRectMake(self.view.frame.size.width * 0.1, self.view.frame.size.height * 0.70, self.view.frame.size.width * 0.8, 30);
    [self.view addSubview:viewMenuButton];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationItem.title = _restaurantName;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
