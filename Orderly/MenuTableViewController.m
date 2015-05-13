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

@synthesize menu, user, restaurantName;

- (void)reviewOrder {
    ReviewOrderViewController *vc = [[ReviewOrderViewController alloc] init];
    self.navigationItem.title = @"";
    vc.navigationItem.title = restaurantName;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"Elegant_Background-7"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    if (user.group != nil) {
        //add continue button to bottom of table view
        UIScreen *mainScreen = [UIScreen mainScreen];
        UIView* bottomView = [[UIView alloc] initWithFrame:CGRectMake(0,mainScreen.bounds.size.height - 10,mainScreen.bounds.size.width,100)];
        UIButton *myButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        myButton.frame = CGRectMake(mainScreen.bounds.size.width * 0.1, 0, mainScreen.bounds.size.width * 0.8, 50);
        myButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:26];
        myButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [myButton setTitle:@"CONTINUE" forState:UIControlStateNormal];
        [myButton setTitleColor:[UIColor colorWithRed:103.0/255.0 green:4.0/255.0 blue:202.0/255.0 alpha:1] forState:UIControlStateNormal];
        [myButton addTarget:self action:@selector(reviewOrder) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:myButton];
        self.tableView.tableFooterView = bottomView;
    }
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.navigationItem.title = restaurantName;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
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
    NSString* cellID = @"MenuCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    cell.accessoryView = nil;
    MenuItem* foodItem = [self menuItemForIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"$%.02f %@", foodItem.price, foodItem.name];
    cell.detailTextLabel.text = foodItem.descrp;
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([user numberOfItemInOrder:foodItem] > 0) {
        [self addAccessoryView:cell atIndexPath:indexPath];
    }
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
    }
    [self addAccessoryView:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
}
- (void)addAccessoryView:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    MenuItem* foodItem = [self menuItemForIndexPath:indexPath];
    if (user.group != nil) {
        myButton* numberMinusButton = [myButton buttonWithType:UIButtonTypeRoundedRect];
        UIImage* image = [UIImage imageNamed:@"200px-Ambox_emblem_minus.svg.png"];
        [numberMinusButton setBackgroundImage:image forState:UIControlStateNormal];
        [numberMinusButton addTarget:self action:@selector(removeItem:) forControlEvents:UIControlEventTouchUpInside];
        numberMinusButton.indexPath = indexPath;
        numberMinusButton.frame = CGRectMake(0, 0, 70, cell.frame.size.height);
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(70, 0, 40, cell.frame.size.height)];
        label.text = [NSString stringWithFormat:@"%d", [user numberOfItemInOrder:foodItem]];
        UIView* subview = [[UIView alloc]initWithFrame:CGRectMake(cell.frame.size.width * 0.70, 0, 110, cell.frame.size.height)];
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
