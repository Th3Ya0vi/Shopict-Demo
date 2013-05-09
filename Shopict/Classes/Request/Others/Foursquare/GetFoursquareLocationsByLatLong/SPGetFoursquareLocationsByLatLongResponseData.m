//
//  SPGetFoursquareLocationsByLatLongResponseData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年4月2日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetFoursquareLocationsByLatLongResponseData.h"
#import "NSString+SBJSON.h"
#import "SPVenue.h"

@implementation SPGetFoursquareLocationsByLatLongResponseData

- (void)dealloc
{
    [_venues release];
    [super dealloc];
}

- (void)processResponseString
{
    NSDictionary *data =  [self.responseString JSONValue];
    if ([self isNormalResponse:data]) {
        
        NSDictionary *responseDictionary = [data objectForKey:@"response"];
        
        self.venues = [NSMutableArray array];
        
        NSArray *venues = [responseDictionary objectForKey:@"venues"];
        for (NSDictionary *dictionary in venues) {
            SPVenue *venue = [SPVenue venueWithFoursquareDictionary:dictionary];
            [self.venues addObject:venue];
        }
        
    }else{
        [self handleErrorResponse:data];
    }
}

- (BOOL)isNormalResponse:(id)response
{
    if (response) {
        NSDictionary *meta = [response objectForKey:@"meta"];
        NSString *errorMessage = [meta objectForKey:@"errorDetail"];
        if (!errorMessage) {
            return YES;
        }
    }
    return NO;
}

- (void)handleErrorResponse:(NSDictionary*)resposne
{
    NSDictionary *meta = [resposne objectForKey:@"meta"];
    self.error = self.errorMessage = [meta objectForKey:@"errorDetail"];
}

@end
