//
//  TACViewController.m
//  PMCExhibitionTable
//
//  Created by Nathan on 14-1-6.
//  Copyright (c) 2014年 com.nathan. All rights reserved.
//

#import "TACViewController.h"
#import "CommandExporter.h"
#import "TACSettingManager.h"

#define HOST_IP_ADDRESS @"192.168.1.105"
#define LOCAL_IP_ADDRESS @"127.0.0.1"
#define PORT 4000

#define BASE_TAG_FOR_LOGO_BUTTON 300

// These tags are used to mark data stream when writing data to server
#define SET_HEIGHT_TAG 1000
#define START_ALL_TAG 1100
#define STOP_ALL_TAG 1200
#define START_MOTOR_TAG(num) 1300 + num
#define ROTATE_MOTOR_CLOCKWISE_TAG(num) 1400 + num
#define ROTATE_MOTOR_COUNTERCLOCKWISE_TAG(num) 1500 + num
#define SET_FREQUENCY_FOR_MOTOR_TAG(num) 1600 + num

@interface TACViewController () {
    GCDAsyncSocket *asyncSocket;
    
    NSUInteger currentModifyMotorNumber; // 记录当前slider更改哪个motor数值
}

@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UISlider *frequencySlider;
@property (weak, nonatomic) IBOutlet UILabel *decoratedLabel;
@property (weak, nonatomic) IBOutlet UILabel *frequencyLabel;

@end

@implementation TACViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.frequencySlider.alpha = 0;
    self.decoratedLabel.alpha = 0;
    self.frequencyLabel.alpha = 0;
    
    for (NSInteger i = 1; i <= MOTOR_COUNT; ++i) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                action:@selector(longPressToPopTheSlider:)];
        longPress.minimumPressDuration = 2;
        UIButton *logoButton = (UIButton *)[self.view viewWithTag:BASE_TAG_FOR_LOGO_BUTTON + i];
        [logoButton addGestureRecognizer:longPress];
    }
    
    UILongPressGestureRecognizer *startLongPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                 action:@selector(longPressStartButtonToStartAll:)];
    startLongPress.minimumPressDuration = 2;
    [self.startButton addGestureRecognizer:startLongPress];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self
                                             delegateQueue:dispatch_get_main_queue()];
    NSError *err = nil;
    if (![asyncSocket connectToHost:LOCAL_IP_ADDRESS
                             onPort:PORT
                        withTimeout:5
                              error:&err]) {
        NSLog(@"connect error %@", err);
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action

- (IBAction)startButtonClicked:(id)sender {
    for (NSInteger i = 1; i <= MOTOR_COUNT; ++i) {
        UIButton *logo = (UIButton *)[self.view viewWithTag:BASE_TAG_FOR_LOGO_BUTTON + i];
        if ([logo isSelected]) {
            CGFloat speed = [[TACSettingManager sharedManager] defaultSpeedOfMotorWithPercent:i];
            [asyncSocket writeData:[SET_FREQUENCY_FOR_MOTOR_WITH_PERCENTAGE(i, speed) dataUsingEncoding:NSASCIIStringEncoding]
                       withTimeout:-1
                               tag:SET_FREQUENCY_FOR_MOTOR_TAG(i)];
            [asyncSocket writeData:[START_MOTOR(i) dataUsingEncoding:NSASCIIStringEncoding]
                       withTimeout:-1
                               tag:START_MOTOR_TAG(i)];
        }
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frequencySlider.alpha = 0;
        self.decoratedLabel.alpha = 0;
        self.frequencyLabel.alpha = 0;
    }];
}

- (IBAction)stopButtonClicked:(id)sender {
    [asyncSocket writeData:[STOP_ALL_MOTORS_MSG dataUsingEncoding:NSASCIIStringEncoding]
               withTimeout:-1
                       tag:STOP_ALL_TAG];
}

- (IBAction)logoSelectOrDeselect:(UIButton *)sender {
    sender.selected ^= 0x1;
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frequencySlider.alpha = 0;
        self.decoratedLabel.alpha = 0;
        self.frequencyLabel.alpha = 0;
    }];
}

- (IBAction)changeSliderValue:(UISlider *)sender {
    NSUInteger maxSpeed = [[TACSettingManager sharedManager] maxSpeedOfMotor:currentModifyMotorNumber];
    NSInteger frequencyValue = (sender.value - 0.5) * maxSpeed * 2;
    
    if (frequencyValue > -LIMIT_SPEED && frequencyValue < LIMIT_SPEED) {
        frequencyValue = 0;
    }
    
    self.frequencyLabel.text = [NSString stringWithFormat:@"%ld", frequencyValue];
}

- (IBAction)valueChangeEnd:(UISlider *)sender {
    NSInteger frequencyValue = [self.frequencyLabel.text integerValue];
    
    if (frequencyValue < 0) {
        [asyncSocket writeData:[ROTATE_MOTOR_COUNTERCLOCKWISE(currentModifyMotorNumber) dataUsingEncoding:NSASCIIStringEncoding]
                   withTimeout:-1
                           tag:ROTATE_MOTOR_COUNTERCLOCKWISE_TAG(currentModifyMotorNumber)];
    } else {
        [asyncSocket writeData:[ROTATE_MOTOR_CLOCKWISE(currentModifyMotorNumber) dataUsingEncoding:NSASCIIStringEncoding]
                   withTimeout:-1
                           tag:ROTATE_MOTOR_CLOCKWISE_TAG(currentModifyMotorNumber)];
    }
    
    [[TACSettingManager sharedManager] setDefaultSpeedforMotor:currentModifyMotorNumber
                                                     withSpeed:ABS(frequencyValue)];
}

#pragma mark - Selectors

- (void)longPressStartButtonToStartAll:(UILongPressGestureRecognizer *)sender
{
    [asyncSocket writeData:[START_ALL_MOTORS_MSG dataUsingEncoding:NSASCIIStringEncoding]
               withTimeout:-1
                       tag:START_ALL_TAG];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.frequencySlider.alpha = 0;
        self.decoratedLabel.alpha = 0;
        self.frequencyLabel.alpha = 0;
    }];
}

- (void)longPressToPopTheSlider:(UILongPressGestureRecognizer *)sender
{
    UIButton *logo = (UIButton *)sender.view;
    [logo setSelected:YES];
    currentModifyMotorNumber = logo.tag - BASE_TAG_FOR_LOGO_BUTTON;
    
    [UIView animateWithDuration:1 animations:^{
        self.frequencySlider.alpha = 1;
        self.decoratedLabel.alpha = 1;
        self.frequencyLabel.alpha = 1;
    }];
}

#pragma mark - GCDAsyncSocket Delegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host
          port:(uint16_t)port {
    NSLog(@"Connecting successfully. Setting initialize");
    
    [self writeSettingParameter];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"Wirting data tag = %ld", tag);
}

#pragma mark - Helper Methods

- (void)writeSettingParameter
{
    NSUInteger num = 5;
    
    [asyncSocket writeData:[SET_HEIGH([TACSettingManager sharedManager].Height) dataUsingEncoding:NSASCIIStringEncoding] withTimeout:-1 tag:888];
    [asyncSocket writeData:[START_ALL_MOTORS_MSG dataUsingEncoding:NSASCIIStringEncoding] withTimeout:-1 tag:888];
    [asyncSocket writeData:[STOP_ALL_MOTORS_MSG dataUsingEncoding:NSASCIIStringEncoding] withTimeout:-1 tag:888];
    [asyncSocket writeData:[START_MOTOR(num) dataUsingEncoding:NSASCIIStringEncoding] withTimeout:-1 tag:888];
    [asyncSocket writeData:[ROTATE_MOTOR_CLOCKWISE(num) dataUsingEncoding:NSASCIIStringEncoding] withTimeout:-1 tag:888];
    [asyncSocket writeData:[ROTATE_MOTOR_COUNTERCLOCKWISE(num) dataUsingEncoding:NSASCIIStringEncoding] withTimeout:-1 tag:88];
    [asyncSocket writeData:[SET_FREQUENCY_FOR_MOTOR_WITH_PERCENTAGE(num, [[TACSettingManager sharedManager] defaultSpeedOfMotorWithPercent:num]) dataUsingEncoding:NSASCIIStringEncoding] withTimeout:-1 tag:888];
}

@end
