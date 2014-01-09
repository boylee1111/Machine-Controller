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
#define LIMIT_SPEED 10.0
#define MIN_SPEED_FOR_MAX_SPEED 100.0
#define MIN_SPEED 0.0

#define MIN_DEMO_MODE_TIME 30
#define MAX_DEMO_MODE_TIME 600

#define MIN_HEIGHT 120
#define MAX_HEIGHT 200

@property (nonatomic) NSUInteger DemoModeTime; // 单位为秒
@property (nonatomic) NSUInteger Height; // 单位为厘米

+ (TACSettingManager *)sharedManager;

- (NSUInteger)maxSpeedOfMotor:(NSUInteger)number;
- (void)setMaxSpeedforMotor:(NSUInteger)number withSpeed:(NSUInteger)speed;

- (NSUInteger)defaultSpeedOfMotor:(NSUInteger)number;
- (CGFloat)defaultSpeedOfMotorWithPercent:(NSUInteger)number;
- (void)setDefaultSpeedforMotor:(NSUInteger)number withSpeed:(NSUInteger)speed;

@end
