//
//  TACSettingManager.m
//  PMCExhibitionTable
//
//  Created by Boyi on 1/8/14.
//  Copyright (c) 2014 com.nathan. All rights reserved.
//

#import "TACSettingManager.h"

#define kDemoModeTime @"demonModeTime"
#define kHeight @"height"
#define kLogoOneSpeed @"LogoOneSpeed"
#define kLogoTwoSpeed @"LogoTwoSpeed"
#define kLogoThreeSpeed @"LogoThreeSpeed"
#define kLogoFourSpeed @"LogoFourSpeed"
#define kLogoFiveSpeed @"LogoFiveSpeed"
#define kLogoSixSpeed @"LogoSixSpeed"
#define kLogoSevenSpeed @"LogoSevenSpeed"

#define DEFAULT_DEMO_MODE_TIME 120
#define DEFAULT_HEIGHT 170
#define DEFAULT_SPEED 500

@interface TACSettingManager ()

@property (nonatomic, weak) NSUserDefaults *ud;

@property (nonatomic) NSUInteger LogoOneSpeed;
@property (nonatomic) NSUInteger LogoTwoSpeed;
@property (nonatomic) NSUInteger LogoThreeSpeed;
@property (nonatomic) NSUInteger LogoFourSpeed;
@property (nonatomic) NSUInteger LogoFiveSpeed;
@property (nonatomic) NSUInteger LogoSixSpeed;
@property (nonatomic) NSUInteger LogoSevenSpeed;

@end

@implementation TACSettingManager

+ (TACSettingManager *)sharedManager
{
    static dispatch_once_t onceToken;
    __strong static id _sharedManager = nil;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] initWithUserDefault];
    });
    return _sharedManager;
}

- (id)initWithUserDefault
{
    if (self = [super init]) {
        self.ud = [NSUserDefaults standardUserDefaults];

        self.DemoModeTime == 0 ? self.DemoModeTime = DEFAULT_DEMO_MODE_TIME : self.DemoModeTime;
        self.Height == 0 ? self.Height = DEFAULT_HEIGHT : self.Height;
        self.LogoOneSpeed   == 0 ? self.LogoOneSpeed   = DEFAULT_SPEED : self.LogoOneSpeed;
        self.LogoTwoSpeed   == 0 ? self.LogoTwoSpeed   = DEFAULT_SPEED : self.LogoTwoSpeed;
        self.LogoThreeSpeed == 0 ? self.LogoThreeSpeed = DEFAULT_SPEED : self.LogoThreeSpeed;
        self.LogoFourSpeed  == 0 ? self.LogoFourSpeed  = DEFAULT_SPEED : self.LogoFourSpeed;
        self.LogoFiveSpeed  == 0 ? self.LogoFiveSpeed  = DEFAULT_SPEED : self.LogoFiveSpeed;
        self.LogoSixSpeed   == 0 ? self.LogoSixSpeed   = DEFAULT_SPEED : self.LogoSixSpeed;
        self.LogoSevenSpeed == 0 ? self.LogoSevenSpeed = DEFAULT_SPEED : self.LogoSevenSpeed;
    }
    return self;
}

- (NSUInteger)speedOfMotor:(NSUInteger)number
{
    if (number == 1) return self.LogoOneSpeed;
    if (number == 2) return self.LogoTwoSpeed;
    if (number == 3) return self.LogoThreeSpeed;
    if (number == 4) return self.LogoFourSpeed;
    if (number == 5) return self.LogoFiveSpeed;
    if (number == 6) return self.LogoSixSpeed;
    if (number == 7) return self.LogoSevenSpeed;
    
    return DEFAULT_SPEED;
}

- (CGFloat)speedOfMotorWithPercent:(NSUInteger)number
{
    NSUInteger speed = DEFAULT_SPEED;
    
    if (number == 1) speed = self.LogoOneSpeed;
    if (number == 2) speed = self.LogoTwoSpeed;
    if (number == 3) speed = self.LogoThreeSpeed;
    if (number == 4) speed = self.LogoFourSpeed;
    if (number == 5) speed = self.LogoFiveSpeed;
    if (number == 6) speed = self.LogoSixSpeed;
    if (number == 7) speed = self.LogoSevenSpeed;
    
    return DEFAULT_SPEED / MAX_SPEED;
}

- (void)setSpeedforMotor:(NSUInteger)number withSpeed:(NSUInteger)speed
{
    if (number == 1) self.LogoOneSpeed = speed;
    if (number == 2) self.LogoTwoSpeed = speed;
    if (number == 3) self.LogoThreeSpeed = speed;
    if (number == 4) self.LogoFourSpeed = speed;
    if (number == 5) self.LogoFiveSpeed = speed;
    if (number == 6) self.LogoSixSpeed = speed;
    if (number == 7) self.LogoSevenSpeed = speed;
}

#pragma mark - Getter

- (NSUInteger)DemoModeTime
{
    NSNumber *num = [self.ud objectForKey:kDemoModeTime];
    return [num unsignedIntegerValue];
}

- (NSUInteger)Height
{
    NSNumber *num = [self.ud objectForKey:kHeight];
    return [num unsignedIntegerValue];
}

- (NSUInteger)LogoOneSpeed
{
    NSNumber *num = [self.ud objectForKey:kLogoOneSpeed];
    return [num unsignedIntegerValue];
}

- (NSUInteger)LogoTwoSpeed
{
    NSNumber *num = [self.ud objectForKey:kLogoTwoSpeed];
    return [num unsignedIntegerValue];
}

- (NSUInteger)LogoThreeSpeed
{
    NSNumber *num = [self.ud objectForKey:kLogoThreeSpeed];
    return [num unsignedIntegerValue];
}

- (NSUInteger)LogoFourSpeed
{
    NSNumber *num = [self.ud objectForKey:kLogoFourSpeed];
    return [num unsignedIntegerValue];
}

- (NSUInteger)LogoFiveSpeed
{
    NSNumber *num = [self.ud objectForKey:kLogoFiveSpeed];
    return [num unsignedIntegerValue];
}

- (NSUInteger)LogoSixSpeed
{
    NSNumber *num = [self.ud objectForKey:kLogoSixSpeed];
    return [num unsignedIntegerValue];
}

- (NSUInteger)LogoSevenSpeed
{
    NSNumber *num = [self.ud objectForKey:kLogoSevenSpeed];
    return [num unsignedIntegerValue];
}

#pragma mark - Setter

- (void)setDemoModeTime:(NSUInteger)DemoModeTime
{
    [self.ud setObject:@(DemoModeTime) forKey:kDemoModeTime];
    [self.ud synchronize];
}

- (void)setHeight:(NSUInteger)Height
{
    [self.ud setObject:@(Height) forKey:kHeight];
    [self.ud synchronize];
}

- (void)setLogoOneSpeed:(NSUInteger)LogoOneSpeed
{
    [self.ud setObject:@(LogoOneSpeed) forKey:kLogoOneSpeed];
    [self.ud synchronize];
}

- (void)setLogoTwoSpeed:(NSUInteger)LogoTwoSpeed
{
    [self.ud setObject:@(LogoTwoSpeed) forKey:kLogoTwoSpeed];
    [self.ud synchronize];
}

- (void)setLogoThreeSpeed:(NSUInteger)LogoThreeSpeed
{
    [self.ud setObject:@(LogoThreeSpeed) forKey:kLogoThreeSpeed];
    [self.ud synchronize];
}

- (void)setLogoFourSpeed:(NSUInteger)LogoFourSpeed
{
    [self.ud setObject:@(LogoFourSpeed) forKey:kLogoFourSpeed];
    [self.ud synchronize];
}

- (void)setLogoFiveSpeed:(NSUInteger)LogoFiveSpeed
{
    [self.ud setObject:@(LogoFiveSpeed) forKey:kLogoFiveSpeed];
    [self.ud synchronize];
}

- (void)setLogoSixSpeed:(NSUInteger)LogoSixSpeed
{
    [self.ud setObject:@(LogoSixSpeed) forKey:kLogoSixSpeed];
    [self.ud synchronize];
}

- (void)setLogoSevenSpeed:(NSUInteger)LogoSevenSpeed
{
    [self.ud setObject:@(LogoSevenSpeed) forKey:kLogoSevenSpeed];
    [self.ud synchronize];
}

@end
