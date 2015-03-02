//
//  ReviewOrderViewController.m
//  OmniSplit
//
//  Created by Ashley Sehatti on 3/1/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import "ReviewOrderViewController.h"
#import "AppDelegate.h"
#import "Order.h"
#import "Group.h"
#import "MenuItem.h"

@interface ReviewOrderViewController ()

@end

@implementation ReviewOrderViewController

@synthesize user, userOrder, groupOrder;

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray* arrayOfItems = [[NSMutableArray alloc] init];
    NSMutableArray* arrayOfAmounts = [[NSMutableArray alloc] init];
    NSMutableArray* arrayOfStrings = [[NSMutableArray alloc] init];
    for (int i = 0; i<user.order.menuItems.count; i++) {
        MenuItem* foodItem = user.order.menuItems[i];
        if ([arrayOfItems containsObject:foodItem]) {
            NSUInteger index = [arrayOfItems indexOfObject:foodItem];
            arrayOfAmounts[index] = [NSNumber numberWithInt:([(NSNumber*)arrayOfAmounts[index] intValue] + 1)];
            arrayOfStrings[index] = [NSString stringWithFormat:@"%@ x %d\t$%.02f", foodItem.name, [(NSNumber*)arrayOfAmounts[index] intValue], foodItem.price*[(NSNumber*)arrayOfAmounts[index] intValue]];
        }
        else {
            [arrayOfItems addObject:foodItem];
            [arrayOfAmounts addObject:[NSNumber numberWithInt:1]];
            [arrayOfStrings addObject:[NSString stringWithFormat:@"%@ \t\t$%.02f", foodItem.name, foodItem.price]];
        }
    }
    [arrayOfStrings addObject:[NSString stringWithFormat:@"\nTotal price: \t\t$%.02f", user.order.totalPrice]];
    userOrder.text = [arrayOfStrings componentsJoinedByString:@"\n"];
    
    [arrayOfItems removeAllObjects];
    [arrayOfAmounts removeAllObjects];
    [arrayOfStrings removeAllObjects];
    for (int i = 0; i<user.group.order.menuItems.count; i++) {
        MenuItem* foodItem = user.group.order.menuItems[i];
        if ([arrayOfItems containsObject:foodItem]) {
            NSUInteger index = [arrayOfItems indexOfObject:foodItem];
            arrayOfAmounts[index] = [NSNumber numberWithInt:([(NSNumber*)arrayOfAmounts[index] intValue] + 1)];
            arrayOfStrings[index] = [NSString stringWithFormat:@"%@ x %d\t$%.02f", foodItem.name, [(NSNumber*)arrayOfAmounts[index] intValue], foodItem.price*[(NSNumber*)arrayOfAmounts[index] intValue]];
        }
        else {
            [arrayOfItems addObject:foodItem];
            [arrayOfAmounts addObject:[NSNumber numberWithInt:1]];
            [arrayOfStrings addObject:[NSString stringWithFormat:@"%@ \t\t$%.02f", foodItem.name, foodItem.price]];
        }
    }
    [arrayOfStrings addObject:[NSString stringWithFormat:@"\nTotal price: \t\t$%.02f", user.group.order.totalPrice]];
    groupOrder.text = [arrayOfStrings componentsJoinedByString:@"\n"];
}

- (IBAction)submitOrder {
    [user submitOrder];
    UIStoryboard *storyboard = self.storyboard;
    UIViewController *presentVC = [storyboard instantiateViewControllerWithIdentifier:@"OrderStatus"];
    [self.navigationController pushViewController:presentVC animated:YES];
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
