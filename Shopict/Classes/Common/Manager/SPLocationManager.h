//
//  SPLocationManager.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年4月2日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface SPLocationManager : CLLocationManager <CLLocationManagerDelegate>


+ (SPLocationManager*)sharedManager;

@end
