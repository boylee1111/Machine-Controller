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

@interface TACViewController () {
    GCDAsyncSocket *asyncSocket;
}

@end

@implementation TACViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [asyncSocket writeData:[SET_FREQUENCY_FOR_MOTOR_WITH_PERCENTAGE(num, [[TACSettingManager sharedManager] speedOfMotorWithPercent:num]) dataUsingEncoding:NSASCIIStringEncoding] withTimeout:-1 tag:888];
}

@end
