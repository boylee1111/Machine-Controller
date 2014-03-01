//
//  TACViewController.m
//  PMCExhibitionTable
//
//  Created by Nathan on 14-1-6.
//  Copyright (c) 2014年 com.nathan. All rights reserved.
//

#import "TACViewController.h"
#import "TACAppDelegate.h"
#import "GCDAsyncSocket.h"
#import "CommandExporter.h"
#import "TACSettingManager.h"

#define BASE_TAG_FOR_LOGO_BUTTON 300
#define BASE_TAG_FOR_HUMAN_HEIGHT 400

#define HUMAN_HEIGHT_IMAGE_HEIGHT_RATE (160.0f / 180.0f)
#define HUMAN_HEIGHT_X 838
#define HUMAN_HEIGHT_Y 215
#define HUMAN_WIDTH 113

#define HUMAN_HEIGHT_LABEL_HEIGHT 30

@interface TACViewController () {
    GCDAsyncSocket *asyncSocket;
    NSTimer *backTimer;
    NSInteger unTouchedTime;
    CGPoint touchPoint;
    CGPoint lastTouchPoint;
    NSUInteger currentModifyMotorNumber; // 记录当前slider更改哪个motor数值
    BOOL startStopButtonStatus; // 0 -- start, 1 -- stop
}
@property (weak, nonatomic) IBOutlet UIButton *startStopButton;
@property (weak, nonatomic) IBOutlet UISlider *frequencySlider;
@property (weak, nonatomic) IBOutlet UILabel *decoratedLabel;
@property (weak, nonatomic) IBOutlet UILabel *frequencyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sliderBackgroundImageView;

@end

@implementation TACViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    TACAppDelegate *appDelegate = (TACAppDelegate *)[[UIApplication sharedApplication] delegate];
    asyncSocket = appDelegate.asyncSocket;
    
    [self.frequencySlider setThumbImage:[UIImage imageNamed:@"thumb"] forState:UIControlStateNormal];
    [self hideTheSlider];
    
    // Add start all button gesture
    UILongPressGestureRecognizer *startAllPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                action:@selector(longPressStartStopButtonToStartAll:)];
    startAllPressGesture.minimumPressDuration = 2;
    [self.startStopButton addGestureRecognizer:startAllPressGesture];
    
    // Add long press gesture to logo
    for (NSInteger i = 1; i <= MOTOR_COUNT; ++i) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                                action:@selector(longPressToPopTheSlider:)];
        longPress.minimumPressDuration = 2;
        UIButton *logoButton = (UIButton *)[self.view viewWithTag:BASE_TAG_FOR_LOGO_BUTTON + i];
        [logoButton addGestureRecognizer:longPress];
        
        //add button and slider into touch target
        UIControl *temp = [[UIControl alloc]init];
        for (int i= 0; i<self.objectsInView.count; i++) {
            temp = self.objectsInView[i];
            [temp addTarget:self action:@selector(touchesBegan:withEvent:) forControlEvents:UIControlEventAllEvents];
        }
    }
    
    UIImage *humanImage = [UIImage imageNamed:@"human"];
    UIImageView *humanImageView = [[UIImageView alloc] initWithImage:humanImage];
    CGFloat rectHeight = [TACSettingManager sharedManager].Height * HUMAN_HEIGHT_IMAGE_HEIGHT_RATE;
    humanImageView.frame = CGRectMake(HUMAN_HEIGHT_X, HUMAN_HEIGHT_Y - rectHeight, HUMAN_WIDTH, rectHeight);
    humanImageView.tag = BASE_TAG_FOR_HUMAN_HEIGHT;
    
    UIPanGestureRecognizer *dragView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragToHumanHeight:)];
    [humanImageView setUserInteractionEnabled:YES];
    [humanImageView addGestureRecognizer:dragView];
    
    [self.view addSubview:humanImageView];
    
    UIFont* font = [UIFont boldSystemFontOfSize:28.0f];
    UILabel *humanHeightLabel = [[UILabel alloc] initWithFrame:CGRectMake(HUMAN_HEIGHT_X, HUMAN_HEIGHT_Y - rectHeight, HUMAN_WIDTH, HUMAN_HEIGHT_LABEL_HEIGHT)];
    humanHeightLabel.font = font;
    humanHeightLabel.text = [NSString stringWithFormat:@"%ldcm", [TACSettingManager sharedManager].Height];
    humanHeightLabel.tag = BASE_TAG_FOR_HUMAN_HEIGHT + 1;
    [self.view addSubview:humanHeightLabel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    startStopButtonStatus = false;
    
    [asyncSocket writeData:[STOP_ALL_MOTORS_MSG dataUsingEncoding:NSASCIIStringEncoding]
               withTimeout:-1
                       tag:STOP_ALL_TAG];
    [asyncSocket writeData:[SET_HEIGH([TACSettingManager sharedManager].Height) dataUsingEncoding:NSASCIIStringEncoding]
               withTimeout:-1
                       tag:SET_HEIGHT_TAG];
    for (NSInteger i = 1; i <= MOTOR_COUNT; ++i) {
        [asyncSocket writeData:[SET_FREQUENCY_FOR_MOTOR_WITH_PERCENTAGE(i, [[TACSettingManager sharedManager] defaultSpeedOfMotorWithPercent:i]) dataUsingEncoding:NSASCIIStringEncoding]
                   withTimeout:-1
                           tag:SET_FREQUENCY_FOR_MOTOR_TAG(i)];
    }
    
    [self refreshHumanHeight];
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
    
    [asyncSocket writeData:[STOP_ALL_MOTORS_MSG dataUsingEncoding:NSASCIIStringEncoding]
               withTimeout:-1
                       tag:STOP_ALL_TAG];
    
    [backTimer invalidate];
}

- (void)refreshHumanHeight{
    UIImageView *humanImage = (UIImageView*) [self.view viewWithTag:BASE_TAG_FOR_HUMAN_HEIGHT];
    CGFloat rectHeight = [TACSettingManager sharedManager].Height * HUMAN_HEIGHT_IMAGE_HEIGHT_RATE;
    humanImage.frame = CGRectMake(HUMAN_HEIGHT_X, HUMAN_HEIGHT_Y - rectHeight, HUMAN_WIDTH, rectHeight);
    
    UILabel *humanLabel = (UILabel*) [self.view viewWithTag:BASE_TAG_FOR_HUMAN_HEIGHT+1];
    CGRect rect = humanLabel.frame;
    humanLabel.frame = CGRectMake(HUMAN_HEIGHT_X, HUMAN_HEIGHT_Y - rectHeight, rect.size.width, rect.size.height);
    humanLabel.text = [NSString stringWithFormat:@"%ldcm", [TACSettingManager sharedManager].Height];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action

- (IBAction)startStopButtonClicked:(id)sender {
    if (!startStopButtonStatus) {
        for (NSInteger i = 1; i <= MOTOR_COUNT; ++i) {
            UIButton *logo = (UIButton *)[self.view viewWithTag:BASE_TAG_FOR_LOGO_BUTTON + i];
            if ([logo isSelected]) {
                CGFloat speed = [[TACSettingManager sharedManager] defaultSpeedOfMotorWithPercent:i];
                [asyncSocket writeData:[SET_FREQUENCY_FOR_MOTOR_WITH_PERCENTAGE(i, speed) dataUsingEncoding:NSASCIIStringEncoding]
                           withTimeout:-1
                                   tag:SET_FREQUENCY_FOR_MOTOR_TAG(i)];
            }
        }
        
        BOOL isAllSelected = YES;
        for (NSInteger i = 1; i <= MOTOR_COUNT; ++i) {
            UIButton *logo = (UIButton *)[self.view viewWithTag:BASE_TAG_FOR_LOGO_BUTTON + i];
            if (![logo isSelected]) isAllSelected = NO;
        }
        
        if (isAllSelected) {
            [asyncSocket writeData:[START_ALL_MOTORS_MSG dataUsingEncoding:NSASCIIStringEncoding]
                       withTimeout:-1
                               tag:START_ALL_TAG];
        } else {
            for (NSInteger i = 1; i <= MOTOR_COUNT; ++i) {
                UIButton *logo = (UIButton *)[self.view viewWithTag:BASE_TAG_FOR_LOGO_BUTTON + i];
                if ([logo isSelected]) {
                    [asyncSocket writeData:[START_MOTOR(i) dataUsingEncoding:NSASCIIStringEncoding]
                               withTimeout:-1
                                       tag:START_MOTOR_TAG(i)];
                }
            }
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            [self hideTheSlider];
        }];
        
        // Button status change
        [self.startStopButton setBackgroundImage:[UIImage imageNamed:@"stopButton"]
                                        forState:UIControlStateNormal];
        startStopButtonStatus = 1;
    } else {
        [asyncSocket writeData:[STOP_ALL_MOTORS_MSG dataUsingEncoding:NSASCIIStringEncoding]
                   withTimeout:-1
                           tag:STOP_ALL_TAG];
        
        [UIView animateWithDuration:0.5 animations:^{
            [self hideTheSlider];
        }];
        
        for (NSInteger i = 1; i <= MOTOR_COUNT; ++i) {
            UIButton *logo = (UIButton *)[self.view viewWithTag:BASE_TAG_FOR_LOGO_BUTTON + i];
            logo.selected = false;
        }
        
        // Button status change
        [self.startStopButton setBackgroundImage:[UIImage imageNamed:@"playButton"]
                                        forState:UIControlStateNormal];
        startStopButtonStatus = 0;
    }
}

- (IBAction)logoSelectOrDeselect:(UIButton *)sender {
    sender.selected ^= 0x1;
    
    [UIView animateWithDuration:0.5 animations:^{
        [self hideTheSlider];
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

- (void)longPressStartStopButtonToStartAll:(UILongPressGestureRecognizer *)sender
{
    if (!startStopButtonStatus && sender.state == UIGestureRecognizerStateEnded) {
        [asyncSocket writeData:[START_ALL_MOTORS_MSG dataUsingEncoding:NSASCIIStringEncoding]
                   withTimeout:-1
                           tag:START_ALL_TAG];
        
        [UIView animateWithDuration:0.5 animations:^{
            [self hideTheSlider];
        }];
        
        // Button status change
        [self.startStopButton setBackgroundImage:[UIImage imageNamed:@"stopButton"]
                                        forState:UIControlStateNormal];
        startStopButtonStatus = 1;
    }
}

- (void)longPressToPopTheSlider:(UILongPressGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIButton *logo = (UIButton *)sender.view;
        [logo setSelected:YES];
        currentModifyMotorNumber = logo.tag - BASE_TAG_FOR_LOGO_BUTTON;
        
        NSUInteger frequencyValue = [[TACSettingManager sharedManager] defaultSpeedOfMotor:currentModifyMotorNumber];
        CGFloat sliderValue = (CGFloat)frequencyValue / (2 * [[TACSettingManager sharedManager] maxSpeedOfMotor:currentModifyMotorNumber]) + 0.5;
        
        
        if (self.frequencySlider.alpha == 0) {
            self.frequencyLabel.text = [NSString stringWithFormat:@"%ld", frequencyValue];
            self.frequencySlider.value = sliderValue;
            
            [UIView animateWithDuration:1 animations:^{
                [self showTheSlider];
            }];
        } else {
            [UIView animateWithDuration:0.5 animations:^{
                [self hideTheSlider];
            } completion:^(BOOL finished) {
                self.frequencyLabel.text = [NSString stringWithFormat:@"%ld", frequencyValue];
                self.frequencySlider.value = sliderValue;
                
                [UIView animateWithDuration:0.5 animations:^{
                    [self showTheSlider];
                }];
            }];
        }
    }
}

-(void) dragToHumanHeight:(UIPanGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        [asyncSocket writeData:[SET_HEIGH([TACSettingManager sharedManager].Height) dataUsingEncoding:NSASCIIStringEncoding] withTimeout:-1 tag:SET_HEIGHT_TAG ];
        return ;
    }
    UIImageView *view = (UIImageView *)[self.view viewWithTag:BASE_TAG_FOR_HUMAN_HEIGHT];
//    CGPoint vector = [sender translationInView:view.nil];
    CGPoint vector = [sender velocityInView:nil];
    if (vector.x > 0) {
        [TACSettingManager sharedManager].Height -= 1;
    } else if (vector.x < 0) {
        [TACSettingManager sharedManager].Height
        += 1;    }
    if ([TACSettingManager sharedManager].Height < 120) {
        [TACSettingManager sharedManager].Height
        = 120;    } else if ([TACSettingManager sharedManager].Height > 200) {
            [TACSettingManager sharedManager].Height = 200;
        }
    [self refreshHumanHeight];
}

#pragma mark - Back Timer
-(void)checkWhetherTouched{
    
    if (CGPointEqualToPoint(touchPoint, lastTouchPoint) ) {
        unTouchedTime++;
    }
    else{
        unTouchedTime = 0;
        [self resetTimer];
    }
    if (unTouchedTime == [TACSettingManager sharedManager].DemoModeTime) {
        [self demoViaTiming];
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

- (void)demoViaTiming
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SettingViewController *settingViewController = [storyboard instantiateViewControllerWithIdentifier:@"TACLockedViewController"];
    [self presentViewController:settingViewController animated:YES completion:nil];
    
}


#pragma mark - Helper Methods

- (void)hideTheSlider
{
    self.frequencySlider.alpha = 0;
    self.decoratedLabel.alpha = 0;
    self.frequencyLabel.alpha = 0;
    self.sliderBackgroundImageView.alpha = 0;
}

- (void)showTheSlider
{
    self.frequencySlider.alpha = 1;
    self.decoratedLabel.alpha = 1;
    self.frequencyLabel.alpha = 1;
    self.sliderBackgroundImageView.alpha = 1;
}
- (IBAction)showInfo:(id)sender {
    
    TACInfoViewController *infoView = [[TACInfoViewController alloc]initWithNibName:@"TACInfoViewController" bundle:nil];
    [self addChildViewController:infoView];
    [self.view addSubview:infoView.view];
    
    
    
}

- (IBAction)settingButtonPressed:(id)sender {
    UIAlertView *passwordAlert = [[UIAlertView alloc]initWithTitle:@"Password" message:nil delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"ok", nil];
    [passwordAlert setAlertViewStyle:UIAlertViewStyleSecureTextInput];
    [passwordAlert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        UITextField *passwordTextField=[alertView textFieldAtIndex:0];
        NSString *password = passwordTextField.text;
        if([password compare:@"1234"]){
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Password is not right!" message:nil delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
            [alert show];
        }
        else{
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            SettingViewController *settingViewController = [storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
            [self presentViewController:settingViewController animated:YES completion:nil];

        }
        
    }
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches] anyObject];
    touchPoint = [touch locationInView:self.view];

}

@end
