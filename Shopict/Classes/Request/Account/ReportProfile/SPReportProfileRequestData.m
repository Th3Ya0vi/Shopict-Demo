//
//  SPReportProfileRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPReportProfileRequestData.h"

@implementation SPReportProfileRequestData

- (void)dealloc
{
    [_token release];
    [_reportUId release];
    [super dealloc];
}

+(id)dataWithToken:(NSString *)token reportUId:(NSString *)reportUId
{
    return [[[self alloc]initWithToken:token reportUId:reportUId]autorelease];
}

-(id)initWithToken:(NSString *)token reportUId:(NSString *)reportUId
{
    self = [super init];
    if (self) {
        self.token = token;
        self.reportUId = reportUId;
    }
    return self;
}

@end
