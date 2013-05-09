//
//  SPReportPostRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月26日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPReportPostRequestData.h"
#import "SPPost.h"

@implementation SPReportPostRequestData

- (void)dealloc
{
    [_post release];
    [_token release];
    [super dealloc];
}

+ (id)dataWithPost:(SPPost *)post
             token:(NSString *)token
              type:(ReportPostWithURLType)type
{
    return [[[self alloc]initWithPost:post token:token type:type]autorelease];
}

- (id)initWithPost:(SPPost *)post
             token:(NSString *)token
              type:(ReportPostWithURLType)type
{
    self = [super init];
    if (self) {
        self.post = post;
        self.token = token;
        self.type = type;
    }
    return self;
}


@end
