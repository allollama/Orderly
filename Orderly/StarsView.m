//
//  StarsView.m
//  OmniSplit
//
//  Created by Ashley Sehatti on 5/12/15.
//  Copyright (c) 2015 Santa Clara University. All rights reserved.
//

#import "StarsView.h"

@implementation StarsView

CGColorRef aColor;
int n;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        n = 0;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    //int aSize = 50.0;
    //const CGFloat color[4] = { 0.0, 0.0, 1.0, 1.0 }; // Blue
    
    CGFloat xCenter = rect.size.width / 8;
    CGFloat yCenter = rect.size.height / 2;
    
    float  w = rect.size.width / 7;
    double r = w / 2.0;
    float flip = -1.0;
    
    for (NSUInteger i=0; i<5; i++)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 5);
        
        if (n <= i) {
            aColor = [UIColor lightGrayColor].CGColor;
        }
        else {
            aColor = [UIColor colorWithRed:103.0/255.0 green:4.0/255.0 blue:202.0/255.0 alpha:1].CGColor;
        }
        CGContextSetFillColorWithColor(context, aColor);
        CGContextSetStrokeColorWithColor(context, aColor);
        
        double theta = 2.0 * M_PI * (2.0 / 5.0); // 144 degrees
        
        CGContextMoveToPoint(context, xCenter, r*flip+yCenter);
        
        for (NSUInteger k=1; k<5; k++)
        {
            float x = r * sin(k * theta);
            float y = r * cos(k * theta);
            CGContextAddLineToPoint(context, x+xCenter, y*flip+yCenter);
        }
        CGContextClosePath(context);
        CGContextFillPath(context);

        xCenter += rect.size.width *0.2;
    }
}

- (void)fillToPoint:(CGPoint)pt {
    n = pt.x / (self.frame.size.width / 5) + 1;
    [self setNeedsDisplay];
}

@end
