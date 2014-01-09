//
//  SettingViewController.m
//  PMCExhibitionTable
//
//  Created by Shawn on 14-1-8.
//  Copyright (c) 2014年 com.nathan. All rights reserved.
//

#import "SettingViewController.h"
#import "InsetsLabel.h"
#import "TACSettingManager.h"

#define MOTOR_COUNT 7

#define BASE_TAG_FOR_MAX_SPEED_SETTING_LABEL 300
#define BASE_TAG_FOR_MAX_SPEED_SETTING_UP_BUTTON 330
#define BASE_TAG_FOR_MAX_SPEED_SETTING_DOWN_BUTTON 360

#define BASE_TAG_FOR_DEFAULT_SPEED_SETTING_LABEL 400
#define BASE_TAG_FOR_DEFAULT_SPEED_SETTING_UP_BUTTON 430
#define BASE_TAG_FOR_DEFAULT_SPEED_SETTING_DOWN_BUTTON 460

#define TAG_FOR_DEMO_MODE_TIME 500
#define TAG_FOR_HEIGHT 600

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
    
    [self addSettingLabelsAndButtons];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // TODO: 使用TACSettingManager读取数据用于更新各个控件
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action

// TODO: Button点击动作，改变label数值，还需要增加Press动作，快速改变数值

- (void)upButtonInMaxSpeedSettingClicked:(UIButton *)sender
{
    NSLog(@"up max");
}

- (void)downButtonInMaxSpeedSettingClicked:(UIButton *)sender
{
    NSLog(@"down max");
}

- (void)upButtonInDefaultSpeedSettingClicked:(UIButton *)sender
{
    NSLog(@"up default");
}

- (void)downButtonInDefaultSpeedSettingClicked:(UIButton *)sender
{
    NSLog(@"down default");
}

- (void)upButtonOfDemoModeClicked:(UIButton *)sender
{
    NSLog(@"up demo");
}

- (void)downButtonOfDemoModeClicked:(UIButton *)sender
{
    NSLog(@"down demo");
}

- (void)upButtonOfHeightClicked:(UIButton *)sender
{
    NSLog(@"up height");
}

- (void)downButtonOfHeightClicked:(UIButton *)sender
{
    NSLog(@"down height");
}

- (IBAction)close:(id)sender
{    
    InsetsLabel *label = nil;
    
    // Max speed
    for (int i = 1; i <= MOTOR_COUNT; ++i) {
        label = (InsetsLabel *)[self.view viewWithTag:BASE_TAG_FOR_MAX_SPEED_SETTING_LABEL + i];
        NSUInteger value = [label.text integerValue];
        [[TACSettingManager sharedManager] setMaxSpeedforMotor:i
                                                     withSpeed:value];
    }
    
    // Default speed
    for (int i = 1; i < MOTOR_COUNT; ++i) {
        label = (InsetsLabel *)[self.view viewWithTag:BASE_TAG_FOR_DEFAULT_SPEED_SETTING_LABEL + i];
        NSUInteger value = [label.text integerValue];
        [[TACSettingManager sharedManager] setDefaultSpeedforMotor:i
                                                         withSpeed:value];
    }
    
    // Time
    label = (InsetsLabel *)[self.view viewWithTag:TAG_FOR_DEMO_MODE_TIME];
    NSUInteger time = [label.text integerValue];
    [[TACSettingManager sharedManager] setDemoModeTime:time];
    
    // Height
    label = (InsetsLabel *)[self.view viewWithTag:TAG_FOR_HEIGHT];
    NSUInteger height = [label.text integerValue];
    [[TACSettingManager sharedManager] setHeight:height];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Helper Methods

- (void)addSettingLabelsAndButtons
{
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
    for (NSInteger i = 1; i <= MOTOR_COUNT; i++) {
        
        labelRect = CGRectMake(x, y + i * difference, width, height);
        
        label = [[InsetsLabel alloc]initWithFrame:labelRect andInsets:edge];
        
        label.font = font;
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor whiteColor];
        label.text = @"1200rmp";
        label.layer.borderWidth = 3.0f;
        label.layer.borderColor = [UIColor blackColor].CGColor;
        label.tag = BASE_TAG_FOR_MAX_SPEED_SETTING_LABEL + i;
        [self.view addSubview:label];
        
        upButtonRect = CGRectMake(x + width- 25, y + 5 + i* difference, 20, 20);
        upButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [upButton setFrame:upButtonRect];
        [upButton setBackgroundImage:[UIImage imageNamed:@"setUp"] forState:UIControlStateNormal];
        upButton.tag = BASE_TAG_FOR_MAX_SPEED_SETTING_UP_BUTTON + i;
        [upButton addTarget:self
                     action:@selector(upButtonInMaxSpeedSettingClicked:)
           forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:upButton];
        
        downButtonRect = CGRectMake(x + width- 25, y + 30 + i* difference, 20, 20);
        downButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [downButton setFrame:downButtonRect];
        [downButton setBackgroundImage:[UIImage imageNamed:@"setDown"] forState:UIControlStateNormal];
        downButton.tag = BASE_TAG_FOR_MAX_SPEED_SETTING_DOWN_BUTTON + i;
        [downButton addTarget:self
                       action:@selector(downButtonInMaxSpeedSettingClicked:)
             forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:downButton];
    }
    
    //Default Speed Settings
    x = 792;
    for (NSInteger i = 1; i < MOTOR_COUNT; i++) {
        
        labelRect = CGRectMake(x, y + i * difference, width, height);
        
        font = [UIFont boldSystemFontOfSize:28.0f];
        
        label = [[InsetsLabel alloc]initWithFrame:labelRect andInsets:edge];
        
        label.font = font;
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor whiteColor];
        label.text = @"1200rmp";
        label.layer.borderWidth = 3.0f;
        label.layer.borderColor = [UIColor blackColor].CGColor;
        label.tag = BASE_TAG_FOR_DEFAULT_SPEED_SETTING_LABEL + i;
        [self.view addSubview:label];
        
        upButtonRect = CGRectMake(x + width- 25, y + 5 + i* difference, 20, 20);
        upButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [upButton setFrame:upButtonRect];
        [upButton setBackgroundImage:[UIImage imageNamed:@"setUp"] forState:UIControlStateNormal];
        upButton.tag = BASE_TAG_FOR_DEFAULT_SPEED_SETTING_UP_BUTTON + i;
        [upButton addTarget:self
                     action:@selector(upButtonInDefaultSpeedSettingClicked:)
           forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:upButton];
        
        downButtonRect = CGRectMake(x + width- 25, y + 30 + i* difference, 20, 20);
        downButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [downButton setFrame:downButtonRect];
        [downButton setBackgroundImage:[UIImage imageNamed:@"setDown"] forState:UIControlStateNormal];
        downButton.tag = BASE_TAG_FOR_DEFAULT_SPEED_SETTING_DOWN_BUTTON + i;
        [downButton addTarget:self
                       action:@selector(downButtonInDefaultSpeedSettingClicked:)
             forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:downButton];
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
    label.layer.borderWidth = 3.0f;
    label.layer.borderColor = [UIColor blackColor].CGColor;
    label.tag = TAG_FOR_DEMO_MODE_TIME;
    [self.view addSubview:label];
    
    upButtonRect = CGRectMake(x + width- 25, y + 5 , 20, 20);
    upButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [upButton setFrame:upButtonRect];
    [upButton setBackgroundImage:[UIImage imageNamed:@"setUp"] forState:UIControlStateNormal];
    [upButton addTarget:self
                 action:@selector(upButtonOfDemoModeClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:upButton];
    
    downButtonRect = CGRectMake(x + width- 25, y + 30 , 20, 20);
    downButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [downButton setFrame:downButtonRect];
    [downButton setBackgroundImage:[UIImage imageNamed:@"setDown"] forState:UIControlStateNormal];
    [downButton addTarget:self
                   action:@selector(downButtonOfDemoModeClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downButton];
    
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
    label.layer.borderWidth = 3.0f;
    label.layer.borderColor = [UIColor blackColor].CGColor;
    label.tag = TAG_FOR_HEIGHT;
    [self.view addSubview:label];
    
    upButtonRect = CGRectMake(x + width- 25, y + 5 , 20, 20);
    upButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [upButton setFrame:upButtonRect];
    [upButton setBackgroundImage:[UIImage imageNamed:@"setUp"] forState:UIControlStateNormal];
    [upButton addTarget:self
                 action:@selector(upButtonOfHeightClicked:)
       forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:upButton];
    
    downButtonRect = CGRectMake(x + width- 25, y + 30 , 20, 20);
    downButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [downButton setFrame:downButtonRect];
    [downButton setBackgroundImage:[UIImage imageNamed:@"setDown"] forState:UIControlStateNormal];
    [downButton addTarget:self
                   action:@selector(downButtonOfHeightClicked:)
         forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:downButton];
}

@end
