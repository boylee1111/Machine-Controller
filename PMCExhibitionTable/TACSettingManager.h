//
//  TACSettingManager.h
//  PMCExhibitionTable
//
//  Created by Boyi on 1/8/14.
//  Copyright (c) 2014 com.nathan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TACSettingManager : NSObject

#define MAX_SPEED 1500.0

@property (nonatomic) NSUInteger DemoModeTime;
@property (nonatomic) NSUInteger Height;

+ (TACSettingManager *)sharedManager;

- (NSUInteger)maxSpeedOfMotor:(NSUInteger)number;
- (void)setMaxSpeedforMotor:(NSUInteger)number withSpeed:(NSUInteger)speed;

- (NSUInteger)defaultSpeedOfMotor:(NSUInteger)number;
- (CGFloat)defaultSpeedOfMotorWithPercent:(NSUInteger)number;
- (void)setDefaultSpeedforMotor:(NSUInteger)number withSpeed:(NSUInteger)speed;

@end
