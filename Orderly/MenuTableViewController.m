//
//  MenuTableViewController.m
//  OmniSplit
//
//  Created by Ashley Sehatti on 2/17/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import "MenuTableViewController.h"
#import "AppDelegate.h"
#import "Group.h"
#import "User.h"
#import "ReviewOrderViewController.h"
#import "myButton.h"

@implementation MenuTableViewController

@synthesize menu, user;

- (void)reviewOrder {
    UIStoryboard *storyboard = self.storyboard;
    UIViewController *presentVC = [storyboard instantiateViewControllerWithIdentifier:@"ReviewOrder"];
    [self.navigationController pushViewController:presentVC animated:YES];
    if ([presentVC isKindOfClass:[ReviewOrderViewController class]]) {
        ReviewOrderViewController *reviewOrderVC = (ReviewOrderViewController *) presentVC;
        reviewOrderVC.user = user;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (user.group != nil) {
        //add continue button to bottom of table view
        UIScreen *mainScreen = [UIScreen mainScreen];
        UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,mainScreen.bounds.size.height - 10,mainScreen.bounds.size.width,mainScreen.bounds.size.height)];
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        myButton.frame = CGRectMake(mainScreen.bounds.size.width/3, 0, mainScreen.bounds.size.width/3, 50);
        [myButton setTitle:@"CONTINUE" forState:UIControlStateNormal];
        [myButton addTarget:self action:@selector(reviewOrder) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:myButton];
        self.tableView.tableFooterView = bottomView;
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"%@  %@",[menu.categories objectAtIndex:section], [menu.categoriesDescription objectAtIndex:section]];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return menu.numOfSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[menu.menu objectForKey:[menu.categories objectAtIndex:section]] allKeys] count];
}

- (MenuItem*)menuItemForIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* dictionary = [menu.menu objectForKey:[menu.categories objectAtIndex:indexPath.section]];
    return [dictionary objectForKey:[[dictionary allKeys]objectAtIndex:indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellID = @"menuItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    MenuItem* foodItem = [self menuItemForIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"$%.02f %@", foodItem.price, foodItem.name];
    cell.detailTextLabel.text = foodItem.descrp;
    cell.detailTextLabel.numberOfLines = 2;
    cell.detailTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)removeItem:(id)sender {
    myButton* button = (myButton*) sender;
    [user removeItemFromOrder:[self menuItemForIndexPath:button.indexPath]];
    [user.group removeItemFromOrder:[[self menuItemForIndexPath:button.indexPath] name]]; //Update the server and send push notification
    int num = [user numberOfItemInOrder:[self menuItemForIndexPath:button.indexPath]];
    if (num > 0) {
        button.label.text = [NSString stringWithFormat:@"%d", num];
    }
    else {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:button.indexPath];
        cell.accessoryView = nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuItem* foodItem = [self menuItemForIndexPath:indexPath];
    if (user.group != nil) {
        [user addItemToOrder:foodItem];
        [user.group addItemToOrder:[foodItem name]]; //Update the server and send push notification
        NSLog(@"%@", user.group.order);
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        myButton* numberMinusButton = [myButton buttonWithType:UIButtonTypeRoundedRect];
        UIImage* image = [UIImage imageNamed:@"200px-Ambox_emblem_minus.svg.png"];
        [numberMinusButton setBackgroundImage:image forState:UIControlStateNormal];
        [numberMinusButton addTarget:self action:@selector(removeItem:) forControlEvents:UIControlEventTouchUpInside];
        numberMinusButton.indexPath = indexPath;
        numberMinusButton.frame = CGRectMake(0, 0, 40, cell.frame.size.height);

        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 40, cell.frame.size.height)];
        label.text = [NSString stringWithFormat:@"%d", [user numberOfItemInOrder:foodItem]];
        UIView* subview = [[UIView alloc]initWithFrame:CGRectMake(cell.frame.size.width * 0.80, 0, cell.frame.size.width * 0.2, cell.frame.size.height)];
        label.layer.borderColor = [UIColor blackColor].CGColor;
        label.layer.borderWidth = 2.0;
        label.textAlignment = NSTextAlignmentCenter;
        [subview addSubview:label];
        [subview addSubview:numberMinusButton];
        numberMinusButton.label = label;
        cell.accessoryView = subview;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSArray *viewControllers = self.navigationController.viewControllers;
    if ([viewControllers indexOfObject:self] == NSNotFound) //View is being popped off the stack
        [user leaveGroup];
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
