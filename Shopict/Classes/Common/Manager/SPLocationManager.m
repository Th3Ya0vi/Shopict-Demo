//
//  SPLocationManager.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年4月2日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPLocationManager.h"
#import "SPUtility.h"

@interface SPLocationManager(Private)<CLLocationManagerDelegate>
@end

@implementation SPLocationManager

static SPLocationManager *_instance = nil;

+(SPLocationManager *)sharedManager 
{
    if (!_instance) {
        _instance = [[SPLocationManager alloc]init];
        _instance.delegate = _instance;
        _instance.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    }
    return _instance;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    if (manager.location.coordinate.latitude != 0) {
        [manager stopUpdatingLocation];
        [SPUtility setDeviceLatitude:manager.location.coordinate.latitude];
        [SPUtility setDeviceLongitude:manager.location.coordinate.longitude];
    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    if (manager.location.coordinate.latitude != 0) {
        [manager stopUpdatingLocation];
        NSLog(@"latitude %f",manager.location.coordinate.latitude);
        NSLog(@"longitude %f",manager.location.coordinate.longitude);
        [SPUtility setDeviceLatitude:manager.location.coordinate.latitude];
        [SPUtility setDeviceLongitude:manager.location.coordinate.longitude];
    }
    //    CLGeocoder *geocoder = [[CLGeocoder alloc] init] ;
    //    [geocoder reverseGeocodeLocation:manager.location
    //                   completionHandler:^(NSArray *placemarks, NSError *error) {
    //                       NSLog(@"reverseGeocodeLocation:completionHandler: Completion Handler called!");
    //
    //                       if (error){
    //                           NSLog(@"Geocode failed with error: %@", error);
    //                           return;
    //                       }
    //
    //                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
    //
    //                       NSLog(@"placemark.ISOcountryCode %@",placemark.ISOcountryCode);
    //                       if (placemark.ISOcountryCode) {
    //                           [manager stopUpdatingLocation];
    //                       }
    //                       NSLog(@"placemark.country %@",placemark.country);
    //                       NSLog(@"placemark.postalCode %@",placemark.postalCode);
    //                       NSLog(@"placemark.administrativeArea %@",placemark.administrativeArea);
    //                       NSLog(@"placemark.locality %@",placemark.locality);
    //                       NSLog(@"placemark.subLocality %@",placemark.subLocality);
    //                       NSLog(@"placemark.subThoroughfare %@",placemark.subThoroughfare);
    //                   }];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    [manager stopUpdatingLocation];
}


@end
