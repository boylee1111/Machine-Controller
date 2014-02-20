//
//  SettingViewController.m
//  PMCExhibitionTable
//
//  Created by Shawn on 14-1-8.
//  Copyright (c) 2014年 com.nathan. All rights reserved.
//

#import "SettingViewController.h"
#import "TACSettingManager.h"
#import "InsetsLabel.h"

#define BASE_TAG_FOR_MAX_SPEED_SETTING_LABEL 300
#define BASE_TAG_FOR_MAX_SPEED_SETTING_UP_BUTTON 330
#define BASE_TAG_FOR_MAX_SPEED_SETTING_DOWN_BUTTON 360

#define BASE_TAG_FOR_DEFAULT_SPEED_SETTING_LABEL 400
#define BASE_TAG_FOR_DEFAULT_SPEED_SETTING_UP_BUTTON 430
#define BASE_TAG_FOR_DEFAULT_SPEED_SETTING_DOWN_BUTTON 460

#define TAG_FOR_DEMO_MODE_TIME_LABEL 500
#define TAG_FOR_DEMO_MODE_TIME_UP_BUTTON 530
#define TAG_FOR_DEMO_MODE_TIME_DOWN_BUTTON 560

#define TAG_FOR_HEIGHT_LABEL 600
#define TAG_FOR_HEIGHT_UP_BUTTON 630
#define TAG_FOR_HEIGHT_DOWN_BUTTON 660

#define BACK_TO_MAIN_TIME_INTERVAL 60

#define MINIMUM_PRESS_DURATION 0.5
#define LONG_PRESS_VALUE_CHANGE_INTERVAL 0.1

@interface SettingViewController () {
    NSTimer *backTimer;
    NSInteger unTouchedTime;
    CGPoint touchPoint;
    CGPoint lastTouchPoint;
    BOOL isCounting; // Long pressed or not
    NSUInteger valueChangeRate; // Record rate when long press
}

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
    
//    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(resetTimer)];
//    longPress.minimumPressDuration = 0;
//    [self.view addGestureRecognizer:longPress];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self updateLabelsAndButtonStatus];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    unTouchedTime = 0;
    backTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                 target:self
                                               selector:@selector(checkWhetherTouched)
                                               userInfo:nil
                                                repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [backTimer invalidate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action

//- (void)upButtonInMaxSpeedSettingClicked:(UIButton *)sender
//{
//    NSUInteger num = sender.tag - BASE_TAG_FOR_MAX_SPEED_SETTING_UP_BUTTON;
//    InsetsLabel *label = (InsetsLabel *)[self.view viewWithTag:BASE_TAG_FOR_MAX_SPEED_SETTING_LABEL + num];
//    NSUInteger value = [label.text integerValue];
//    label.text = [NSString stringWithFormat:@"%ld%@", ++value, @"rpm"];
//    
//    if (value == MAX_SPEED) sender.enabled = NO;
//    UIButton *downButton = (UIButton *)[self.view viewWithTag:BASE_TAG_FOR_MAX_SPEED_SETTING_DOWN_BUTTON + num];
//    downButton.enabled = YES;
//    UIButton *defaultUpButton = (UIButton *)[self.view viewWithTag:BASE_TAG_FOR_DEFAULT_SPEED_SETTING_UP_BUTTON + num];
//    defaultUpButton.enabled = YES;
//}
//
//- (void)downButtonInMaxSpeedSettingClicked:(UIButton *)sender
//{
//    NSUInteger num = sender.tag - BASE_TAG_FOR_MAX_SPEED_SETTING_DOWN_BUTTON;
//    InsetsLabel *label = (InsetsLabel *)[self.view viewWithTag:BASE_TAG_FOR_MAX_SPEED_SETTING_LABEL + num];
//    NSUInteger value = [label.text integerValue];
//    label.text = [NSString stringWithFormat:@"%ld%@", --value, @"rpm"];
//    
//    InsetsLabel *defaultLabel = (InsetsLabel *)[self.view viewWithTag:BASE_TAG_FOR_DEFAULT_SPEED_SETTING_LABEL + num];
//    NSUInteger defaultValue = [defaultLabel.text integerValue];
//    if (defaultValue > value) {
//        defaultLabel.text = [NSString stringWithFormat:@"%ld%@", value, @"rpm"];
//        UIButton *defaultUpButton = (UIButton *)[self.view viewWithTag:BASE_TAG_FOR_DEFAULT_SPEED_SETTING_UP_BUTTON + num];
//        defaultUpButton.enabled = NO;
//    }
//    
//    if (value == MIN_SPEED_FOR_MAX_SPEED) sender.enabled = NO;
//    UIButton *upButton = (UIButton *)[self.view viewWithTag:BASE_TAG_FOR_MAX_SPEED_SETTING_UP_BUTTON + num];
//    upButton.enabled = YES;
//}
//
//- (void)upButtonInDefaultSpeedSettingClicked:(UIButton *)sender
//{
//    NSUInteger num = sender.tag - BASE_TAG_FOR_DEFAULT_SPEED_SETTING_UP_BUTTON;
//    InsetsLabel *maxLabel = (InsetsLabel *)[self.view viewWithTag:BASE_TAG_FOR_MAX_SPEED_SETTING_LABEL + num];
//    NSUInteger maxValue = [maxLabel.text integerValue];
//    InsetsLabel *label = (InsetsLabel *)[self.view viewWithTag:BASE_TAG_FOR_DEFAULT_SPEED_SETTING_LABEL + num];
//    NSUInteger value = [label.text integerValue];
//    
//    if (value == MIN_SPEED) value = LIMIT_SPEED;
//    else value++;
//    label.text = [NSString stringWithFormat:@"%ld%@", value, @"rpm"];
//    
//    if (value == maxValue) sender.enabled = NO;
//    UIButton *downButton = (UIButton *)[self.view viewWithTag:BASE_TAG_FOR_DEFAULT_SPEED_SETTING_DOWN_BUTTON + num];
//    downButton.enabled = YES;
//}
//
//- (void)downButtonInDefaultSpeedSettingClicked:(UIButton *)sender
//{
//    NSUInteger num = sender.tag - BASE_TAG_FOR_DEFAULT_SPEED_SETTING_DOWN_BUTTON;
//    InsetsLabel *label = (InsetsLabel *)[self.view viewWithTag:BASE_TAG_FOR_DEFAULT_SPEED_SETTING_LABEL + num];
//    NSUInteger value = [label.text integerValue];
//    
//    if (value == LIMIT_SPEED) {
//        value = MIN_SPEED;
//        sender.enabled = NO;
//    } else {
//        value--;
//    }
//    label.text = [NSString stringWithFormat:@"%ld%@", value, @"rpm"];
//    UIButton *upButton = (UIButton *)[self.view viewWithTag:BASE_TAG_FOR_DEFAULT_SPEED_SETTING_UP_BUTTON + num];
//    upButton.enabled = YES;
//}
//
//- (void)upButtonOfDemoModeClicked:(UIButton *)sender
//{
//    InsetsLabel *label = (InsetsLabel *)[self.view viewWithTag:TAG_FOR_DEMO_MODE_TIME_LABEL];
//    NSUInteger value = [self getSecondsFromFormatTime:label.text];
//    label.text = [self getFormatTimeFromSeconds:++value];
//    
//    if (value == MAX_DEMO_MODE_TIME) sender.enabled = NO;
//    UIButton *downButton = (UIButton *)[self.view viewWithTag:TAG_FOR_DEMO_MODE_TIME_DOWN_BUTTON];
//    downButton.enabled = YES;
//}
//
//- (void)downButtonOfDemoModeClicked:(UIButton *)sender
//{
//    InsetsLabel *label = (InsetsLabel *)[self.view viewWithTag:TAG_FOR_DEMO_MODE_TIME_LABEL];
//    NSUInteger value = [self getSecondsFromFormatTime:label.text];
//    label.text = [self getFormatTimeFromSeconds:--value];
//    
//    if (value == MIN_DEMO_MODE_TIME) sender.enabled = NO;
//    UIButton *upButton = (UIButton *)[self.view viewWithTag:TAG_FOR_DEMO_MODE_TIME_UP_BUTTON];
//    upButton.enabled = YES;
//}
//
//- (void)upButtonOfHeightClicked:(UIButton *)sender
//{
//    InsetsLabel *label = (InsetsLabel *)[self.view viewWithTag:TAG_FOR_HEIGHT_LABEL];
//    NSUInteger value = [label.text floatValue] * 100;
//    label.text = [NSString stringWithFormat:@"%.2f%@", ++value / 100.0, @" m"];
//    
//    if (value == MAX_HEIGHT) sender.enabled = NO;
//    UIButton *downButton = (UIButton *)[self.view viewWithTag:TAG_FOR_HEIGHT_DOWN_BUTTON];
//    downButton.enabled = YES;
//}
//
//- (void)downButtonOfHeightClicked:(UIButton *)sender
//{
//    InsetsLabel *label = (InsetsLabel *)[self.view viewWithTag:TAG_FOR_HEIGHT_LABEL];
//    NSUInteger value = [label.text floatValue] * 100;
//    label.text = [NSString stringWithFormat:@"%.2f%@", --value / 100.0, @" m"];
//    
//    if (value == MIN_HEIGHT) sender.enabled = NO;
//    UIButton *upButton = (UIButton *)[self.view viewWithTag:TAG_FOR_HEIGHT_UP_BUTTON];
//    upButton.enabled = YES;
//}

- (IBAction)close:(id)sender
{
    [self saveDataToUserDefault];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Selectors

#pragma mark Long Press Gesture Selectors

//- (void)upButtonInMaxSpeedSettingLongPressed:(UILongPressGestureRecognizer *)sender
//{
//    valueChangeRate = 0;
//    if (isCounting) return;
//    
//    isCounting = YES;
//    [NSTimer scheduledTimerWithTimeInterval:LONG_PRESS_VALUE_CHANGE_INTERVAL
//                                     target:self
//                                   selector:@selector(increaseMaxSpeed:)
//                                   userInfo:sender
//                                    repeats:YES];
//}
//
//- (void)downButtonInMaxSpeedSettingLongPressed:(UILongPressGestureRecognizer *)sender
//{
//    valueChangeRate = 0;
//    if (isCounting) return;
//    
//    isCounting = YES;
//    [NSTimer scheduledTimerWithTimeInterval:LONG_PRESS_VALUE_CHANGE_INTERVAL
//                                     target:self
//                                   selector:@selector(decreaseMaxSpeed:)
//                                   userInfo:sender
//                                    repeats:YES];
//}
//
//- (void)upButtonInDefaultSpeedSettingLongPressed:(UILongPressGestureRecognizer *)sender
//{
//    valueChangeRate = 0;
//    if (isCounting) return;
//    
//    isCounting = YES;
//    [NSTimer scheduledTimerWithTimeInterval:LONG_PRESS_VALUE_CHANGE_INTERVAL
//                                     target:self
//                                   selector:@selector(increaseDefaultSpeed:)
//                                   userInfo:sender
//                                    repeats:YES];
//}
//
//- (void)downButtonInDefaultSpeedSettingLongPressed:(UILongPressGestureRecognizer *)sender
//{
//    valueChangeRate = 0;
//    if (isCounting) return;
//    
//    isCounting = YES;
//    [NSTimer scheduledTimerWithTimeInterval:LONG_PRESS_VALUE_CHANGE_INTERVAL
//                                     target:self
//                                   selector:@selector(decreaseDefaultSpeed:)
//                                   userInfo:sender
//                                    repeats:YES];
//}
//
//- (void)upButtonOfDemoModeLongPressed:(UILongPressGestureRecognizer *)sender
//{
//    valueChangeRate = 0;
//    if (isCounting) return;
//    
//    isCounting = YES;
//    [NSTimer scheduledTimerWithTimeInterval:LONG_PRESS_VALUE_CHANGE_INTERVAL
//                                     target:self
//                                   selector:@selector(increaseDemoModeTime:)
//                                   userInfo:sender
//                                    repeats:YES];
//}
//
//- (void)downButtonOfDemoModeLongPressed:(UILongPressGestureRecognizer *)sender
//{
//    valueChangeRate = 0;
//    if (isCounting) return;
//    
//    isCounting = YES;
//    [NSTimer scheduledTimerWithTimeInterval:LONG_PRESS_VALUE_CHANGE_INTERVAL
//                                     target:self
//                                   selector:@selector(decreaseDemoModeTime:)
//                                   userInfo:sender
//                                    repeats:YES];
//}
//
//- (void)upButtonOfHeightLongPressed:(UILongPressGestureRecognizer *)sender
//{
//    valueChangeRate = 0;
//    if (isCounting) return;
//    
//    isCounting = YES;
//    [NSTimer scheduledTimerWithTimeInterval:LONG_PRESS_VALUE_CHANGE_INTERVAL
//                                     target:self
//                                   selector:@selector(increaseHeight:)
//                                   userInfo:sender
//                                    repeats:YES];
//}
//
//- (void)downButtonOfHeightLongPressed:(UILongPressGestureRecognizer *)sender
//{
//    valueChangeRate = 0;
//    if (isCounting) return;
//    
//    isCounting = YES;
//    [NSTimer scheduledTimerWithTimeInterval:LONG_PRESS_VALUE_CHANGE_INTERVAL
//                                     target:self
//                                   selector:@selector(decreaseHeight:)
//                                   userInfo:sender
//                                    repeats:YES];
//}

#pragma mark Timer Selectors

- (void)increaseMaxSpeed:(NSTimer *)timer
{
    UILongPressGestureRecognizer *gesture = [timer userInfo];
    if (gesture.state != UIGestureRecognizerStateBegan && gesture.state != UIGestureRecognizerStateChanged) {
        [timer invalidate];
        isCounting = NO;
        return;
    }
    
    UIButton *upButton = (UIButton *)gesture.view;
    NSUInteger num = upButton.tag - BASE_TAG_FOR_MAX_SPEED_SETTING_UP_BUTTON;
    
    valueChangeRate++;
    InsetsLabel *label = (InsetsLabel *)[self.view viewWithTag:BASE_TAG_FOR_MAX_SPEED_SETTING_LABEL + num];
    NSInteger value = [label.text integerValue];
    value += valueChangeRate;
    value = (value > MAX_SPEED ? MAX_SPEED : value);
    label.text = [NSString stringWithFormat:@"%ld%@", value, @"rpm"];
    
    if (value == MAX_SPEED) upButton.enabled = NO;
    UIButton *downButton = (UIButton *)[self.view viewWithTag:BASE_TAG_FOR_MAX_SPEED_SETTING_DOWN_BUTTON + num];
    downButton.enabled = YES;
    UIButton *defaultUpButton = (UIButton *)[self.view viewWithTag:BASE_TAG_FOR_DEFAULT_SPEED_SETTING_UP_BUTTON + num];
    defaultUpButton.enabled = YES;
}

- (void)decreaseMaxSpeed:(NSTimer *)timer
{
    UILongPressGestureRecognizer *gesture = [timer userInfo];
    if (gesture.state != UIGestureRecognizerStateBegan && gesture.state != UIGestureRecognizerStateChanged) {
        [timer invalidate];
        isCounting = NO;
        return;
    }
    
    UIButton *downButton = (UIButton *)gesture.view;
    NSUInteger num = downButton.tag - BASE_TAG_FOR_MAX_SPEED_SETTING_DOWN_BUTTON;
    
    valueChangeRate++;
    InsetsLabel *label = (InsetsLabel *)[self.view viewWithTag:BASE_TAG_FOR_MAX_SPEED_SETTING_LABEL + num];
    NSInteger value = [label.text integerValue];
    value -= valueChangeRate;
    value = (value < MIN_SPEED_FOR_MAX_SPEED ? MIN_SPEED_FOR_MAX_SPEED : value);
    label.text = [NSString stringWithFormat:@"%ld%@", value, @"rpm"];
    
    InsetsLabel *defaultLabel = (InsetsLabel *)[self.view viewWithTag:BASE_TAG_FOR_DEFAULT_SPEED_SETTING_LABEL + num];
    NSInteger defaultValue = [defaultLabel.text integerValue];
    if (defaultValue > value) {
        defaultLabel.text = [NSString stringWithFormat:@"%ld%@", value, @"rpm"];
        UIButton *defaultUpButton = (UIButton *)[self.view viewWithTag:BASE_TAG_FOR_DEFAULT_SPEED_SETTING_UP_BUTTON + num];
        defaultUpButton.enabled = NO;
    }
    
    if (value == MIN_SPEED_FOR_MAX_SPEED) downButton.enabled = NO;
    UIButton *upButton = (UIButton *)[self.view viewWithTag:BASE_TAG_FOR_MAX_SPEED_SETTING_UP_BUTTON + num];
    upButton.enabled = YES;
}

- (void)increaseDefaultSpeed:(NSTimer *)timer
{
    UILongPressGestureRecognizer *gesture = [timer userInfo];
    if (gesture.state != UIGestureRecognizerStateBegan && gesture.state != UIGestureRecognizerStateChanged) {
        [timer invalidate];
        isCounting = NO;
        return;
    }
    
    UIButton *upButton = (UIButton *)gesture.view;
    NSUInteger num = upButton.tag - BASE_TAG_FOR_DEFAULT_SPEED_SETTING_UP_BUTTON;
    
    valueChangeRate++;
    InsetsLabel *maxLabel = (InsetsLabel *)[self.view viewWithTag:BASE_TAG_FOR_MAX_SPEED_SETTING_LABEL + num];
    NSInteger maxValue = [maxLabel.text integerValue];
    InsetsLabel *label = (InsetsLabel *)[self.view viewWithTag:BASE_TAG_FOR_DEFAULT_SPEED_SETTING_LABEL + num];
    NSInteger value = [label.text integerValue];
    
    if (value == MIN_SPEED) value = LIMIT_SPEED;
    else value += valueChangeRate;
    value = (value > maxValue ? maxValue : value);
    label.text = [NSString stringWithFormat:@"%ld%@", value, @"rpm"];
    
    if (value == maxValue) upButton.enabled = NO;
    UIButton *downButton = (UIButton *)[self.view viewWithTag:BASE_TAG_FOR_DEFAULT_SPEED_SETTING_DOWN_BUTTON + num];
    downButton.enabled = YES;
}

- (void)decreaseDefaultSpeed:(NSTimer *)timer
{
    UILongPressGestureRecognizer *gesture = [timer userInfo];
    if (gesture.state != UIGestureRecognizerStateBegan && gesture.state != UIGestureRecognizerStateChanged) {
        [timer invalidate];
        isCounting = NO;
        return;
    }
    
    UIButton *downButton = (UIButton *)gesture.view;
    NSUInteger num = downButton.tag - BASE_TAG_FOR_DEFAULT_SPEED_SETTING_DOWN_BUTTON;
    
    valueChangeRate++;
    InsetsLabel *label = (InsetsLabel *)[self.view viewWithTag:BASE_TAG_FOR_DEFAULT_SPEED_SETTING_LABEL + num];
    NSInteger value = [label.text integerValue];
    
    if (value == LIMIT_SPEED) value = MIN_SPEED;
    else value -= valueChangeRate;
    value = (value < MIN_SPEED ? MIN_SPEED : value);
    label.text = [NSString stringWithFormat:@"%ld%@", value, @"rpm"];
    
    if (value == MIN_SPEED) downButton.enabled = NO;
    UIButton *upButton = (UIButton *)[self.view viewWithTag:BASE_TAG_FOR_DEFAULT_SPEED_SETTING_UP_BUTTON + num];
    upButton.enabled = YES;
}

- (void)increaseDemoModeTime:(NSTimer *)timer
{
    UILongPressGestureRecognizer *gesture = [timer userInfo];
    if (gesture.state != UIGestureRecognizerStateBegan && gesture.state != UIGestureRecognizerStateChanged) {
        [timer invalidate];
        isCounting = NO;
        return;
    }
    
    valueChangeRate++;
    InsetsLabel *label = (InsetsLabel *)[self.view viewWithTag:TAG_FOR_DEMO_MODE_TIME_LABEL];
    NSInteger value = [self getSecondsFromFormatTime:label.text];
    value += valueChangeRate;
    value = (value > MAX_DEMO_MODE_TIME ? MAX_DEMO_MODE_TIME : value);
    label.text = [self getFormatTimeFromSeconds:value];
    
    UIButton *upButton = (UIButton *)gesture.view;
    UIButton *downButton = (UIButton *)[self.view viewWithTag:TAG_FOR_DEMO_MODE_TIME_DOWN_BUTTON];
    
    if (value == MAX_DEMO_MODE_TIME) upButton.enabled = NO;
    downButton.enabled = YES;
}

- (void)decreaseDemoModeTime:(NSTimer *)timer
{
    UILongPressGestureRecognizer *gesture = [timer userInfo];
    if (gesture.state != UIGestureRecognizerStateBegan && gesture.state != UIGestureRecognizerStateChanged) {
        [timer invalidate];
        isCounting = NO;
        return;
    }
    
    valueChangeRate++;
    InsetsLabel *label = (InsetsLabel *)[self.view viewWithTag:TAG_FOR_DEMO_MODE_TIME_LABEL];
    NSInteger value = [self getSecondsFromFormatTime:label.text];
    value -= valueChangeRate;
    value = (value < MIN_DEMO_MODE_TIME ? MIN_DEMO_MODE_TIME : value);
    label.text = [self getFormatTimeFromSeconds:value];
    
    UIButton *downButton = (UIButton *)gesture.view;
    UIButton *upButton = (UIButton *)[self.view viewWithTag:TAG_FOR_DEMO_MODE_TIME_UP_BUTTON];
    
    if (value == MIN_DEMO_MODE_TIME) downButton.enabled = NO;
    upButton.enabled = YES;
}

- (void)increaseHeight:(NSTimer *)timer
{
    UILongPressGestureRecognizer *gesture = [timer userInfo];
    if (gesture.state != UIGestureRecognizerStateBegan && gesture.state != UIGestureRecognizerStateChanged) {
        [timer invalidate];
        isCounting = NO;
        return;
    }
    
    valueChangeRate++;
    InsetsLabel *label = (InsetsLabel *)[self.view viewWithTag:TAG_FOR_HEIGHT_LABEL];
    NSInteger value = [label.text floatValue] * 100;
    value += valueChangeRate;
    value = (value > MAX_HEIGHT ? MAX_HEIGHT : value);
    label.text = [NSString stringWithFormat:@"%.2f%@", value / 100.0, @"m"];
    
    UIButton *upButton = (UIButton *)gesture.view;
    UIButton *downButton = (UIButton *)[self.view viewWithTag:TAG_FOR_HEIGHT_DOWN_BUTTON];
    
    if (value == MAX_HEIGHT) upButton.enabled = NO;
    downButton.enabled = YES;
}

- (void)decreaseHeight:(NSTimer *)timer
{
    UILongPressGestureRecognizer *gesture = [timer userInfo];
    if (gesture.state != UIGestureRecognizerStateBegan && gesture.state != UIGestureRecognizerStateChanged) {
        [timer invalidate];
        isCounting = NO;
        return;
    }
    
    valueChangeRate++;
    InsetsLabel *label = (InsetsLabel *)[self.view viewWithTag:TAG_FOR_HEIGHT_LABEL];
    NSInteger value = [label.text floatValue] * 100;
    value -= valueChangeRate;
    value = (value < MIN_HEIGHT ? MIN_HEIGHT : value);
    label.text = [NSString stringWithFormat:@"%.2f%@", value / 100.0, @"m"];
    
    UIButton *downButton = (UIButton *)gesture.view;
    UIButton *upButton = (UIButton *)[self.view viewWithTag:TAG_FOR_HEIGHT_UP_BUTTON];
    
    if (value == MIN_HEIGHT) downButton.enabled = NO;
    upButton.enabled = YES;
}

//Back automatically
-(void)checkWhetherTouched{
    
    if (CGPointEqualToPoint(touchPoint, lastTouchPoint) ) {
        unTouchedTime++;
    }
    else{
        unTouchedTime = 0;
        [self resetTimer];
    }
    if (unTouchedTime == BACK_TO_MAIN_TIME_INTERVAL) {
        [self backViaTiming];
    }
    lastTouchPoint = touchPoint;
    NSLog(@"%d",unTouchedTime);

    
}
- (void)resetTimer
{
    [backTimer invalidate];
    backTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                 target:self
                                               selector:@selector(checkWhetherTouched)
                                               userInfo:nil
                                                repeats:YES];
}

- (void)backViaTiming
{
    [self saveDataToUserDefault];
    
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
    MaxSpeedBar.layer.cornerRadius = 40.0f;
    
    DemoModeBar.layer.borderWidth = 3.0f;
    DemoModeBar.layer.borderColor = [UIColor darkGrayColor].CGColor;
    DemoModeBar.layer.cornerRadius = 40.0f;
    
    DefaultSpeedBar.layer.borderWidth = 3.0f;
    DefaultSpeedBar.layer.borderColor = [UIColor darkGrayColor].CGColor;
    DefaultSpeedBar.layer.cornerRadius = 40.0f;
    
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
        
        labelRect = CGRectMake(x, y + (i - 1) * difference, width, height);
        
        label = [[InsetsLabel alloc]initWithFrame:labelRect andInsets:edge];
        
        label.font = font;
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor whiteColor];
        label.text = @"1200rmp";
        label.layer.borderWidth = 3.0f;
        label.layer.borderColor = [UIColor blackColor].CGColor;
        label.tag = BASE_TAG_FOR_MAX_SPEED_SETTING_LABEL + i;
        [self.view addSubview:label];
        
//        upButtonRect = CGRectMake(x + width- 25, y + 5 + (i - 1) * difference, 20, 20);
//        upButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        [upButton setFrame:upButtonRect];
//        [upButton setBackgroundImage:[UIImage imageNamed:@"setUp"] forState:UIControlStateNormal];
//        [upButton setBackgroundImage:[UIImage imageNamed:@"setUp_disable"] forState:UIControlStateDisabled];
//        upButton.tag = BASE_TAG_FOR_MAX_SPEED_SETTING_UP_BUTTON + i;
//        UILongPressGestureRecognizer *upInMaxLongPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(upButtonInMaxSpeedSettingLongPressed:)];
//        [upInMaxLongPressGesture setMinimumPressDuration:MINIMUM_PRESS_DURATION];
//        [upButton addGestureRecognizer:upInMaxLongPressGesture];
//        [upButton addTarget:self
//                     action:@selector(upButtonInMaxSpeedSettingClicked:)
//           forControlEvents:UIControlEventTouchDown];
//        [self.view addSubview:upButton];
//        
//        downButtonRect = CGRectMake(x + width- 25, y + 30 + (i - 1) * difference, 20, 20);
//        downButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        [downButton setFrame:downButtonRect];
//        [downButton setBackgroundImage:[UIImage imageNamed:@"setDown"] forState:UIControlStateNormal];
//        [downButton setBackgroundImage:[UIImage imageNamed:@"setDown_disable"] forState:UIControlStateDisabled];
//        downButton.tag = BASE_TAG_FOR_MAX_SPEED_SETTING_DOWN_BUTTON + i;
//        UILongPressGestureRecognizer *downInMaxLongPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(downButtonInMaxSpeedSettingLongPressed:)];
//        [downInMaxLongPressGesture setMinimumPressDuration:MINIMUM_PRESS_DURATION];
//        [downButton addGestureRecognizer:downInMaxLongPressGesture];
//        [downButton addTarget:self
//                       action:@selector(downButtonInMaxSpeedSettingClicked:)
//             forControlEvents:UIControlEventTouchDown];
//        [self.view addSubview:downButton];
//        
//        [upButton addTarget:self action:@selector(touchesBegan:withEvent:) forControlEvents:UIControlEventAllEvents];
//        [downButton addTarget:self action:@selector(touchesBegan:withEvent:) forControlEvents:UIControlEventAllEvents];
    }
    
    //Default Speed Settings
    x = 792;
    for (NSInteger i = 1; i <= MOTOR_COUNT; i++) {
        
        labelRect = CGRectMake(x, y + (i - 1) * difference, width, height);
        
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
        
//        upButtonRect = CGRectMake(x + width- 25, y + 5 + (i - 1) * difference, 20, 20);
//        upButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        [upButton setFrame:upButtonRect];
//        [upButton setBackgroundImage:[UIImage imageNamed:@"setUp"] forState:UIControlStateNormal];
//        [upButton setBackgroundImage:[UIImage imageNamed:@"setUp_disable"] forState:UIControlStateDisabled];
//        upButton.tag = BASE_TAG_FOR_DEFAULT_SPEED_SETTING_UP_BUTTON + i;
//        UILongPressGestureRecognizer *upInDefaultLongPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(upButtonInDefaultSpeedSettingLongPressed:)];
//        [upInDefaultLongPressGesture setMinimumPressDuration:MINIMUM_PRESS_DURATION];
//        [upButton addGestureRecognizer:upInDefaultLongPressGesture];
//        [upButton addTarget:self
//                     action:@selector(upButtonInDefaultSpeedSettingClicked:)
//           forControlEvents:UIControlEventTouchDown];
//        [self.view addSubview:upButton];
//        
//        downButtonRect = CGRectMake(x + width- 25, y + 30 + (i - 1) * difference, 20, 20);
//        downButton = [UIButton buttonWithType:UIButtonTypeSystem];
//        [downButton setFrame:downButtonRect];
//        [downButton setBackgroundImage:[UIImage imageNamed:@"setDown"] forState:UIControlStateNormal];
//        [downButton setBackgroundImage:[UIImage imageNamed:@"setDown_disable"] forState:UIControlStateDisabled];
//        downButton.tag = BASE_TAG_FOR_DEFAULT_SPEED_SETTING_DOWN_BUTTON + i;
//        UILongPressGestureRecognizer *downDefaultLongPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(downButtonInDefaultSpeedSettingLongPressed:)];
//        [downDefaultLongPressGesture setMinimumPressDuration:MINIMUM_PRESS_DURATION];
//        [downButton addGestureRecognizer:downDefaultLongPressGesture];
//        [downButton addTarget:self
//                       action:@selector(downButtonInDefaultSpeedSettingClicked:)
//             forControlEvents:UIControlEventTouchDown];
//        [self.view addSubview:downButton];
//        [upButton addTarget:self action:@selector(touchesBegan:withEvent:) forControlEvents:UIControlEventAllEvents];
//        [downButton addTarget:self action:@selector(touchesBegan:withEvent:) forControlEvents:UIControlEventAllEvents];
    }
    
    //Time
    x = 458.0f;
    y = 246.0f;
    width = 170.0f;
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
    label.tag = TAG_FOR_DEMO_MODE_TIME_LABEL;
    [self.view addSubview:label];
    
//    upButtonRect = CGRectMake(x + width- 25, y + 5 , 20, 20);
//    upButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [upButton setFrame:upButtonRect];
//    [upButton setBackgroundImage:[UIImage imageNamed:@"setUp"] forState:UIControlStateNormal];
//    [upButton setBackgroundImage:[UIImage imageNamed:@"setUp_disable"] forState:UIControlStateDisabled];
//    upButton.tag = TAG_FOR_DEMO_MODE_TIME_UP_BUTTON;
//    UILongPressGestureRecognizer *upInTimeLongPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(upButtonOfDemoModeLongPressed:)];
//    [upInTimeLongPressGesture setMinimumPressDuration:MINIMUM_PRESS_DURATION];
//    [upButton addGestureRecognizer:upInTimeLongPressGesture];
//    [upButton addTarget:self
//                 action:@selector(upButtonOfDemoModeClicked:)
//       forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:upButton];
//    
//    downButtonRect = CGRectMake(x + width- 25, y + 30 , 20, 20);
//    downButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [downButton setFrame:downButtonRect];
//    [downButton setBackgroundImage:[UIImage imageNamed:@"setDown"] forState:UIControlStateNormal];
//    [downButton setBackgroundImage:[UIImage imageNamed:@"setDown_disable"] forState:UIControlStateDisabled];
//    downButton.tag = TAG_FOR_DEMO_MODE_TIME_DOWN_BUTTON;
//    UILongPressGestureRecognizer *downInTimeLongPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(downButtonOfDemoModeLongPressed:)];
//    [downInTimeLongPressGesture setMinimumPressDuration:MINIMUM_PRESS_DURATION];
//    [downButton addGestureRecognizer:downInTimeLongPressGesture];
//    [downButton addTarget:self
//                   action:@selector(downButtonOfDemoModeClicked:)
//         forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:downButton];
//    [upButton addTarget:self action:@selector(touchesBegan:withEvent:) forControlEvents:UIControlEventAllEvents];
//    [downButton addTarget:self action:@selector(touchesBegan:withEvent:) forControlEvents:UIControlEventAllEvents];
    
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
    label.tag = TAG_FOR_HEIGHT_LABEL;
    [self.view addSubview:label];
    
//    upButtonRect = CGRectMake(x + width- 25, y + 5 , 20, 20);
//    upButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [upButton setFrame:upButtonRect];
//    [upButton setBackgroundImage:[UIImage imageNamed:@"setUp"] forState:UIControlStateNormal];
//    [upButton setBackgroundImage:[UIImage imageNamed:@"setUp_disable"] forState:UIControlStateDisabled];
//    upButton.tag = TAG_FOR_HEIGHT_UP_BUTTON;
//    UILongPressGestureRecognizer *upInHeightLongPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(upButtonOfHeightLongPressed:)];
//    [upInHeightLongPressGesture setMinimumPressDuration:MINIMUM_PRESS_DURATION];
//    [upButton addGestureRecognizer:upInHeightLongPressGesture];
//    [upButton addTarget:self
//                 action:@selector(upButtonOfHeightClicked:)
//       forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:upButton];
//    
//    downButtonRect = CGRectMake(x + width- 25, y + 30 , 20, 20);
//    downButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [downButton setFrame:downButtonRect];
//    [downButton setBackgroundImage:[UIImage imageNamed:@"setDown"] forState:UIControlStateNormal];
//    [downButton setBackgroundImage:[UIImage imageNamed:@"setDown_disable"] forState:UIControlStateDisabled];
//    downButton.tag = TAG_FOR_HEIGHT_DOWN_BUTTON;
//    UILongPressGestureRecognizer *downInHeightLongPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(downButtonOfHeightLongPressed:)];
//    [downInHeightLongPressGesture setMinimumPressDuration:MINIMUM_PRESS_DURATION];
//    [downButton addGestureRecognizer:downInHeightLongPressGesture];
//    [downButton addTarget:self
//                   action:@selector(downButtonOfHeightClicked:)
//         forControlEvents:UIControlEventTouchDown];
//    [self.view addSubview:downButton];
//    [upButton addTarget:self action:@selector(touchesBegan:withEvent:) forControlEvents:UIControlEventAllEvents];
//    [downButton addTarget:self action:@selector(touchesBegan:withEvent:) forControlEvents:UIControlEventAllEvents];
}

- (void)updateLabelsAndButtonStatus
{
    InsetsLabel *label = nil;
    
    // Max speed
    for (NSInteger i = 1; i <= MOTOR_COUNT; ++i) {
        NSUInteger maxSpeed = [[TACSettingManager sharedManager] maxSpeedOfMotor:i];
        label = (InsetsLabel *)[self.view viewWithTag:BASE_TAG_FOR_MAX_SPEED_SETTING_LABEL + i];
        label.text = [NSString stringWithFormat:@"%ld%@", maxSpeed, @"rpm"];
        
        if (maxSpeed == MAX_SPEED) {
            UIButton *upButton = (UIButton *)[self.view viewWithTag:BASE_TAG_FOR_MAX_SPEED_SETTING_UP_BUTTON + i];
            upButton.enabled = NO;
        } else if (maxSpeed == MIN_SPEED_FOR_MAX_SPEED) {
            UIButton *downButton = (UIButton *)[self.view viewWithTag:BASE_TAG_FOR_MAX_SPEED_SETTING_DOWN_BUTTON + i];
            downButton.enabled = NO;
        }
    }
    
    // Default speed
    for (NSInteger i = 1; i < MOTOR_COUNT; ++i) {
        NSUInteger defaultSpeed = [[TACSettingManager sharedManager] defaultSpeedOfMotor:i];
        label = (InsetsLabel *)[self.view viewWithTag:BASE_TAG_FOR_DEFAULT_SPEED_SETTING_LABEL + i];
        label.text = [NSString stringWithFormat:@"%ld%@", defaultSpeed, @"rpm"];
        
        NSUInteger maxSpeed = [[TACSettingManager sharedManager] maxSpeedOfMotor:i];
        if (defaultSpeed == maxSpeed) {
            UIButton *upButton = (UIButton *)[self.view viewWithTag:BASE_TAG_FOR_DEFAULT_SPEED_SETTING_UP_BUTTON + i];
            upButton.enabled = NO;
        } else if (defaultSpeed == MIN_SPEED) {
            UIButton *downButton = (UIButton *)[self.view viewWithTag:BASE_TAG_FOR_DEFAULT_SPEED_SETTING_DOWN_BUTTON + i];
            downButton.enabled = NO;
        }
    }
    
    // Time
    NSUInteger time = [TACSettingManager sharedManager].DemoModeTime;
    label = (InsetsLabel *)[self.view viewWithTag:TAG_FOR_DEMO_MODE_TIME_LABEL];
    label.text = [self getFormatTimeFromSeconds:time];
    
    if (time == MAX_DEMO_MODE_TIME) {
        UIButton *upButton = (UIButton *)[self.view viewWithTag:TAG_FOR_DEMO_MODE_TIME_UP_BUTTON];
        upButton.enabled = NO;
    } else if (time == MIN_DEMO_MODE_TIME) {
        UIButton *downButton = (UIButton *)[self.view viewWithTag:TAG_FOR_DEMO_MODE_TIME_DOWN_BUTTON];
        downButton.enabled = NO;
    }
    
    // Height
    NSUInteger height = [TACSettingManager sharedManager].Height;
    label = (InsetsLabel *)[self.view viewWithTag:TAG_FOR_HEIGHT_LABEL];
    label.text = [NSString stringWithFormat:@"%.2f%@", height / 100.0, @" m"];
    
    if (height == MAX_HEIGHT) {
        UIButton *upButton = (UIButton *)[self.view viewWithTag:TAG_FOR_HEIGHT_UP_BUTTON];
        upButton.enabled = NO;
    } else if (height == MIN_HEIGHT) {
        UIButton *downButton = (UIButton *)[self.view viewWithTag:TAG_FOR_HEIGHT_DOWN_BUTTON];
        downButton.enabled = NO;
    }
}

- (void)saveDataToUserDefault
{
    InsetsLabel *label = nil;
    
    // Max speed
    for (NSInteger i = 1; i <= MOTOR_COUNT; ++i) {
        label = (InsetsLabel *)[self.view viewWithTag:BASE_TAG_FOR_MAX_SPEED_SETTING_LABEL + i];
        NSUInteger value = [label.text integerValue];
        [[TACSettingManager sharedManager] setMaxSpeedforMotor:i
                                                     withSpeed:value];
    }
    
    // Default speed
    for (NSInteger i = 1; i < MOTOR_COUNT; ++i) {
        label = (InsetsLabel *)[self.view viewWithTag:BASE_TAG_FOR_DEFAULT_SPEED_SETTING_LABEL + i];
        NSUInteger value = [label.text integerValue];
        [[TACSettingManager sharedManager] setDefaultSpeedforMotor:i
                                                         withSpeed:value];
    }
    
    // Time
    label = (InsetsLabel *)[self.view viewWithTag:TAG_FOR_DEMO_MODE_TIME_LABEL];
    NSUInteger time =[self getSecondsFromFormatTime:label.text];
    [[TACSettingManager sharedManager] setDemoModeTime:time];
    
    // Height
    label = (InsetsLabel *)[self.view viewWithTag:TAG_FOR_HEIGHT_LABEL];
    CGFloat height = [label.text floatValue];
    [[TACSettingManager sharedManager] setHeight:height * 100];
}

- (NSString *)getFormatTimeFromSeconds:(NSUInteger)seconds
{
    NSUInteger min = seconds / 60;
    NSUInteger sec = seconds % 60;
    
    if (min == 0)       return [NSString stringWithFormat:@"%ld%@", sec, @"s"];
    else if (sec == 0)  return [NSString stringWithFormat:@"%ld%@", min, @"mins"];
    else                return [NSString stringWithFormat:@"%ld%@%ld%@", min, @"mins ", sec, @"s"];
}

- (NSUInteger)getSecondsFromFormatTime:(NSString *)formatTime
{
    NSUInteger seconds = 0;
    
    NSArray *values = [formatTime componentsSeparatedByString:@"mins"];
    if ([values count] == 2) {
        seconds = [values[0] integerValue] * 60 + [values[1] integerValue];
    } else {
        seconds = [formatTime integerValue];
        if ([formatTime rangeOfString:@"mins"].location != NSNotFound) seconds *= 60;
    }
    
    return seconds;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    touchPoint = [touch locationInView:self.view];
    NSLog(@"Touch x : %f y : %f", touchPoint.x, touchPoint.y);
}

@end
