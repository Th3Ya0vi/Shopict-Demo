//
//  SPGetTagsByKeywordRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetTagsByKeywordRequest.h"
#import "SPSearchRequestData.h"
#import "SPGetTagsByKeywordResponseData.h"
#import "SPURLs.h"
#import "ASIFormDataRequest.h"

@implementation SPGetTagsByKeywordRequest

+ (id)requestWithRequestData:(SPSearchRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPSearchRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.requestData = data;
        NSArray *values = [NSArray arrayWithObjects:
                           data.keyword,
                           data.token,
                           nil];
        
        NSArray *keys = [NSArray arrayWithObjects:
                         @"keyword",
                         @"token",
                         nil];
        self.parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
    return self;
}

- (NSString *)urlString
{
    return SP_GETTAGSBYKEYWORD;
}

- (void)customizeRequest
{
        [self setCustomizedPostValue:self.requestData.startKey forKey:@"startKey"];
}

- (SPGetTagsByKeywordResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPGetTagsByKeywordResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPGetTagsByKeywordRequestDidFinish:startKey:)]) {
        [self.delegate SPGetTagsByKeywordRequestDidFinish:self.response startKey:self.requestData.startKey];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}


@end
