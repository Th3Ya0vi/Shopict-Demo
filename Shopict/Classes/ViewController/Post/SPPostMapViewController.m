//
//  SPPostMapViewController.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年4月5日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPPostMapViewController.h"
#import "PostAnnotation.h"
#import "SPVenue.h"
#import "SPBaseViewController+SPViewControllerUtility.h"

@interface SPPostMapViewController ()

@end

@implementation SPPostMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.venue.latitude, self.venue.longitude);
    CLLocationDistance visibleDistance = 500; // 100 kilometers
    MKCoordinateRegion adjustedRegion = MKCoordinateRegionMakeWithDistance(coordinate, visibleDistance, visibleDistance);
    [self.mapView setRegion:adjustedRegion];
  
    PostAnnotation *annotation = [[PostAnnotation alloc]init];
    annotation.postTitle = self.venue.name;
    annotation.latitude = self.venue.latitude;
    annotation.longitude = self.venue.longitude;
    [self.mapView addAnnotation:annotation];

    self.venueNameLabel.text = self.venue.name;
    self.venueAddressLabel.text = self.venue.address;
    
    self.navigationItem.title = self.venue.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_venueNameLabel release];
    [_venueAddressLabel release];
    [_mapView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setVenueNameLabel:nil];
    [self setVenueAddressLabel:nil];
    [self setMapView:nil];
    [super viewDidUnload];
}

- (IBAction)foursquareButtonPressed:(id)sender {
    [self showWebSupportViewControllerWithUrl:self.venue.fourSquareUrl withTitle:@"FOURSQUARE"];
}

@end
