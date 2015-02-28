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

@interface MenuTableViewController ()

@end

@implementation MenuTableViewController

@synthesize menu, order;

- (void)reviewOrder {
    NSLog(@"This is a stub");
    //segue to order review page
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //add continue button to bottom of table view
    UIScreen *mainScreen = [UIScreen mainScreen];
    UIView* bottomView = [[UIView alloc] initWithFrame:
        CGRectMake(0,mainScreen.bounds.size.height - 10,mainScreen.bounds.size.width,mainScreen.bounds.size.height)];
    UIButton *myButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    myButton.frame = CGRectMake(mainScreen.bounds.size.width/3, 0, mainScreen.bounds.size.width/3, 50);
    [myButton setTitle:@"Continue" forState:UIControlStateNormal];
    [myButton addTarget:self action:@selector(reviewOrder) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:myButton];
    self.tableView.tableFooterView = bottomView;
    
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuItem* foodItem = [self menuItemForIndexPath:indexPath];
    

    [order.menuItems addObject:foodItem];
    AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.thisUser.group updateOrder];
    NSLog(@"%@", delegate.thisUser.group.order);
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
