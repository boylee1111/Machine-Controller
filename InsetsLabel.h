//
//  InsetsLabel.h
//  PMCExhibitionTable
//
//  Created by Shawn on 14-1-8.
//  Copyright (c) 2014年 com.nathan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InsetsLabel : UILabel
@property(nonatomic) UIEdgeInsets insets;

- (id)initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets) insets;
- (id)initWithInsets:(UIEdgeInsets) insets;
@end
