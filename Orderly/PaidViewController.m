//
//  PaidViewController.m
//  OmniSplit
//
//  Created by Ashley Sehatti on 5/10/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import "PaidViewController.h"
#import "AppDelegate.h"
#import "Order.h"
#import "StarsView.h"

@interface PaidViewController ()

@end

@implementation PaidViewController

@synthesize total;

- (void)viewDidLoad {
    [super viewDidLoad];
    UIGraphicsBeginImageContext(self.view.frame.size);
    [[UIImage imageNamed:@"Elegant_Background-7"] drawInRect:self.view.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
    self.navigationController.navigationBarHidden = YES;
    
    AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.1, self.view.frame.size.height * 0.1, self.view.frame.size.width * 0.8, self.view.frame.size.height * 0.3)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont fontWithName:@"Avenir" size:20];
    label.text = [NSString stringWithFormat:@"You paid %@ $%.02f.\nThank you! Come back soon!\n\nRate the items you ordered:", delegate.theMenu.restaurant, total];
    label.numberOfLines = 5;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self.view addSubview:label];
    
    NSArray* uniqueItems = [delegate.thisUser.order listOfUniqueItems];
    for (int i = 0; i < uniqueItems.count; i++) {
        MenuItem* item = uniqueItems[i];
        UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.1, self.view.frame.size.height * 0.4 + i*25, self.view.frame.size.width * 0.4, 30)];
        label.font = [UIFont fontWithName:@"Avenir" size:20];
        label.text = item.name;
        label.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:label];
        
        StarsView* stars = [[StarsView alloc]initWithFrame:CGRectMake(self.view.frame.size.width * 0.5, self.view.frame.size.height * 0.4 + i*25, self.view.frame.size.width * 0.4, 30)];
        UITapGestureRecognizer *gesRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(turnPurple:)];
        [stars addGestureRecognizer:gesRecognizer];
        [self.view addSubview:stars];
    }
    
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(self.view.frame.size.width* 0.1, self.view.frame.size.height * 0.7, self.view.frame.size.width * 0.8, self.view.frame.size.height * 0.1);
    button.titleLabel.font = [UIFont fontWithName:@"Avenir" size:26];
    button.titleLabel.textAlignment = NSTextAlignmentCenter;
    [button setTitle:@"Finish" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:103.0/255.0 green:4.0/255.0 blue:202.0/255.0 alpha:1] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];

    // Do any additional setup after loading the view.
}

- (void)turnPurple:(UITapGestureRecognizer *)tapRecognizer{
    StarsView* view = (StarsView*) tapRecognizer.view;
    CGPoint touchPoint = [tapRecognizer locationInView:[tapRecognizer.view self]];
    [((StarsView*) view) fillToPoint:touchPoint];
}

- (void)finish {
    AppDelegate* delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate.thisUser leaveGroup];
    [self.navigationController popToRootViewControllerAnimated:NO];
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
