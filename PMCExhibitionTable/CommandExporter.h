//
//  CommandExporter.h
//  PMCExhibitionTable
//
//  Created by Boyi on 1/8/14.
//  Copyright (c) 2014 com.nathan. All rights reserved.
//

#ifndef PMCExhibitionTable_CommandExporter_h
#define PMCExhibitionTable_CommandExporter_h

#define SET_HEIGH(height) [NSString stringWithFormat:@"%s%ld\n", "HEIGHT_",height]

#define START_ALL_MOTORS_MSG @"START_ALL\n"
#define STOP_ALL_MOTORS_MSG @"STOP_ALL\n"

#define START_MOTOR(num) [NSString stringWithFormat:@"%s%d%s\n", "M", num, "_START"]

#define ROTATE_MOTOR_CLOCKWISE(num) [NSString stringWithFormat:@"%s%d%s\n", "M", num, "_CW"]
#define ROTATE_MOTOR_COUNTERCLOCKWISE(num) [NSString stringWithFormat:@"%s%d%s\n", "M", num, "_CCW"]

#define SET_FREQUENCY_FOR_MOTOR_WITH_PERCENTAGE(num, percent) [NSString stringWithFormat:@"%s%d%s%lf\n", "M", num, "_RPM_", percent]

#endif
