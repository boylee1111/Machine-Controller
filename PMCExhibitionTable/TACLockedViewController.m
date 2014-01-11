//
//  TACLockedViewController.m
//  PMCExhibitionTable
//
//  Created by Nathan on 14-1-10.
//  Copyright (c) 2014年 com.nathan. All rights reserved.
//

#import "TACLockedViewController.h"
#import "TACAppDelegate.h"
#import "CommandExporter.h"
#import "TACSettingManager.h"
#import "GCDAsyncSocket.h"

@interface TACLockedViewController () {
    GCDAsyncSocket *asyncSocket;
    
    NSTimer *timer;
    NSInteger count;
}

@end

@implementation TACLockedViewController

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
	// Do any additional setup after loading the view.
    
    TACAppDelegate *appDelegate = (TACAppDelegate *)[[UIApplication sharedApplication] delegate];
    asyncSocket = appDelegate.asyncSocket;
    
    MBSliderView *s1 = [[MBSliderView alloc] initWithFrame:CGRectMake(285, 440, 450, 44.0)];
    [s1 setText:@">>>"]; // set the label text
//    [s1 setThumbColor:[UIColor colorWithRed:166.0/255.0 green:166.0/255.0 blue:166.0/255.0 alpha:1.0]];
    [s1 setThumbColor:[UIColor grayColor]];
    [s1 setDelegate:self]; // set the MBSliderView delegate
    [self.view addSubview:s1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self writeSettingParameter];
    
//    timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(repeatFunction) userInfo:nil repeats:false];
    count = 0;
    [self repeatFunction];
}

- (void)viewDidDisappear:(BOOL)animated {
    [timer invalidate];
    [asyncSocket writeData:[STOP_ALL_MOTORS_MSG dataUsingEncoding:NSASCIIStringEncoding]
               withTimeout:-1
                       tag:STOP_ALL_TAG];
}

- (void) repeatFunction {
    count++;
    [asyncSocket writeData:[STOP_ALL_MOTORS_MSG dataUsingEncoding:NSASCIIStringEncoding]
               withTimeout:-1
                       tag:STOP_ALL_TAG];
    if (count < 38) {
        NSInteger i = (count - 1) % 12 + 1;
        NSInteger send;
        if (i <= 7) {
            //send i;
            send = i;
//            NSLog(@"send %d", i);
        } else {
            send = 14 - i;
            //send 14 - i;
//            NSLog(@"send %d", 14 - i);
        }
        
        [asyncSocket writeData:[SET_FREQUENCY_FOR_MOTOR_WITH_PERCENTAGE(send, 500.0f / 1500.0f * 100) dataUsingEncoding:NSASCIIStringEncoding]
                   withTimeout:-1
                           tag:SET_FREQUENCY_FOR_MOTOR_TAG(i)];
        [asyncSocket writeData:[START_MOTOR(send) dataUsingEncoding:NSASCIIStringEncoding]
                   withTimeout:-1
                           tag:START_MOTOR_TAG(i)];
        timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(repeatFunction) userInfo:nil repeats:false];
    } else if (count == 38) {
        //random 1min
        [asyncSocket writeData:[STOP_ALL_MOTORS_MSG dataUsingEncoding:NSASCIIStringEncoding]
                   withTimeout:-1
                           tag:STOP_ALL_TAG];
        for (NSInteger i = 1; i <= 7 ; i++) {
            NSInteger ran;
            do {
                ran = arc4random() % 3001 - 1500;
            } while (abs(ran) <=10);
            [asyncSocket writeData:[SET_FREQUENCY_FOR_MOTOR_WITH_PERCENTAGE(i, ran / 1500.0f * 100) dataUsingEncoding:NSASCIIStringEncoding]
                       withTimeout:-1
                               tag:SET_FREQUENCY_FOR_MOTOR_TAG(i)];
//            [asyncSocket writeData:[START_MOTOR(i) dataUsingEncoding:NSASCIIStringEncoding]
//                       withTimeout:-1
//                               tag:START_MOTOR_TAG(i)];

        }
        [asyncSocket writeData:[START_ALL_MOTORS_MSG dataUsingEncoding:NSASCIIStringEncoding]
                   withTimeout:-1
                           tag:START_ALL_TAG];
//        NSLog(@"random");
        timer = [NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(repeatFunction) userInfo:nil repeats:false];
    } else if (count > 38) {
        count = 0;
        //stop 5s
//        NSLog(@"stop");
        timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(repeatFunction) userInfo:nil repeats:false];
    }
}

#pragma mark - MBSliderViewDelegate Delegate

- (void) sliderDidSlide:(MBSliderView *)slideView {
    // Customization example    
    [self dismissViewControllerAnimated:UIModalTransitionStyleCrossDissolve completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
