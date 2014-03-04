//
//  TACPlateViewController.h
//  PMCExhibitionTable
//
//  Created by Shawn on 14-3-2.
//  Copyright (c) 2014年 com.nathan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingViewController.h"

@interface TACPlateViewController : UIViewController
- (IBAction)clickOK:(id)sender;
- (IBAction)clickDelete:(id)sender;
- (IBAction)clickCancel:(id)sender;
- (IBAction)clickNum:(UIButton *)sender;
- (IBAction)clickExit:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *plateDisp;

- (void)setTag:(int)tag;
- (void)setSettingViewController:(SettingViewController*) father;

@end
