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

@synthesize user, amounts;

UILabel *myLabel;

- (float) totalPrice {
    float price = 0;
    for (int i = 0; i<user.order.menuItems.count; i++) {
        price += [(MenuItem*) user.order.menuItems[i] price ] / [(NSNumber*) amounts[i] floatValue];
    }
    return price;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    user = delegate.thisUser;
    
    amounts = [[NSMutableArray alloc] init];
    for (int i = 0; i < user.order.menuItems.count; i++) {
        amounts[i] = [NSNumber numberWithFloat:1];
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
    return user.order.menuItems.count;
}

- (void)split:(id)sender {
    UIButton* button = (UIButton*) sender;
    amounts[button.tag] = [NSNumber numberWithFloat:(user.group.members.count)];
    //send notification to other users - notification will call method below
    [(UITableView*) self.view reloadData];
    myLabel.text = [NSString stringWithFormat:@"Total price: $%.02f", [self totalPrice]];
}

- (void)addPartial:(MenuItem*)foodItem byAmount:(float)theAmount {
    [user addItemToOrder:foodItem];
    amounts[user.order.menuItems.count] = [NSNumber numberWithFloat:(theAmount)];
    [(UITableView*) self.view reloadData];
    myLabel.text = [NSString stringWithFormat:@"Total price: $%.02f", [self totalPrice]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellID = @"food";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    
    MenuItem* foodItem = user.order.menuItems[indexPath.row];
    
    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, cell.frame.size.width * 0.75 + 50, cell.frame.size.height)];
    label.text = [NSString stringWithFormat:@"%@ $%.02f", foodItem.name, foodItem.price / [(NSNumber*) amounts[indexPath.row] floatValue] ];
    label.adjustsFontSizeToFitWidth = YES;
    [cell addSubview:label];
    
    UIButton *splitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    splitButton.frame = CGRectMake(cell.frame.size.width * 0.75 + 50, 5, cell.frame.size.width*0.25, cell.frame.size.height - 10);
    //splitButton.backgroundColor = [UIColor redColor];
    [splitButton setTitle:@"Split" forState:UIControlStateNormal];
    [splitButton addTarget:self action:@selector(split:) forControlEvents:UIControlEventTouchUpInside];
    splitButton.tag = indexPath.row;
    [cell addSubview:splitButton];
    
    return cell;
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
