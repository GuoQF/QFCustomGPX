//
//  WGS84TOGCJ02.h
//  G_QF
//
//  Created by Fm_Qf on 15-1-5.
//  Copyright (c) 2015年 G_QF. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface WGS84TOGCJ02 : NSObject

/** 判断是否不在中国 */
+(BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location;

/** 将WGS-84转为GCJ-02 */
+(CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc;

@end
