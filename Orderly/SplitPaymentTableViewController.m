//
//  SplitPaymentTableViewController.m
//  OmniSplit
//
//  Created by Ashley Sehatti on 4/23/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import "SplitPaymentTableViewController.h"
#import "AppDelegate.h"
#import "Order.h"
#import "Group.h"
#import "MenuItem.h"

@interface SplitPaymentTableViewController ()

@end

@implementation SplitPaymentTableViewController

@synthesize user, divideByAmounts;

UITableView* splitAmongUsersTableView;

NSMutableArray* usersToSplitWith;
NSMutableArray* groupMembersNotIncludingUser;

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
    
    AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    user = delegate.thisUser;
    
    divideByAmounts = [[NSMutableArray alloc] init];
    for (int i = 0; i < user.order.menuItems.count; i++) {
        divideByAmounts[i] = [NSNumber numberWithFloat:1];
    }
    
    UIScreen *mainScreen = [UIScreen mainScreen];
    UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,mainScreen.bounds.size.height - 40,mainScreen.bounds.size.width,40)];
    myLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, mainScreen.bounds.size.width, 30)];
    myLabel.text = [NSString stringWithFormat:@"Total price: $%.02f", [self totalPrice]];
    myLabel.textAlignment = NSTextAlignmentCenter;
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    myButton.frame = CGRectMake(mainScreen.bounds.size.width/3, 25, mainScreen.bounds.size.width/3, 50);
    [myButton setTitle:@"PAY" forState:UIControlStateNormal];
    [myButton addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:myButton];
    [bottomView addSubview:myLabel];
    self.tableView.tableFooterView = bottomView;
    
    usersToSplitWith = [[NSMutableArray alloc]init];
    
    /* use for testing
    [user.group addGroupMember:[[User alloc]initWithID:@"12345"]];
    [user.group addGroupMember:[[User alloc]initWithID:@"2345"]];*/
    
    groupMembersNotIncludingUser = [[NSMutableArray alloc]init];
    for (User* user_ in user.group.members) {
        if (user_ != user) {
            [groupMembersNotIncludingUser addObject:user_];
        }
    }
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)pay {
    
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
        return groupMembersNotIncludingUser.count;
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
    [splitAlert show];
    
}

- (void)split:(int)index byAmount:(float)theAmount {
    divideByAmounts[index] = [NSNumber numberWithFloat:theAmount];
    [(UITableView*) self.view reloadData];
    myLabel.text = [NSString stringWithFormat:@"Total price: $%.02f", [self totalPrice]];
}

- (void)addPartial:(MenuItem*)foodItem byAmount:(float)theAmount {
    //JORDAN
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
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
        MenuItem* foodItem = user.order.menuItems[indexPath.row];
    
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, cell.frame.size.width * 0.75 + 50, cell.frame.size.height)];
        label.text = [NSString stringWithFormat:@"%@ $%.02f", foodItem.name, foodItem.price / [(NSNumber*) divideByAmounts[indexPath.row] floatValue] ];
        label.adjustsFontSizeToFitWidth = YES;
        [cell addSubview:label];
    
        UIButton *splitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        splitButton.frame = CGRectMake(cell.frame.size.width * 0.75 + 50, 5, cell.frame.size.width*0.25, cell.frame.size.height - 10);
        [splitButton setTitle:@"Split" forState:UIControlStateNormal];
        [splitButton addTarget:self action:@selector(split:) forControlEvents:UIControlEventTouchUpInside];
        splitButton.tag = indexPath.row;
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
        
        User* user_ = groupMembersNotIncludingUser[indexPath.row];
        cell.textLabel.text = user_.iD;
        cell.textLabel.adjustsFontSizeToFitWidth = YES;
        return cell;

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == splitAmongUsersTableView) {
        User* user_ = groupMembersNotIncludingUser[indexPath.row];
        
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
