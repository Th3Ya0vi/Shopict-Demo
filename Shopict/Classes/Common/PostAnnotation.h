//
//  PostAnnotation.h
//  WalkIn
//
//  Created by Chen Ka Kit on 11年11月7日.
//  Copyright (c) 2011年 Bi Works. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface PostAnnotation : NSObject <MKAnnotation>
{
    UIImage *postIcon;
    double latitude;
    double longitude;
    NSString *postTitle;
    NSString *postSubtitle;
    
    int index;
}

@property (nonatomic, retain) UIImage *postIcon;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;
@property (nonatomic) int index;
@property (nonatomic, retain) NSString *postTitle;
@property (nonatomic, retain) NSString *postSubtitle;

- (NSString *)title;

// optional
- (NSString *)subtitle;

@end
