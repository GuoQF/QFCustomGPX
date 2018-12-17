//
//  LocationHelper.m
//  G_QF
//
//  Created by Fm_Qf on 15/12/22.
//  Copyright © 2015年 G_QF. All rights reserved.
//

#import "LocationHelper.h"

#import <CoreLocation/CoreLocation.h>
#import "WGS84TOGCJ02.h"

@interface LocationHelper ()<CLLocationManagerDelegate>

@end

@implementation LocationHelper
{
    CLLocationManager *_locationManager;
    
    void (^_locationBlcok)(double ,double);
    void (^_stringBlock)(NSString *);
}

+ (LocationHelper *)shareLocationHelper
{
    static LocationHelper *shareLocationHelper = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        shareLocationHelper = [[self alloc] init];
    });
    return shareLocationHelper;
}
- (instancetype)init
{
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [_locationManager requestWhenInUseAuthorization];
        }
    }
    return self;
}

- (void)getUserLocationInfomationLocationBlcok:(void (^)(double, double))locationBlock stringBlock:(void (^)(NSString *))stringBlock enableBlock:(void (^)(void))enableLocation
{
    _locationBlcok = locationBlock;
    _stringBlock = stringBlock;
        
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if (status == kCLAuthorizationStatusDenied) {
        NSLog(@"kCLAuthorizationStatusDenied ----");
    }else {
        [_locationManager requestWhenInUseAuthorization];
        [_locationManager startUpdatingLocation];
    }
}

// 定位权限变更
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways) {
        [_locationManager startUpdatingLocation];
    }
}
// 获取位置信息回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (locations.count > 0) {
        // 停止定位
        [_locationManager stopUpdatingLocation];
        // 获取位置信息
        CLLocation *currenLocation = [locations lastObject];
        // 火星坐标转换
        CLLocationCoordinate2D coord = [WGS84TOGCJ02 transformFromWGSToGCJ:[currenLocation coordinate]];
        CLLocation *newLocation = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
        
        if (_locationBlcok) {
            _locationBlcok (coord.latitude, coord.longitude);
            _locationBlcok = nil;   // 避免多次触发回调
        }

        // 地理编码
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            
            if (!error && [placemarks count] > 0) {
                NSDictionary *dict = [[placemarks firstObject] addressDictionary];
                
                if (self->_stringBlock) {
                    self->_stringBlock ([dict[@"FormattedAddressLines"] firstObject]);
                    self->_stringBlock = nil;
                }
            }
            else {
                // 地理编码出错
                NSLog(@"geocoder_Error:%@,errorDescription:%@",error,error.description);
            }
        }];
    }
}


@end


/*
 {
    "SubLocality" : "海淀区",
    "CountryCode" : "CN",
    "Name" : "西北旺镇",
    "FormattedAddressLines" : [
        "中国北京市海淀区"
    ],
    "Country" : "中国",
    "City" : "北京市"
 }
 
 {
    "SubLocality" : "洛龙区",
    "CountryCode" : "CN",
    "Name" : "洛龙区",
    "State" : "河南省",
    "FormattedAddressLines" : [
        "中国河南省洛阳市洛龙区"
    ],
    "Country" : "中国",
    "City" : "洛阳市"
 }
 
 {
    "CountryCode" : "CN",
    "Name" : "黄海",
    "FormattedAddressLines" : [
        "中国黄海"
    ],
    "Ocean" : "黄海",
    "Country" : "中国"
 }
 */
