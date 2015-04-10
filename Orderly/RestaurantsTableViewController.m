//
//  RestaurantsTableViewController.m
//  OmniSplit
//
//  Created by Jordan Buschman on 3/5/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestaurantsTableViewController.h"
#import "Restaurants.h"
#import "RestaurantTableViewCell.h"
#import "RestaurantLandingPageViewController.h"

@implementation RestaurantsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self dispatchRestaurantsThread];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat) tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 86;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 86;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    Restaurants * r = [Restaurants globalRestaurants];
    return [[r restaurantList] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"RestaurantCell";
    
    RestaurantTableViewCell *cell = (RestaurantTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    Restaurants * globalRestaurants = [Restaurants globalRestaurants];
    NSMutableArray * restaurants = [globalRestaurants restaurantList];
    
    NSDictionary * restaurant = [restaurants objectAtIndex:indexPath.row];
    NSDictionary * address = [restaurant objectForKey:@"address"];
    
    cell.restaurantNameLabel.text = [restaurant objectForKey:@"name"];
    cell.descriptionLabel.text = [restaurant objectForKey:@"description"];
    cell.menuId = [restaurant objectForKey:@"menu"];
    NSLog(@"FOUND RESTAURANT WITH MENU ID %@", cell.menuId);
    
    if ([address valueForKey:@"addressLine2"] != nil)
        cell.addressLine1Label.text = [NSString stringWithFormat:@"%@, %@", [address objectForKey:@"addressLine1"], [address objectForKey: @"addressLine2"]];
    else
        cell.addressLine1Label.text = [address objectForKey:@"addressLine1"];
    
    cell.addressLine2Label.text = [NSString stringWithFormat:@"%@, %@ %@", [address valueForKey:@"city"], [address valueForKey:@"state"], [address valueForKey:@"zip"]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RestaurantTableViewCell *cell = (RestaurantTableViewCell*) [tableView cellForRowAtIndexPath:indexPath];
    UIStoryboard *storyboard = self.storyboard;
    UIViewController *presentVC = [storyboard instantiateViewControllerWithIdentifier:@"LandingPage"];
    [self.navigationController pushViewController:presentVC animated:YES];
    if ([presentVC isKindOfClass:[RestaurantLandingPageViewController class]]) {
        RestaurantLandingPageViewController *pageVC = (RestaurantLandingPageViewController *) presentVC;
        pageVC.restaurantId = cell.menuId;
        pageVC._restaurantName = cell.restaurantNameLabel.text;
        pageVC._restaurantInfo = cell.descriptionLabel.text;
    }
    
}

- (void) dispatchRestaurantsThread {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"Dispatching get restaurants thread...");
        Restaurants * globalRestaurants = [Restaurants globalRestaurants];
        [globalRestaurants getRestaurants];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

@end