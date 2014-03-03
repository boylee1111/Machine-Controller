//
//  TACPlateViewController.m
//  PMCExhibitionTable
//
//  Created by Shawn on 14-3-2.
//  Copyright (c) 2014年 com.nathan. All rights reserved.
//

#import "TACPlateViewController.h"

@interface TACPlateViewController ()

@end

@implementation TACPlateViewController

@synthesize plateDisp;

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
    [self.view setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.5]];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickNumber:(id)sender {
}

- (IBAction)clickOK:(id)sender {
    
    [self clickCancel:sender];
}

- (IBAction)clickDelete:(id)sender {
}

- (IBAction)clickCancel:(id)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}
@end
