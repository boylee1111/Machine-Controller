//
//  TACPlateViewController.m
//  PMCExhibitionTable
//
//  Created by Shawn on 14-3-2.
//  Copyright (c) 2014年 com.nathan. All rights reserved.
//

#import "TACPlateViewController.h"
#import "TACSettingManager.h"

#define BASE_TAG_FOR_MAX_SPEED_SETTING_TRANS_BUTTON 310
#define BASE_TAG_FOR_DEFAULT_SPEED_SETTING_TRANS_BUTTON 410
#define TAG_FOR_DEMO_MODE_TIME_TRANS_BUTTON 510
#define TAG_FOR_HEIGHT_TRANS_BUTTON 610

#define ROTATE_SPEED_FLAG 1
#define TIME_FLAG 2
#define HEIGHT_FLAG 3


@interface TACPlateViewController () {
    BOOL clickOrNot;
    
    int Tag;
    int flag;
    int rmpNumber;
    
    int min;
    int sec;
    
    int timeState;
    
    float height;
    int heightState;
    
    SettingViewController* FatherViewController;
}

@end

@implementation TACPlateViewController

@synthesize plateDisp;

- (void)setTag: (int)tag {
    Tag = tag;
}

- (void)setSettingViewController: (SettingViewController *)father {
    FatherViewController = father;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        clickOrNot = false;
        Tag = 0;
        flag = 0;
        rmpNumber = 0;
        min = 0;
        sec = 0;
        timeState = 0;
        height = 0;
        heightState = 0;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    flag = 0;
    if (Tag >= BASE_TAG_FOR_MAX_SPEED_SETTING_TRANS_BUTTON && Tag < BASE_TAG_FOR_MAX_SPEED_SETTING_TRANS_BUTTON + 8) {
        flag = ROTATE_SPEED_FLAG;
    } else if (Tag >= BASE_TAG_FOR_DEFAULT_SPEED_SETTING_TRANS_BUTTON && Tag < BASE_TAG_FOR_DEFAULT_SPEED_SETTING_TRANS_BUTTON + 8) {
        flag = ROTATE_SPEED_FLAG;
    } else if (Tag == TAG_FOR_DEMO_MODE_TIME_TRANS_BUTTON) {
        flag = TIME_FLAG;
    } else if (Tag == TAG_FOR_HEIGHT_TRANS_BUTTON) {
        flag = HEIGHT_FLAG;
    }
    
    //    if (flag == ROTATE_SPEED_FLAG) {
    //        plateDisp.text = [NSString stringWithFormat:@"%d rmp", (int)rmpNumber];
    //    } else if (flag == TIME_FLAG) {
    //        if (sec < 10) {
    //            plateDisp.text = [NSString stringWithFormat:@"%d min 0%d sed", min, sec];
    //        } else {
    //            plateDisp.text = [NSString stringWithFormat:@"%d min %d sed", min, sec];
    //        }
    //    } else if (flag == HEIGHT_FLAG) {
    //        plateDisp.text = [NSString stringWithFormat:@"%.2f m", height];
    //    }
    [self dispCurrentPlateNumber];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.5]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)clickOK:(id)sender {
    if (!clickOrNot) {
        [self clickExit:sender];
    } else
        if (flag == ROTATE_SPEED_FLAG) {
            if ((rmpNumber <10 && rmpNumber != 0) || rmpNumber > 1500) {
                [[[UIAlertView alloc]initWithTitle:@"Out of range" message:@"The speed should be 0 rmp or ranged from 10 rmp to 1500 rmp" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
            } else {
                if (Tag >= BASE_TAG_FOR_MAX_SPEED_SETTING_TRANS_BUTTON && Tag < BASE_TAG_FOR_MAX_SPEED_SETTING_TRANS_BUTTON + 8) {
                    int i = Tag - BASE_TAG_FOR_MAX_SPEED_SETTING_TRANS_BUTTON;
                    
                    [[TACSettingManager sharedManager] setMaxSpeedforMotor:i
                                                                 withSpeed:rmpNumber];
                    if ([[TACSettingManager sharedManager] maxSpeedOfMotor:i] < [[TACSettingManager sharedManager] defaultSpeedOfMotor:i]) {
                        [[TACSettingManager sharedManager] setDefaultSpeedforMotor:i
                                                                         withSpeed:rmpNumber];
                    }
                } else if (Tag >= BASE_TAG_FOR_DEFAULT_SPEED_SETTING_TRANS_BUTTON && Tag < BASE_TAG_FOR_DEFAULT_SPEED_SETTING_TRANS_BUTTON + 8) {
                    int i = Tag - BASE_TAG_FOR_DEFAULT_SPEED_SETTING_TRANS_BUTTON;
                    [[TACSettingManager sharedManager] setDefaultSpeedforMotor:i
                                                                     withSpeed:rmpNumber];
                    if ([[TACSettingManager sharedManager] maxSpeedOfMotor:i] < [[TACSettingManager sharedManager] defaultSpeedOfMotor:i]) {
                        [[TACSettingManager sharedManager] setMaxSpeedforMotor:i
                                                                     withSpeed:rmpNumber];
                    }
                    
                }
                [self clickExit:sender];
            }
        } else if (flag == TIME_FLAG) {
            if (sec >= 60) {
                [[[UIAlertView alloc]initWithTitle:@"Out of range" message:@"The second should be ranged from 0 sec to 59 sec" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
            } else {
                [[TACSettingManager sharedManager] setDemoModeTime:min * 60 + sec];
                [self clickExit:sender];
            }
        } else if (flag == HEIGHT_FLAG) {
            if (height > 2.0f || height < 1.2f) {
                [[[UIAlertView alloc]initWithTitle:@"Out of range" message:@"The height should be ranged from 1.20 m to 2.00 m" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil]show];
            } else {
                [[TACSettingManager sharedManager] setHeight:height * 100];
                [self clickExit:sender];
            }
        }
    if (FatherViewController != nil) {
        [FatherViewController updateLabelsAndButtonStatus];
    }
}

- (IBAction)clickDelete:(id)sender {
    clickOrNot = true;
    
    if (flag == ROTATE_SPEED_FLAG) {
        rmpNumber = rmpNumber / 10;
    } else if (flag == TIME_FLAG) {
        if (timeState == 3) {
            sec = (sec / 10) * 10;
            timeState--;
        } else if (timeState == 2) {
            sec = 0;
            timeState--;
        } else if (timeState == 1) {
            sec = 0;
            min = 0;
            timeState--;
        }
    } else if (flag == HEIGHT_FLAG) {
        if (heightState == 3) {
            height = (float)((int)(height * 100) / 10) / 10;
            heightState--;
        } else if (heightState == 2) {
            height = (int)(height * 10) / 10;
            heightState--;
        } else if (heightState == 1) {
            height = 0;
            heightState--;
        }
    }
    
    [self updatePlateNumber];
}

- (IBAction)clickCancel:(id)sender {
    rmpNumber = 0;
    sec = 0;
    min = 0;
    timeState = 0;
    height = 0;
    heightState = 0;
    [self updatePlateNumber];
}

- (IBAction)clickNum:(UIButton *)sender {
    clickOrNot = true;
    
    int value = [sender.currentTitle intValue];
    if (flag == ROTATE_SPEED_FLAG) {
        if (rmpNumber * 10 + value < 10000) {
            rmpNumber = rmpNumber * 10 + value;
        }
    } else if (flag == TIME_FLAG) {
        if (timeState == 0) {
            min = value;
            timeState++;
        }else if (timeState == 1) {
            sec = value * 10;
            timeState++;
        } else if (timeState == 2) {
            sec += value;
            timeState++;
        }
        
    } else if (flag == HEIGHT_FLAG) {
        if (heightState == 0) {
            height = value;
            heightState++;
        } else if (heightState == 1) {
            height += value * 0.1f;
            heightState++;
        } else if (heightState == 2) {
            height += value * 0.01f;
            heightState++;
        }
    }
    [self updatePlateNumber];
}

- (IBAction)clickExit:(UIButton *)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)dispCurrentPlateNumber {
    if (flag == ROTATE_SPEED_FLAG) {
        if (Tag >= BASE_TAG_FOR_MAX_SPEED_SETTING_TRANS_BUTTON && Tag < BASE_TAG_FOR_MAX_SPEED_SETTING_TRANS_BUTTON + 8) {
            int i = Tag - BASE_TAG_FOR_MAX_SPEED_SETTING_TRANS_BUTTON;
            int _rmpNumber = [[TACSettingManager sharedManager] maxSpeedOfMotor:i];
            plateDisp.text = [NSString stringWithFormat:@"%d rmp", (int)_rmpNumber];
        } else if (Tag >= BASE_TAG_FOR_DEFAULT_SPEED_SETTING_TRANS_BUTTON && Tag < BASE_TAG_FOR_DEFAULT_SPEED_SETTING_TRANS_BUTTON + 8) {
            int i = Tag - BASE_TAG_FOR_DEFAULT_SPEED_SETTING_TRANS_BUTTON;
            int _rmpNumber = [[TACSettingManager sharedManager] defaultSpeedOfMotor:i];
            plateDisp.text = [NSString stringWithFormat:@"%d rmp", (int)_rmpNumber];
        }
    } else if (flag == TIME_FLAG) {
        
        int seconds = [TACSettingManager sharedManager].DemoModeTime;
        int _min = seconds / 60;
        int _sec = seconds % 60;
        if (_sec < 10) {
            plateDisp.text = [NSString stringWithFormat:@"%d min 0%d sed", _min, _sec];
        } else {
            plateDisp.text = [NSString stringWithFormat:@"%d min %d sed", _min, _sec];
        }
    } else if (flag == HEIGHT_FLAG) {
        float _height = ((float)[TACSettingManager sharedManager].Height) / 100;
        plateDisp.text = [NSString stringWithFormat:@"%.2f m", _height];
    }
}

- (void)updatePlateNumber {
    if (flag == ROTATE_SPEED_FLAG) {
        plateDisp.text = [NSString stringWithFormat:@"%d rmp", (int)rmpNumber];
    } else if (flag == TIME_FLAG) {
        if (sec < 10) {
            plateDisp.text = [NSString stringWithFormat:@"%d min 0%d sed", min, sec];
        } else {
            plateDisp.text = [NSString stringWithFormat:@"%d min %d sed", min, sec];
        }
    } else if (flag == HEIGHT_FLAG) {
        plateDisp.text = [NSString stringWithFormat:@"%.2f m", height];
    }
}
@end
