//
//  TACHumanImageView.m
//  PMCExhibitionTable
//
//  Created by Shawn on 14-1-10.
//  Copyright (c) 2014年 com.nathan. All rights reserved.
//

#import "TACHumanImageView.h"

@implementation TACHumanImageView {
    CGPoint beganPoint;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.multipleTouchEnabled = NO;
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"hello");
    for (UITouch * touch in event.allTouches) {
        beganPoint = [touch locationInView:nil];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in event.allTouches) {
        NSLog(@"derta %f, %f", [touch locationInView:nil].x - beganPoint.x, [touch locationInView:nil].y - beganPoint.y);
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
}
    


@end
