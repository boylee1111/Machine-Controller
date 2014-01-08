//
//  SettingViewController.m
//  PMCExhibitionTable
//
//  Created by Shawn on 14-1-8.
//  Copyright (c) 2014年 com.nathan. All rights reserved.
//

#import "SettingViewController.h"
#import "InsetsLabel.h"

@interface SettingViewController ()
@end

@implementation SettingViewController
@synthesize SettingBar;
@synthesize MaxSpeedBar;
@synthesize DemoModeBar;
@synthesize DefaultSpeedBar;
@synthesize DefaultHeightBar;
@synthesize SpeedInputBox;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    SettingBar.layer.borderWidth = 5.0f;
    SettingBar.layer.borderColor = [UIColor darkGrayColor].CGColor;
    SettingBar.layer.cornerRadius = 50.0f;
    
    MaxSpeedBar.layer.borderWidth = 3.0f;
    MaxSpeedBar.layer.borderColor = [UIColor darkGrayColor].CGColor;
    MaxSpeedBar.layer.cornerRadius = 45.0f;
    
    DemoModeBar.layer.borderWidth = 3.0f;
    DemoModeBar.layer.borderColor = [UIColor darkGrayColor].CGColor;
    DemoModeBar.layer.cornerRadius = 45.0f;
    
    DefaultSpeedBar.layer.borderWidth = 3.0f;
    DefaultSpeedBar.layer.borderColor = [UIColor darkGrayColor].CGColor;
    DefaultSpeedBar.layer.cornerRadius = 45.0f;
    
    DefaultHeightBar.layer.borderWidth = 3.0f;
    DefaultHeightBar.layer.borderColor = [UIColor darkGrayColor].CGColor;
    DefaultHeightBar.layer.cornerRadius = 30.0f;
    
    SpeedInputBox.layer.borderColor = [UIColor blackColor].CGColor;
    SpeedInputBox.layer.borderWidth = 3.0f;
    
    CGFloat x = 163.0f;
    CGFloat y = 216.0f;
    CGFloat difference = 68.0f;
    CGFloat width = 166.0f;
    CGFloat height = 55.0f;
    CGRect labelRect;
    UIEdgeInsets edge = UIEdgeInsetsMake(0, 10.0f, 0, 0);
    UIFont* font = [UIFont boldSystemFontOfSize:28.0f];
    
    CGRect upButtonRect;
    CGRect downButtonRect;
    
    InsetsLabel* label;
    UIButton* upButton;
    UIButton* downButton;
    
    //Maximum Speed Setting
    for (NSInteger i = 0; i < 7; i++) {
        
        labelRect = CGRectMake(x, y + i * difference, width, height);
        
        label = [[InsetsLabel alloc]initWithFrame:labelRect andInsets:edge];
        
        label.font = font;
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor whiteColor];
        label.text = @"1200rmp";
        label.tag = 10 + i;
        label.layer.borderWidth = 3.0f;
        label.layer.borderColor = [UIColor blackColor].CGColor;
        [self.view addSubview:label];
        
        upButtonRect = CGRectMake(10, 10, 25, 25);
        upButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [upButton setFrame:upButtonRect];
        [upButton setBackgroundImage:[UIImage imageNamed:@"setUp"] forState:UIControlStateNormal];
        
    }
    
    
    //Default Speed Settings
    x = 792;
    for (NSInteger i = 0; i < 7; i++) {
        
        labelRect = CGRectMake(x, y + i * difference, width, height);
        
        font = [UIFont boldSystemFontOfSize:28.0f];
        
        label = [[InsetsLabel alloc]initWithFrame:labelRect andInsets:edge];
        
        label.font = font;
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor whiteColor];
        label.text = @"1200rmp";
        label.tag = 20 + i;
        label.layer.borderWidth = 3.0f;
        label.layer.borderColor = [UIColor blackColor].CGColor;
        [self.view addSubview:label];
    }
    
    //Time
    x = 458.0f;
    y = 246.0f;
    width = 146.0f;
    height = 55.0f;
    labelRect = CGRectMake(x, y , width, height);
    
    font = [UIFont boldSystemFontOfSize:28.0f];
    
    label = [[InsetsLabel alloc]initWithFrame:labelRect andInsets:edge];
    
    label.font = font;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"2 mins";
    label.tag = 30;
    label.layer.borderWidth = 3.0f;
    label.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:label];

    //Height
    x = 482.0f;
    y = 448.0f;
    width = 146.0f;
    height = 55.0f;
    labelRect = CGRectMake(x, y , width, height);
    
    font = [UIFont boldSystemFontOfSize:28.0f];
    
    label = [[InsetsLabel alloc]initWithFrame:labelRect andInsets:edge];
    
    label.font = font;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor whiteColor];
    label.text = @"1.70m";
    label.tag = 40;
    label.layer.borderWidth = 3.0f;
    label.layer.borderColor = [UIColor blackColor].CGColor;
    [self.view addSubview:label];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
}
@end
