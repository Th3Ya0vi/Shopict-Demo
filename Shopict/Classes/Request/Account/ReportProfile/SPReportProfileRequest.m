//
//  SPReportProfileRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPReportProfileRequest.h"
#import "SPReportProfileRequestData.h"
#import "SPBaseResponseData.h"
#import "SPURLs.h"

@implementation SPReportProfileRequest

+ (id)requestWithRequestData:(SPReportProfileRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPReportProfileRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.requestData = data;
        NSArray *values = [NSArray arrayWithObjects:
                           data.token,
                           data.reportUId,
                           nil];
        
        NSArray *keys = [NSArray arrayWithObjects:
                         @"token",
                         @"reportUId",
                         nil];
        self.parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
    return self;
}

- (NSString *)urlString
{
    return SP_REPORTPROFILE;
}

- (SPBaseResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPBaseResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPReportProfileRequestDidFinish:)]) {
        [self.delegate SPReportProfileRequestDidFinish:self.response];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}


@end
