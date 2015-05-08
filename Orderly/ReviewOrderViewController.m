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

@synthesize user;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateView];
}

- (void)updateView {
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    UILabel* yourOrderLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.33, 50, self.view.frame.size.width * 0.33, 25)];
    yourOrderLabel.text = @"Your Order:";
    yourOrderLabel.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:yourOrderLabel];
    NSMutableArray* arrayOfItems = [[NSMutableArray alloc] init];
    NSMutableArray* arrayOfAmounts = [[NSMutableArray alloc] init];
    NSMutableArray* arrayOfStringsLeft = [[NSMutableArray alloc] init];
    NSMutableArray* arrayOfStringsRight = [[NSMutableArray alloc] init];
    for (int i = 0; i<user.order.menuItems.count; i++) {
        MenuItem* foodItem = user.order.menuItems[i];
        if ([arrayOfItems containsObject:foodItem]) {
            NSUInteger index = [arrayOfItems indexOfObject:foodItem];
            arrayOfAmounts[index] = [NSNumber numberWithInt:([(NSNumber*)arrayOfAmounts[index] intValue] + 1)];
            arrayOfStringsLeft[index] = [NSString stringWithFormat:@"%@ x %d", foodItem.name, [(NSNumber*)arrayOfAmounts[index] intValue]];
            arrayOfStringsRight[index] = [NSString stringWithFormat:@"$%.02f", foodItem.price*[(NSNumber*)arrayOfAmounts[index] intValue]];
        }
        else {
            [arrayOfItems addObject:foodItem];
            [arrayOfAmounts addObject:[NSNumber numberWithInt:1]];
            [arrayOfStringsLeft addObject:[NSString stringWithFormat:@"%@", foodItem.name]];
            [arrayOfStringsRight addObject:[NSString stringWithFormat:@"$%.02f", foodItem.price]];
        }
    }
    UILabel* userOrderLeft = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.15, 75, self.view.frame.size.width * 0.50, 25 * arrayOfStringsRight.count)];
    userOrderLeft.numberOfLines = arrayOfStringsRight.count;
    userOrderLeft.adjustsFontSizeToFitWidth = YES;
    UILabel* userOrderRight = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.7, 75, self.view.frame.size.width * 0.15, 25 * arrayOfStringsRight.count)];
    userOrderRight.numberOfLines = arrayOfStringsRight.count;
    userOrderRight.lineBreakMode = NSLineBreakByWordWrapping;
    int n = 25 * arrayOfStringsRight.count + 75;
    userOrderLeft.text = [arrayOfStringsLeft componentsJoinedByString:@"\n"];
    userOrderRight.text = [arrayOfStringsRight componentsJoinedByString:@"\n"];
    UILabel* userOrderTotal = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.2, n, self.view.frame.size.width * 0.6, 25)];
    userOrderTotal.text = [NSString stringWithFormat:@"Total price: \t$%.02f", user.order.totalPrice];
    userOrderTotal.textAlignment = NSTextAlignmentCenter;
    n += 50;
    [scrollView addSubview:userOrderLeft];
    [scrollView addSubview:userOrderRight];
    [scrollView addSubview:userOrderTotal];
    
    UIButton* submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitButton.frame = CGRectMake(self.view.frame.size.width * 0.2, n + 25, self.view.frame.size.width * 0.6, 50);
    n += 75;
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitOrder) forControlEvents:UIControlEventTouchUpInside];
    submitButton.titleLabel.font = [UIFont systemFontOfSize:24];
    [scrollView addSubview:submitButton];
    
    UILabel* groupOrderLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.33, n + 50, self.view.frame.size.width * 0.33, 25)];
    groupOrderLabel.text = @"Group Order:";
    groupOrderLabel.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:groupOrderLabel];
    [arrayOfItems removeAllObjects];
    [arrayOfAmounts removeAllObjects];
    [arrayOfStringsLeft removeAllObjects];
    [arrayOfStringsRight removeAllObjects];
    for (int i = 0; i<user.group.order.menuItems.count; i++) {
        MenuItem* foodItem = user.group.order.menuItems[i];
        if ([arrayOfItems containsObject:foodItem]) {
            NSUInteger index = [arrayOfItems indexOfObject:foodItem];
            arrayOfAmounts[index] = [NSNumber numberWithInt:([(NSNumber*)arrayOfAmounts[index] intValue] + 1)];
            arrayOfStringsLeft[index] = [NSString stringWithFormat:@"%@ x %d", foodItem.name, [(NSNumber*)arrayOfAmounts[index] intValue]];
            arrayOfStringsRight[index] = [NSString stringWithFormat:@"$%.02f", foodItem.price*[(NSNumber*)arrayOfAmounts[index] intValue]];
        }
        else {
            [arrayOfItems addObject:foodItem];
            [arrayOfAmounts addObject:[NSNumber numberWithInt:1]];
            [arrayOfStringsLeft addObject:[NSString stringWithFormat:@"%@", foodItem.name]];
            [arrayOfStringsRight addObject:[NSString stringWithFormat:@"$%.02f", foodItem.price]];
        }
    }
    UILabel* groupOrderLeft = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.15, n + 75, self.view.frame.size.width * 0.50, 25 * arrayOfStringsRight.count)];
    groupOrderLeft.numberOfLines = arrayOfStringsRight.count;
    groupOrderLeft.adjustsFontSizeToFitWidth = YES;
    UILabel* groupOrderRight = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.7, n + 75, self.view.frame.size.width * 0.15, 25 * arrayOfStringsRight.count)];
    groupOrderRight.numberOfLines = arrayOfStringsRight.count;
    groupOrderRight.lineBreakMode = NSLineBreakByWordWrapping;
    n += 75 + 25 * arrayOfStringsRight.count;
    groupOrderLeft.text = [arrayOfStringsLeft componentsJoinedByString:@"\n"];
    groupOrderRight.text = [arrayOfStringsRight componentsJoinedByString:@"\n"];
    UILabel* groupOrderTotal = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.2, n, self.view.frame.size.width * 0.6, 25)];
    n += 50;
    groupOrderTotal.text = [NSString stringWithFormat:@"Total price: \t$%.02f", user.group.order.totalPrice];
    groupOrderTotal.textAlignment = NSTextAlignmentCenter;
    [scrollView addSubview:groupOrderLeft];
    [scrollView addSubview:groupOrderRight];
    [scrollView addSubview:groupOrderTotal];

    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, n + 200);
    
    [scrollView layoutIfNeeded];
    [self.view addSubview:scrollView];
}

- (void)submitOrder {
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
