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
#import "OrderStatusViewController.h"

@interface ReviewOrderViewController ()

@end

@implementation ReviewOrderViewController

@synthesize user;

UIScrollView* scrollView;
UILabel* yourOrderLabel;
UILabel* userOrderLeft;
UILabel* userOrderRight;
UILabel* userOrderTotal;
UIButton* submitButton;
UILabel* groupOrderLabel;
UILabel* groupOrderLeft;
UILabel* groupOrderRight;
UILabel* groupOrderTotal;
NSTimer* aTimer;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"Elegant_Background-7"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    
    AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    user = delegate.thisUser;
    
    scrollView = [[UIScrollView alloc] init];
    
    yourOrderLabel = [[UILabel alloc] init];
    yourOrderLabel.text = @"Your Order:";
    yourOrderLabel.textAlignment = NSTextAlignmentCenter;
    yourOrderLabel.font = [UIFont fontWithName:@"Avenir" size:20];

    userOrderLeft = [[UILabel alloc] init];
    userOrderLeft.adjustsFontSizeToFitWidth = YES;
    userOrderLeft.font = [UIFont fontWithName:@"Avenir" size:17];
    
    userOrderRight = [[UILabel alloc] init];
    userOrderRight.lineBreakMode = NSLineBreakByWordWrapping;
    userOrderRight.font = [UIFont fontWithName:@"Avenir" size:17];
    
    userOrderTotal = [[UILabel alloc] init];
    userOrderTotal.textAlignment = NSTextAlignmentCenter;
    userOrderTotal.font = [UIFont fontWithName:@"Avenir" size:20];
    
    [scrollView addSubview:yourOrderLabel];
    [scrollView addSubview:userOrderLeft];
    [scrollView addSubview:userOrderRight];
    [scrollView addSubview:userOrderTotal];
    
    submitButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [submitButton setTitle:@"Submit" forState:UIControlStateNormal];
    [submitButton addTarget:self action:@selector(submitOrder) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setTitleColor:[UIColor colorWithRed:103.0/255.0 green:4.0/255.0 blue:202.0/255.0 alpha:1] forState:UIControlStateNormal];
    submitButton.titleLabel.font = [UIFont fontWithName:@"Avenir" size:26];
    [scrollView addSubview:submitButton];
    
    groupOrderLabel = [[UILabel alloc]init];
    groupOrderLabel.text = @"Group Order:";
    groupOrderLabel.textAlignment = NSTextAlignmentCenter;
    groupOrderLabel.font = [UIFont fontWithName:@"Avenir" size:20];
    [scrollView addSubview:groupOrderLabel];
    
    groupOrderLeft = [[UILabel alloc] init];
    groupOrderLeft.adjustsFontSizeToFitWidth = YES;
    groupOrderLeft.font = [UIFont fontWithName:@"Avenir" size:17];
    
    groupOrderRight = [[UILabel alloc] init];
    groupOrderRight.lineBreakMode = NSLineBreakByWordWrapping;
    groupOrderRight.font = [UIFont fontWithName:@"Avenir" size:17];
    
    groupOrderTotal = [[UILabel alloc] init];
    groupOrderTotal.textAlignment = NSTextAlignmentCenter;
    groupOrderTotal.font = [UIFont fontWithName:@"Avenir" size:20];
    
    [scrollView addSubview:groupOrderLeft];
    [scrollView addSubview:groupOrderRight];
    [scrollView addSubview:groupOrderTotal];
    
    [self.view addSubview:scrollView];
    [self populateView];
    aTimer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(timerStuff) userInfo:nil repeats:YES];
}

- (void)timerStuff {
    if (user.group.order.status == CHANGED) {
        [self populateView];
        user.group.order.status = ORDERING;
    }
}

- (void)populateView {
    scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    yourOrderLabel.frame = CGRectMake(self.view.frame.size.width * 0.33, 50, self.view.frame.size.width * 0.33, 25);
    
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
    userOrderLeft.frame = CGRectMake(self.view.frame.size.width * 0.1, 75, self.view.frame.size.width * 0.60, 25 * arrayOfStringsRight.count);
    userOrderLeft.numberOfLines = arrayOfStringsRight.count;
    userOrderRight.frame = CGRectMake(self.view.frame.size.width * 0.7, 75, self.view.frame.size.width * 0.20, 25 * arrayOfStringsRight.count);
    userOrderRight.numberOfLines = arrayOfStringsRight.count;
    int n = 25 * arrayOfStringsRight.count + 75;
    userOrderLeft.text = [arrayOfStringsLeft componentsJoinedByString:@"\n"];
    userOrderRight.text = [arrayOfStringsRight componentsJoinedByString:@"\n"];
    userOrderTotal.frame = CGRectMake(self.view.frame.size.width * 0.2, n, self.view.frame.size.width * 0.6, 25);
    userOrderTotal.text = [NSString stringWithFormat:@"Total price: \t$%.02f", user.order.totalPrice];
    n += 50;
    
    submitButton.frame = CGRectMake(self.view.frame.size.width * 0.2, n + 25, self.view.frame.size.width * 0.6, 50);
    n += 75;
    
    groupOrderLabel.frame = CGRectMake(self.view.frame.size.width * 0.33, n + 50, self.view.frame.size.width * 0.33, 25);

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
    groupOrderLeft.frame = CGRectMake(self.view.frame.size.width * 0.1, n + 75, self.view.frame.size.width * 0.6, 25 * arrayOfStringsRight.count);
    groupOrderLeft.numberOfLines = arrayOfStringsRight.count;
    groupOrderRight.frame = CGRectMake(self.view.frame.size.width * 0.7, n + 75, self.view.frame.size.width * 0.2, 25 * arrayOfStringsRight.count);
    groupOrderRight.numberOfLines = arrayOfStringsRight.count;
    n += 75 + 25 * arrayOfStringsRight.count;
    groupOrderLeft.text = [arrayOfStringsLeft componentsJoinedByString:@"\n"];
    groupOrderRight.text = [arrayOfStringsRight componentsJoinedByString:@"\n"];
    groupOrderTotal.frame = CGRectMake(self.view.frame.size.width * 0.2, n, self.view.frame.size.width * 0.6, 25);
    n += 50;
    groupOrderTotal.text = [NSString stringWithFormat:@"Total price: \t$%.02f", user.group.order.totalPrice];
    

    scrollView.contentSize = CGSizeMake(scrollView.frame.size.width, n + 200);
    
    [scrollView layoutIfNeeded];
}

- (void)submitOrder {
    [aTimer invalidate];
    OrderStatusViewController *vc = [[OrderStatusViewController alloc] init];
    self.navigationItem.title = @"";
    [self.navigationController pushViewController:vc animated:YES];
    [user submitOrder];
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
