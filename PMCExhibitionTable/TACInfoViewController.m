//
//  TACInfoViewController.m
//  PMCExhibitionTable
//
//  Created by Nathan on 14-1-10.
//  Copyright (c) 2014年 com.nathan. All rights reserved.
//

#import "TACInfoViewController.h"

@interface TACInfoViewController ()

@end

@implementation TACInfoViewController

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
    // Do any additional setup after loading the view from its nib.
    [self.view setBackgroundColor:[[UIColor blackColor]colorWithAlphaComponent:0.8]];
    [self.view.layer setCornerRadius:100];
    [self.textView.layer setCornerRadius:100];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButtonPressed:(id)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
    
    
}

@end
