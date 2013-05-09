//
//  SPGetInstagramUserMediaResponseData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetInstagramUserMediaResponseData.h"
#import "NSString+SBJSON.h"

@implementation SPGetInstagramUserMediaResponseData

- (void)dealloc
{
    [_nextUrl release];
    [_thumbnailUrls release];
    [_standardUrls release];
    [super dealloc];
}

- (void)processResponseString
{
    NSDictionary *data =  [self.responseString JSONValue];
    if ([self isNormalResponse:data]) {
        
        NSDictionary *pagination = [data objectForKey:@"pagination"];
        self.nextUrl = [pagination objectForKey:@"next_url"];
        if (!self.nextUrl) {
            self.lastImage = YES;
        }
        
        self.thumbnailUrls = [NSMutableArray array];
        self.standardUrls = [NSMutableArray array];
        
        NSArray *imageData = [data objectForKey:@"data"];
        for (NSDictionary *dictionary in imageData) {
            NSDictionary *imageUrl = [dictionary objectForKey:@"images"];
            NSDictionary *thumbnail = [imageUrl objectForKey:@"thumbnail"];
            NSDictionary *standard = [imageUrl objectForKey:@"standard_resolution"];
            [self.thumbnailUrls addObject:[thumbnail objectForKey:@"url"]];
            [self.standardUrls addObject:[standard objectForKey:@"url"]];
        }
        
    }else{
        [self handleErrorResponse:data];
    }
}

- (BOOL)isNormalResponse:(id)response
{
    if (response) {
        NSDictionary *meta = [response objectForKey:@"meta"];
        NSString *errorMessage = [meta objectForKey:@"error_message"];
        if (!errorMessage) {
            return YES;
        }
    }
    return NO;
}

- (void)handleErrorResponse:(NSDictionary*)resposne
{
    NSDictionary *meta = [resposne objectForKey:@"meta"];
    self.error = self.errorMessage = [meta objectForKey:@"error_message"];
}

@end