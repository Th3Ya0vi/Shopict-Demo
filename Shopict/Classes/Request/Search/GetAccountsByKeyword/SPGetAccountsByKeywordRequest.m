//
//  SPGetAccountsByKeywordRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetAccountsByKeywordRequest.h"
#import "SPSearchRequestData.h"
#import "SPGetAccountsResponseData.h"
#import "SPURLs.h"
#import "ASIFormDataRequest.h"

@implementation SPGetAccountsByKeywordRequest

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
    return SP_GETACCOUNTSBYKEYWORD;
}

- (SPGetAccountsResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPGetAccountsResponseData responseWithString:response];
}

- (void)customizeRequest
{
        [self setCustomizedPostValue:self.requestData.startKey forKey:@"startKey"];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPGetAccountsByKeywordRequestDidFinish:startKey:)]) {
        [self.delegate SPGetAccountsByKeywordRequestDidFinish:self.response startKey:self.requestData.startKey];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}

@end
