//
//  TACSettingManager.m
//  PMCExhibitionTable
//
//  Created by Boyi on 1/8/14.
//  Copyright (c) 2014 com.nathan. All rights reserved.
//

#import "TACSettingManager.h"

@interface TACSettingManager ()

@property (nonatomic, weak) NSUserDefaults *ud;

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
    }
    return self;
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
