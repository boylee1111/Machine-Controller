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

#define kLogoOneMaxSpeed @"LogoOneMaxSpeed"
#define kLogoTwoMaxSpeed @"LogoTwoMaxSpeed"
#define kLogoThreeMaxSpeed @"LogoThreeMaxSpeed"
#define kLogoFourMaxSpeed @"LogoFourMaxSpeed"
#define kLogoFiveMaxSpeed @"LogoFiveMaxSpeed"
#define kLogoSixMaxSpeed @"LogoSixMaxSpeed"
#define kLogoSevenMaxSpeed @"LogoSevenMaxSpeed"

#define kLogoOneDefaultSpeed @"LogoOneDefaultSpeed"
#define kLogoTwoDefaultSpeed @"LogoTwoDefaultSpeed"
#define kLogoThreeDefaultSpeed @"LogoThreeDefaultSpeed"
#define kLogoFourDefaultSpeed @"LogoFourDefaultSpeed"
#define kLogoFiveDefaultSpeed @"LogoFiveDefaultSpeed"
#define kLogoSixDefaultSpeed @"LogoSixDefaultSpeed"
#define kLogoSevenDefaultSpeed @"LogoSevenDefaultSpeed"

#define DEFAULT_DEMO_MODE_TIME 120
#define DEFAULT_HEIGHT 170
#define DEFAULT_SPEED 500

@interface TACSettingManager ()

@property (nonatomic, weak) NSUserDefaults *ud;

@property (nonatomic) NSUInteger LogoOneMaxSpeed;
@property (nonatomic) NSUInteger LogoTwoMaxSpeed;
@property (nonatomic) NSUInteger LogoThreeMaxSpeed;
@property (nonatomic) NSUInteger LogoFourMaxSpeed;
@property (nonatomic) NSUInteger LogoFiveMaxSpeed;
@property (nonatomic) NSUInteger LogoSixMaxSpeed;
@property (nonatomic) NSUInteger LogoSevenMaxSpeed;

@property (nonatomic) NSUInteger LogoOneDefaultSpeed;
@property (nonatomic) NSUInteger LogoTwoDefaultSpeed;
@property (nonatomic) NSUInteger LogoThreeDefaultSpeed;
@property (nonatomic) NSUInteger LogoFourDefaultSpeed;
@property (nonatomic) NSUInteger LogoFiveDefaultSpeed;
@property (nonatomic) NSUInteger LogoSixDefaultSpeed;
@property (nonatomic) NSUInteger LogoSevenDefaultSpeed;

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
        
        self.LogoOneMaxSpeed   == 0 ? self.LogoOneMaxSpeed   = MAX_SPEED : self.LogoOneMaxSpeed;
        self.LogoTwoMaxSpeed   == 0 ? self.LogoTwoMaxSpeed   = MAX_SPEED : self.LogoTwoMaxSpeed;
        self.LogoThreeMaxSpeed == 0 ? self.LogoThreeMaxSpeed = MAX_SPEED : self.LogoThreeMaxSpeed;
        self.LogoFourMaxSpeed  == 0 ? self.LogoFourMaxSpeed  = MAX_SPEED : self.LogoFourMaxSpeed;
        self.LogoFiveMaxSpeed  == 0 ? self.LogoFiveMaxSpeed  = MAX_SPEED : self.LogoFiveMaxSpeed;
        self.LogoSixMaxSpeed   == 0 ? self.LogoSixMaxSpeed   = MAX_SPEED : self.LogoSixMaxSpeed;
        self.LogoSevenMaxSpeed == 0 ? self.LogoSevenMaxSpeed = MAX_SPEED : self.LogoSevenMaxSpeed;
        
        self.LogoOneDefaultSpeed   == 0 ? self.LogoOneDefaultSpeed   = DEFAULT_SPEED : self.LogoOneDefaultSpeed;
        self.LogoTwoDefaultSpeed   == 0 ? self.LogoTwoDefaultSpeed   = DEFAULT_SPEED : self.LogoTwoDefaultSpeed;
        self.LogoThreeDefaultSpeed == 0 ? self.LogoThreeDefaultSpeed = DEFAULT_SPEED : self.LogoThreeDefaultSpeed;
        self.LogoFourDefaultSpeed  == 0 ? self.LogoFourDefaultSpeed  = DEFAULT_SPEED : self.LogoFourDefaultSpeed;
        self.LogoFiveDefaultSpeed  == 0 ? self.LogoFiveDefaultSpeed  = DEFAULT_SPEED : self.LogoFiveDefaultSpeed;
        self.LogoSixDefaultSpeed   == 0 ? self.LogoSixDefaultSpeed   = DEFAULT_SPEED : self.LogoSixDefaultSpeed;
        self.LogoSevenDefaultSpeed == 0 ? self.LogoSevenDefaultSpeed = DEFAULT_SPEED : self.LogoSevenDefaultSpeed;
    }
    return self;
}

- (NSUInteger)maxSpeedOfMotor:(NSUInteger)number
{
    if (number == 1) return self.LogoOneMaxSpeed;
    if (number == 2) return self.LogoTwoMaxSpeed;
    if (number == 3) return self.LogoThreeMaxSpeed;
    if (number == 4) return self.LogoFourMaxSpeed;
    if (number == 5) return self.LogoFiveMaxSpeed;
    if (number == 6) return self.LogoSixMaxSpeed;
    if (number == 7) return self.LogoSevenMaxSpeed;
    
    return MAX_SPEED;
}

- (void)setMaxSpeedforMotor:(NSUInteger)number withSpeed:(NSUInteger)speed
{
    if (number == 1) self.LogoOneMaxSpeed = speed;
    if (number == 2) self.LogoTwoMaxSpeed = speed;
    if (number == 3) self.LogoThreeMaxSpeed = speed;
    if (number == 4) self.LogoFourMaxSpeed = speed;
    if (number == 5) self.LogoFiveMaxSpeed = speed;
    if (number == 6) self.LogoSixMaxSpeed = speed;
    if (number == 7) self.LogoSevenMaxSpeed = speed;
}

- (NSUInteger)defaultSpeedOfMotor:(NSUInteger)number
{
    if (number == 1) return self.LogoOneDefaultSpeed;
    if (number == 2) return self.LogoTwoDefaultSpeed;
    if (number == 3) return self.LogoThreeDefaultSpeed;
    if (number == 4) return self.LogoFourDefaultSpeed;
    if (number == 5) return self.LogoFiveDefaultSpeed;
    if (number == 6) return self.LogoSixDefaultSpeed;
    if (number == 7) return self.LogoSevenDefaultSpeed;
    return DEFAULT_SPEED;
}

- (CGFloat)defaultSpeedOfMotorWithPercent:(NSUInteger)number
{
    NSUInteger speed = DEFAULT_SPEED;
    
    if (number == 1) speed = self.LogoOneDefaultSpeed;
    if (number == 2) speed = self.LogoTwoDefaultSpeed;
    if (number == 3) speed = self.LogoThreeDefaultSpeed;
    if (number == 4) speed = self.LogoFourDefaultSpeed;
    if (number == 5) speed = self.LogoFiveDefaultSpeed;
    if (number == 6) speed = self.LogoSixDefaultSpeed;
    if (number == 7) speed = self.LogoSevenDefaultSpeed;
    
    return speed / MAX_SPEED;
}

- (void)setDefaultSpeedforMotor:(NSUInteger)number withSpeed:(NSUInteger)speed
{
    if (number == 1) self.LogoOneDefaultSpeed = speed;
    if (number == 2) self.LogoTwoDefaultSpeed = speed;
    if (number == 3) self.LogoThreeDefaultSpeed = speed;
    if (number == 4) self.LogoFourDefaultSpeed = speed;
    if (number == 5) self.LogoFiveDefaultSpeed = speed;
    if (number == 6) self.LogoSixDefaultSpeed = speed;
    if (number == 7) self.LogoSevenDefaultSpeed = speed;
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

#pragma mark Max Speed

- (NSUInteger)LogoOneMaxSpeed
{
    NSNumber *num = [self.ud objectForKey:kLogoOneMaxSpeed];
    return [num unsignedIntegerValue];
}

- (NSUInteger)LogoTwoMaxSpeed
{
    NSNumber *num = [self.ud objectForKey:kLogoTwoMaxSpeed];
    return [num unsignedIntegerValue];
}

- (NSUInteger)LogoThreeMaxSpeed
{
    NSNumber *num = [self.ud objectForKey:kLogoThreeMaxSpeed];
    return [num unsignedIntegerValue];
}

- (NSUInteger)LogoFourMaxSpeed
{
    NSNumber *num = [self.ud objectForKey:kLogoFourMaxSpeed];
    return [num unsignedIntegerValue];
}

- (NSUInteger)LogoFiveMaxSpeed
{
    NSNumber *num = [self.ud objectForKey:kLogoFiveMaxSpeed];
    return [num unsignedIntegerValue];
}

- (NSUInteger)LogoSixMaxSpeed
{
    NSNumber *num = [self.ud objectForKey:kLogoSixMaxSpeed];
    return [num unsignedIntegerValue];
}

- (NSUInteger)LogoSevenMaxSpeed
{
    NSNumber *num = [self.ud objectForKey:kLogoSevenMaxSpeed];
    return [num unsignedIntegerValue];
}

#pragma mark Default Speed

- (NSUInteger)LogoOneDefaultSpeed
{
    NSNumber *num = [self.ud objectForKey:kLogoOneDefaultSpeed];
    return [num unsignedIntegerValue];
}

- (NSUInteger)LogoTwoDefaultSpeed
{
    NSNumber *num = [self.ud objectForKey:kLogoTwoDefaultSpeed];
    return [num unsignedIntegerValue];
}

- (NSUInteger)LogoThreeDefaultSpeed
{
    NSNumber *num = [self.ud objectForKey:kLogoThreeDefaultSpeed];
    return [num unsignedIntegerValue];
}

- (NSUInteger)LogoFourDefaultSpeed
{
    NSNumber *num = [self.ud objectForKey:kLogoFourDefaultSpeed];
    return [num unsignedIntegerValue];
}

- (NSUInteger)LogoFiveDefaultSpeed
{
    NSNumber *num = [self.ud objectForKey:kLogoFiveDefaultSpeed];
    return [num unsignedIntegerValue];
}

- (NSUInteger)LogoSixDefaultSpeed
{
    NSNumber *num = [self.ud objectForKey:kLogoSixDefaultSpeed];
    return [num unsignedIntegerValue];
}

- (NSUInteger)LogoSevenDefaultSpeed
{
    NSNumber *num = [self.ud objectForKey:kLogoSevenDefaultSpeed];
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

#pragma mark Max Speed

- (void)setLogoOneMaxSpeed:(NSUInteger)LogoOneSpeed
{
    [self.ud setObject:@(LogoOneSpeed) forKey:kLogoOneMaxSpeed];
    [self.ud synchronize];
}

- (void)setLogoTwoMaxSpeed:(NSUInteger)LogoTwoSpeed
{
    [self.ud setObject:@(LogoTwoSpeed) forKey:kLogoTwoMaxSpeed];
    [self.ud synchronize];
}

- (void)setLogoThreeMaxSpeed:(NSUInteger)LogoThreeSpeed
{
    [self.ud setObject:@(LogoThreeSpeed) forKey:kLogoThreeMaxSpeed];
    [self.ud synchronize];
}

- (void)setLogoFourMaxSpeed:(NSUInteger)LogoFourSpeed
{
    [self.ud setObject:@(LogoFourSpeed) forKey:kLogoFourMaxSpeed];
    [self.ud synchronize];
}

- (void)setLogoFiveMaxSpeed:(NSUInteger)LogoFiveSpeed
{
    [self.ud setObject:@(LogoFiveSpeed) forKey:kLogoFiveMaxSpeed];
    [self.ud synchronize];
}

- (void)setLogoSixMaxSpeed:(NSUInteger)LogoSixSpeed
{
    [self.ud setObject:@(LogoSixSpeed) forKey:kLogoSixMaxSpeed];
    [self.ud synchronize];
}

- (void)setLogoSevenMaxSpeed:(NSUInteger)LogoSevenSpeed
{
    [self.ud setObject:@(LogoSevenSpeed) forKey:kLogoSevenMaxSpeed];
    [self.ud synchronize];
}

#pragma mark Default Speed

- (void)setLogoOneDefaultSpeed:(NSUInteger)LogoOneSpeed
{
    [self.ud setObject:@(LogoOneSpeed) forKey:kLogoOneDefaultSpeed];
    [self.ud synchronize];
}

- (void)setLogoTwoDefaultSpeed:(NSUInteger)LogoTwoSpeed
{
    [self.ud setObject:@(LogoTwoSpeed) forKey:kLogoTwoDefaultSpeed];
    [self.ud synchronize];
}

- (void)setLogoThreeDefaultSpeed:(NSUInteger)LogoThreeSpeed
{
    [self.ud setObject:@(LogoThreeSpeed) forKey:kLogoThreeDefaultSpeed];
    [self.ud synchronize];
}

- (void)setLogoFourDefaultSpeed:(NSUInteger)LogoFourSpeed
{
    [self.ud setObject:@(LogoFourSpeed) forKey:kLogoFourDefaultSpeed];
    [self.ud synchronize];
}

- (void)setLogoFiveDefaultSpeed:(NSUInteger)LogoFiveSpeed
{
    [self.ud setObject:@(LogoFiveSpeed) forKey:kLogoFiveDefaultSpeed];
    [self.ud synchronize];
}

- (void)setLogoSixDefaultSpeed:(NSUInteger)LogoSixSpeed
{
    [self.ud setObject:@(LogoSixSpeed) forKey:kLogoSixDefaultSpeed];
    [self.ud synchronize];
}

- (void)setLogoSevenDefaultSpeed:(NSUInteger)LogoSevenSpeed
{
    [self.ud setObject:@(LogoSevenSpeed) forKey:kLogoSevenDefaultSpeed];
    [self.ud synchronize];
}

@end
