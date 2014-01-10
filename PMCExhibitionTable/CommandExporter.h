//
//  CommandExporter.h
//  PMCExhibitionTable
//
//  Created by Boyi on 1/8/14.
//  Copyright (c) 2014 com.nathan. All rights reserved.
//

#ifndef PMCExhibitionTable_CommandExporter_h
#define PMCExhibitionTable_CommandExporter_h

// These tags are used to mark data stream when writing data to server
#define SET_HEIGHT_TAG 1000
#define START_ALL_TAG 1100
#define STOP_ALL_TAG 1200
#define START_MOTOR_TAG(num) 1300 + num
#define ROTATE_MOTOR_CLOCKWISE_TAG(num) 1400 + num
#define ROTATE_MOTOR_COUNTERCLOCKWISE_TAG(num) 1500 + num
#define SET_FREQUENCY_FOR_MOTOR_TAG(num) 1600 + num

#define SET_HEIGH(height) [NSString stringWithFormat:@"%s%ld\n", "HEIGHT_",height]

#define START_ALL_MOTORS_MSG @"START_ALL\n"
#define STOP_ALL_MOTORS_MSG @"STOP_ALL\n"

#define START_MOTOR(num) [NSString stringWithFormat:@"%s%ld%s\n", "M", num, "_START"]

#define ROTATE_MOTOR_CLOCKWISE(num) [NSString stringWithFormat:@"%s%ld%s\n", "M", num, "_CW"]
#define ROTATE_MOTOR_COUNTERCLOCKWISE(num) [NSString stringWithFormat:@"%s%ld%s\n", "M", num, "_CCW"]

#define SET_FREQUENCY_FOR_MOTOR_WITH_PERCENTAGE(num, percent) [NSString stringWithFormat:@"%s%ld%s%.5lf\n", "M", num, "_RPM_", percent]

#endif
