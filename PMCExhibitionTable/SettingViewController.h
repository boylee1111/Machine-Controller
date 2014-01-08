//
//  SettingViewController.h
//  PMCExhibitionTable
//
//  Created by Shawn on 14-1-8.
//  Copyright (c) 2014年 com.nathan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *SettingBar;
@property (strong, nonatomic) IBOutlet UILabel *MaxSpeedBar;
@property (strong, nonatomic) IBOutlet UILabel *DemoModeBar;
@property (strong, nonatomic) IBOutlet UILabel *DefaultSpeedBar;
@property (strong, nonatomic) IBOutlet UILabel *DefaultHeightBar;
@property (strong, nonatomic) IBOutlet UILabel *SpeedInputBox;
- (IBAction)close:(id)sender;

@end
