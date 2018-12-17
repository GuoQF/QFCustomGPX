//
//  LocationHelper.h
//  G_QF
//
//  Created by Fm_Qf on 15/12/22.
//  Copyright © 2015年 G_QF. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocationHelper : NSObject

/**
 *  shareInstance
 *
 *  @return LocationHelper *
 */
+ (LocationHelper *)shareLocationHelper;

/**
 *  获取用户位置信息
 *
 *  @param locationBlock 用户位置 经纬度信息
 *  @param stringBlock   用户位置 省市区信息
 */
- (void)getUserLocationInfomationLocationBlcok:(void (^)(double latitude, double longitude))locationBlock stringBlock:(void (^)(NSString *FormattedAddressLines))stringBlock enableBlock:(void(^)(void))enableLocation;

@end
