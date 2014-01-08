//
//  TACSettingManager.h
//  PMCExhibitionTable
//
//  Created by Boyi on 1/8/14.
//  Copyright (c) 2014 com.nathan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TACSettingManager : NSObject

#define MAX_SPEED 1500

#define kDemoModeTime @"demonModeTime"
#define kHeight @"height"
#define kLogoOneSpeed @"LogoOneSpeed"
#define kLogoTwoSpeed @"LogoTwoSpeed"
#define kLogoThreeSpeed @"LogoThreeSpeed"
#define kLogoFourSpeed @"LogoFourSpeed"
#define kLogoFiveSpeed @"LogoFiveSpeed"
#define kLogoSixSpeed @"LogoSixSpeed"
#define kLogoSevenSpeed @"LogoSevenSpeed"

@property (nonatomic) NSUInteger DemoModeTime;
@property (nonatomic) NSUInteger Height;

@property (nonatomic) NSUInteger LogoOneSpeed;
@property (nonatomic) NSUInteger LogoTwoSpeed;
@property (nonatomic) NSUInteger LogoThreeSpeed;
@property (nonatomic) NSUInteger LogoFourSpeed;
@property (nonatomic) NSUInteger LogoFiveSpeed;
@property (nonatomic) NSUInteger LogoSixSpeed;
@property (nonatomic) NSUInteger LogoSevenSpeed;

+ (TACSettingManager *)sharedManager;

@end
