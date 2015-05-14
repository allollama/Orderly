//
//  SplitPaymentTableViewController.m
//  OmniSplit
//
//  Created by Ashley Sehatti on 4/23/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import <Parse/Parse.h>
#import "SplitPaymentTableViewController.h"
#import "AppDelegate.h"
#import "Order.h"
#import "Group.h"
#import "MenuItem.h"
#import "PaidViewController.h"

@implementation SplitPaymentTableViewController

@synthesize user, divideByAmounts;

UITableView* splitAmongUsersTableView;

NSMutableArray* usersToSplitWith;

UILabel *myLabel;

- (float) totalPrice {
    float price = 0;
    for (int i = 0; i<user.order.menuItems.count; i++) {
        price += [(MenuItem*) user.order.menuItems[i] price ] / [(NSNumber*) divideByAmounts[i] floatValue];
    }
    return price;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIView appearance] setTintColor:[UIColor colorWithRed:103.0/255.0 green:4.0/255.0 blue:202.0/255.0 alpha:1]];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"Elegant_Background-7"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    self.navigationItem.title = @"Your Order:";
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.hidesBackButton = YES;
    
    AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    user = delegate.thisUser;
    
    divideByAmounts = [[NSMutableArray alloc] init];
    for (int i = 0; i < user.order.menuItems.count; i++) {
        divideByAmounts[i] = [NSNumber numberWithFloat:1];
    }
    
    UIScreen *mainScreen = [UIScreen mainScreen];
    UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,mainScreen.bounds.size.height - 100,mainScreen.bounds.size.width,75)];
    myLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, mainScreen.bounds.size.width, 30)];
    myLabel.text = [NSString stringWithFormat:@"Total price: $%.02f", [self totalPrice]];
    myLabel.textAlignment = NSTextAlignmentCenter;
    myLabel.font = [UIFont fontWithName:@"Avenir" size:20];
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    myButton.frame = CGRectMake(mainScreen.bounds.size.width/3, 30, mainScreen.bounds.size.width/3, 60);
    [myButton setTitle:@"PAY" forState:UIControlStateNormal];
    [myButton addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    [myButton setTitleColor:[UIColor colorWithRed:103.0/255.0 green:4.0/255.0 blue:202.0/255.0 alpha:1] forState:UIControlStateNormal];
    myButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:30];
    [bottomView addSubview:myButton];
    [bottomView addSubview:myLabel];
    self.tableView.tableFooterView = bottomView;
    
    usersToSplitWith = [[NSMutableArray alloc]init];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)pay {
    //send notification to server that user has paid
    [user leaveGroup];
    PaidViewController* vc = [[PaidViewController alloc] init];
    vc.total = [self totalPrice];
    self.navigationItem.title = @"";
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (tableView == splitAmongUsersTableView) {
        return [user.group listOfUsersWithoutSelf:user].count;
    }
    else {
        return user.order.menuItems.count;
    }
}

- (void)split:(id)sender {
    UIButton* button = (UIButton*) sender;
    
    UIAlertView* splitAlert = [[UIAlertView alloc] initWithTitle:@"Select users to split with" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Split Equally", @"Split With Selected Users", nil];
    
    splitAmongUsersTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 25, 50*user.group.members.count)];
    splitAmongUsersTableView.delegate = self;
    splitAmongUsersTableView.dataSource = self;
    [splitAlert setValue:splitAmongUsersTableView forKey:@"accessoryView"];
    splitAlert.tag = button.tag;
    [usersToSplitWith removeAllObjects];
    [splitAlert show];
    
}

- (void)split:(int)index byAmount:(float)theAmount {
    AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    MenuItem * theMenuItem = user.order.menuItems[index];
    NSString * menuItemName = [theMenuItem name];
    NSMutableArray * allUsers = [[NSMutableArray alloc] init];
    [allUsers addObject:[delegate.thisUser iD]];
    for (int i = 0; i < [usersToSplitWith count]; i++) {
        [allUsers addObject:[usersToSplitWith[i] iD]];
    }
    NSLog(@"USERS: %@", allUsers);
    NSLog(@"NAME: %@", menuItemName);
    divideByAmounts[index] = [NSNumber numberWithFloat:theAmount];
    [(UITableView*) self.view reloadData];
    myLabel.text = [NSString stringWithFormat:@"Total price: $%.02f", [self totalPrice]];
    
    NSDictionary *data = @{
                           @"aps": @{
                                   @"content-available": @1,
                                   @"sound": @"",
                                   @"category": @"SPLIT_PAYMENT",
                                   },
                           @"item_name": menuItemName,
                           @"group_members": allUsers
                           };
    
    PFPush *push = [[PFPush alloc] init];
    [push setChannels:@[ [delegate.thisUser.group iD] ]];
    [push setData:data];
    
    [push sendPushInBackground]; //Inform others of group change
}

- (void)addPartial:(MenuItem*)foodItem byAmount:(float)theAmount {
    [user addItemToOrder:foodItem];
    divideByAmounts[user.order.menuItems.count - 1] = [NSNumber numberWithFloat:(theAmount)];
    [(UITableView*) self.view reloadData];
    myLabel.text = [NSString stringWithFormat:@"Total price: $%.02f", [self totalPrice]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView != splitAmongUsersTableView) {
        NSString* cellID = @"food";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
        if (cell == nil) {
            cell = [[UITableViewCell alloc] init];
            cell.backgroundColor = [UIColor clearColor];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        MenuItem* foodItem = user.order.menuItems[indexPath.row];
    
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, cell.frame.size.width * 0.75 + 50, cell.frame.size.height)];
        label.text = [NSString stringWithFormat:@"%@ $%.02f", foodItem.name, foodItem.price / [(NSNumber*) divideByAmounts[indexPath.row] floatValue] ];
        label.font = [UIFont fontWithName:@"Avenir" size:20];
        label.adjustsFontSizeToFitWidth = YES;
        [cell addSubview:label];
    
        UIButton *splitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        splitButton.frame = CGRectMake(self.view.frame.size.width - 50, 5, 50, cell.frame.size.height - 10);
        [splitButton setTitle:@"Split" forState:UIControlStateNormal];
        [splitButton addTarget:self action:@selector(split:) forControlEvents:UIControlEventTouchUpInside];
        splitButton.tag = indexPath.row;
        [splitButton setTitleColor:[UIColor colorWithRed:103.0/255.0 green:4.0/255.0 blue:202.0/255.0 alpha:1] forState:UIControlStateNormal];
        splitButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:20];
        [cell addSubview:splitButton];
    
        return cell;
    }
    else {
        NSString* cellID = @"user";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] init];
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        User* user_ = [user.group listOfUsersWithoutSelf:user][indexPath.row];
        cell.textLabel.text = user_.iD;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        return cell;

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == splitAmongUsersTableView) {
        User* user_ = [user.group listOfUsersWithoutSelf:user][indexPath.row];
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        
        if (![usersToSplitWith containsObject:user_]) {
            [usersToSplitWith addObject:user_];
            [cell setBackgroundColor:[UIColor grayColor]];
        }
        else {
            [usersToSplitWith removeObjectAtIndex:[usersToSplitWith indexOfObject:user_]];
            [cell setBackgroundColor:[UIColor whiteColor]];
        }
    }
    
}

- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    /* Handle alert view selection */
        if (buttonIndex == 1) {
            [usersToSplitWith addObjectsFromArray:[user.group listOfUsersWithoutSelf:user]];
            [self split:(int)alertView.tag byAmount:user.group.members.count];
            //send message to all users - have them use addPartial method
        }
        else if(buttonIndex == 2) {
            [self split:(int)alertView.tag byAmount:usersToSplitWith.count + 1];
            //send message to users in usersToSplitWith
        }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
