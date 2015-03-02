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
    for (int i = 0; i<user.order.menuItems.count; i++) {
        MenuItem* foodItem = user.order.menuItems[i];
        if ([arrayOfItems containsObject:foodItem]) {
            int num = [foodItem addAnother];
            arrayOfItems[[arrayOfItems indexOfObject:foodItem]] = [NSString stringWithFormat:@"%@ x %d\t$%.02f", foodItem.name, num, foodItem.price*num];
        }
        else
            [arrayOfItems addObject:[NSString stringWithFormat:@"%@ \t\t$%.02f", foodItem.name, foodItem.price]];
    }
    [arrayOfItems addObject:[NSString stringWithFormat:@"\nTotal price: \t\t$%.02f", user.order.totalPrice]];
    userOrder.text = [arrayOfItems componentsJoinedByString:@"\n"];
    
    [arrayOfItems removeAllObjects];
    for (int i = 0; i<user.group.order.menuItems.count; i++) {
        MenuItem* foodItem = user.group.order.menuItems[i];
        if ([arrayOfItems containsObject:foodItem]) {
            int num = [foodItem addAnother];
            arrayOfItems[[arrayOfItems indexOfObject:foodItem]] = [NSString stringWithFormat:@"%@ x %d\t$%.02f", foodItem.name, num, foodItem.price*num];
        }
        else
            [arrayOfItems addObject:[NSString stringWithFormat:@"%@ \t\t$%.02f", foodItem.name, foodItem.price]];
    }
    [arrayOfItems addObject:[NSString stringWithFormat:@"\nTotal price: \t\t$%.02f", user.group.order.totalPrice]];
    groupOrder.text = [arrayOfItems componentsJoinedByString:@"\n"];
}

- (IBAction)submitOrder {
    [user submitOrder];
    //segue
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
