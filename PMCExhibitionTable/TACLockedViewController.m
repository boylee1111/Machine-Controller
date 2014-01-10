//
//  TACLockedViewController.m
//  PMCExhibitionTable
//
//  Created by Nathan on 14-1-10.
//  Copyright (c) 2014年 com.nathan. All rights reserved.
//

#import "TACLockedViewController.h"
#import "CommandExporter.h"

@interface TACLockedViewController () {
    GCDAsyncSocket *asyncSocket;
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
    
    asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    
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
    
    NSError *err = nil;
    if (![asyncSocket connectToHost:LOCAL_IP_ADDRESS
                             onPort:PORT
                        withTimeout:5
                              error:&err]) {
        NSLog(@"connect error %@", err);
    }
}

#pragma mark - Delegates

#pragma mark MBSliderViewDelegate Delegate

- (void) sliderDidSlide:(MBSliderView *)slideView {
    // Customization example
    [self dismissViewControllerAnimated:UIModalTransitionStyleCrossDissolve completion:nil];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark GCDAsyncSocket Delegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host
          port:(uint16_t)port {
    NSLog(@"Connecting successfully. Demo mode begins.");
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    NSLog(@"Wirting data tag = %ld", tag);
}

@end
