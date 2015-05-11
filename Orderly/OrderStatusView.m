//
//  OrderStatusView.m
//  OmniSplit
//
//  Created by Ashley Sehatti on 5/8/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import "OrderStatusView.h"

@implementation OrderStatusView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        }
    return self;
}


- (void)drawRect:(CGRect)rect {
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    UIBezierPath* largerCircle = [UIBezierPath bezierPath];
    UIBezierPath* middleCircle = [UIBezierPath bezierPath];
    UIBezierPath* smallerCircle = [UIBezierPath bezierPath];
    
    // Create our arc, with the correct angles
    [bezierPath addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2)
                          radius:115
                      startAngle:((3.14 * 0)/ 180)
                        endAngle:((3.14 * 130)/ 180)
                       clockwise:YES];
    
    [largerCircle addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2) radius:140 startAngle:0 endAngle:6.3 clockwise:YES];
    
    [middleCircle addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2) radius:90 startAngle:0 endAngle:6.3 clockwise:YES];
    
    [smallerCircle addArcWithCenter:CGPointMake(rect.size.width / 2, rect.size.height / 2) radius:80 startAngle:0 endAngle:6.3 clockwise:YES];
    
    bezierPath.lineWidth = 50;
    largerCircle.lineWidth = 5;
    middleCircle.lineWidth = 5;
    smallerCircle.lineWidth = 5;
    [[UIColor colorWithRed:103.0/255.0 green:4.0/255.0 blue:202.0/255.0 alpha:1] setStroke];
    [bezierPath stroke];
    [largerCircle stroke];
    [middleCircle stroke];
    [smallerCircle stroke];
}


@end
