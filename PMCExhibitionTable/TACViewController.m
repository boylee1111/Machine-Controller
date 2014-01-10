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
#import "TACHumanImageView.h"

#define HOST_IP_ADDRESS @"192.168.1.105"
#define LOCAL_IP_ADDRESS @"127.0.0.1"
#define PORT 4000

#define BASE_TAG_FOR_LOGO_BUTTON 300
#define BASE_TAG_FOR_HUMAN_HEIGHT 400

#define HUMAN_HEIGHT_IMAGE_HEIGHT_RATE (160.0f / 180.0f)
#define HUMAN_HEIGHT_X 838
#define HUMAN_HEIGHT_Y 215
#define HUMAN_WIDTH 113

@interface TACViewController () {
    GCDAsyncSocket *asyncSocket;
}

@end

@implementation TACViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    for (int i = 1; i <= MOTOR_COUNT; ++i) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToPopTheSlider:)];
        longPress.minimumPressDuration = 2;
        UIButton *logoButton = (UIButton *)[self.view viewWithTag:BASE_TAG_FOR_LOGO_BUTTON + i];
        [logoButton addGestureRecognizer:longPress];
    }
    
    [self refreshHumanHeight];
    [TACSettingManager sharedManager].Height = 200;
    
    UIImage *humanImage = [UIImage imageNamed:@"human"];
    UIImageView *humanImageView = [[UIImageView alloc] initWithImage:humanImage];
    CGFloat rectHeight = [TACSettingManager sharedManager].Height * HUMAN_HEIGHT_IMAGE_HEIGHT_RATE;
    humanImageView.frame = CGRectMake(HUMAN_HEIGHT_X, HUMAN_HEIGHT_Y - rectHeight, HUMAN_WIDTH, rectHeight);
    humanImageView.tag = BASE_TAG_FOR_HUMAN_HEIGHT;
    
    UIPanGestureRecognizer *dragView = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragToHumanHeight:)];
    [humanImageView setUserInteractionEnabled:YES];
    [humanImageView addGestureRecognizer:dragView];
    
    [self.view addSubview:humanImageView];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    /* !!!: ----------- socket测试 ----------- */
    asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self
                                             delegateQueue:dispatch_get_main_queue()];
    NSError *err = nil;
    if (![asyncSocket connectToHost:LOCAL_IP_ADDRESS
                             onPort:PORT
                        withTimeout:5
                              error:&err]) {
        NSLog(@"connect error %@", err);
    }
    /* -------------------------------------- */
    
}

- (void)refreshHumanHeight{
    UIImageView *humanImage = (UIImageView*) [self.view viewWithTag:BASE_TAG_FOR_HUMAN_HEIGHT];
    CGFloat rectHeight = [TACSettingManager sharedManager].Height * HUMAN_HEIGHT_IMAGE_HEIGHT_RATE;
    humanImage.frame = CGRectMake(HUMAN_HEIGHT_X, HUMAN_HEIGHT_Y - rectHeight, HUMAN_WIDTH, rectHeight);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action

- (IBAction)logoSelectOrDeselect:(UIButton *)sender {
    sender.selected ^= 0x1;
}

#pragma mark - Selectors

- (void)longPressToPopTheSlider:(UILongPressGestureRecognizer *)sender
{
    UIButton *logo = (UIButton *)sender.view;
    NSLog(@"logo tag = %d", logo.tag);
}

-(void) dragToHumanHeight:(UIPanGestureRecognizer *)sender {
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

#pragma mark - GCDAsyncSocket Delegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host
          port:(uint16_t)port {
    NSLog(@"connect successfully. Setting initialize");
    
    [self writeSettingParameter];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"tag = %ld", tag);
}

#pragma mark - Helper Methods

- (void)writeSettingParameter
{
    int num = 5;
    
    [asyncSocket writeData:[SET_HEIGH([TACSettingManager sharedManager].Height) dataUsingEncoding:NSASCIIStringEncoding] withTimeout:-1 tag:888];
    [asyncSocket writeData:[START_ALL_MOTORS_MSG dataUsingEncoding:NSASCIIStringEncoding] withTimeout:-1 tag:888];
    [asyncSocket writeData:[STOP_ALL_MOTORS_MSG dataUsingEncoding:NSASCIIStringEncoding] withTimeout:-1 tag:888];
    [asyncSocket writeData:[START_MOTOR(num) dataUsingEncoding:NSASCIIStringEncoding] withTimeout:-1 tag:888];
    [asyncSocket writeData:[ROTATE_MOTOR_CLOCKWISE(num) dataUsingEncoding:NSASCIIStringEncoding] withTimeout:-1 tag:888];
    [asyncSocket writeData:[ROTATE_MOTOR_COUNTERCLOCKWISE(num) dataUsingEncoding:NSASCIIStringEncoding] withTimeout:-1 tag:88];
    [asyncSocket writeData:[SET_FREQUENCY_FOR_MOTOR_WITH_PERCENTAGE(num, [[TACSettingManager sharedManager] defaultSpeedOfMotorWithPercent:num]) dataUsingEncoding:NSASCIIStringEncoding] withTimeout:-1 tag:888];
}

@end
