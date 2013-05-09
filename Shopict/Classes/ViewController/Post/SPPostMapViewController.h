//
//  SPPostMapViewController.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年4月5日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseTabbedViewController.h"
#import <MapKit/MapKit.h>

@class SPVenue;
@interface SPPostMapViewController : SPBaseTabbedViewController

@property (retain, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) SPVenue *venue;
@property (retain, nonatomic) IBOutlet UILabel *venueNameLabel;
@property (retain, nonatomic) IBOutlet UILabel *venueAddressLabel;

@end
