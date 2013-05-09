//
//  SPReportPostRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月26日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPReportPostRequest.h"
#import "SPReportPostRequestData.h"
#import "SPBaseResponseData.h"
#import "SPURLs.h"
#import "SPPost.h"

@implementation SPReportPostRequest

+ (id)requestWithRequestData:(SPReportPostRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPReportPostRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.requestData = data;
        
        NSString *type = nil;
        switch (data.type) {
            case INAPPROPRIATECONTENT:
                type = @"0";
                break;
            case NOTAVAILABLE:
                type = @"1";
                break;
            case INCORRECTPRICE:
                type = @"2";
                break;
            case BADIMAGE:
                type = @"3";
                break;
            default:
                break;
        }
        
        NSArray *values = [NSArray arrayWithObjects:
                           data.token,
                           data.post.postId,
                           type,
                           nil];
        
        NSArray *keys = [NSArray arrayWithObjects:
                         @"token",
                         @"pId",
                         @"type",
                         nil];
        self.parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
    return self;
}

- (NSString *)urlString
{
    return SP_REPORTPOST;
}

- (SPBaseResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPBaseResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPReportPostRequestDidFinish:)]) {
        [self.delegate SPReportPostRequestDidFinish:self.response];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}
@end
