//
//  PostAnnotation.m
//  WalkIn
//
//  Created by Chen Ka Kit on 11年11月7日.
//  Copyright (c) 2011年 Bi Works. All rights reserved.
//

#import "PostAnnotation.h"

@implementation PostAnnotation

@synthesize postIcon;
@synthesize latitude;
@synthesize longitude;
@synthesize postTitle;
@synthesize postSubtitle;
@synthesize index;

- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D theCoordinate;
    theCoordinate.latitude = [self latitude];
    theCoordinate.longitude = [self longitude];
    return theCoordinate;
}

- (void)dealloc
{
    [super dealloc];
}

- (NSString *)title
{
    return [self postTitle];
}

// optional
- (NSString *)subtitle
{
    return [self postSubtitle];
}


@end
