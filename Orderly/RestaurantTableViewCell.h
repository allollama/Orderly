//
//  RestaurantTableViewCell.h
//  OmniSplit
//
//  Created by Jordan Buschman on 3/5/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RestaurantTableViewCell: UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *restaurantNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *descriptionLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLine1Label;
@property (nonatomic, weak) IBOutlet UILabel *addressLine2Label;
@property NSString * menuId;

@end