//
//  RestaurantsTableViewController.h
//  OmniSplit
//
//  Created by Jordan Buschman on 3/5/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantsTableViewController: UITableViewController <UITableViewDelegate, UITableViewDataSource>

-(void) dispatchRestaurantsThread;

@end