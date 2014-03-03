//
//  TACPlateViewController.h
//  PMCExhibitionTable
//
//  Created by Shawn on 14-3-2.
//  Copyright (c) 2014年 com.nathan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TACPlateViewController : UIViewController
- (IBAction)clickNumber:(id)sender;
- (IBAction)clickOK:(id)sender;
- (IBAction)clickDelete:(id)sender;
- (IBAction)clickCancel:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *plateDisp;


@end
