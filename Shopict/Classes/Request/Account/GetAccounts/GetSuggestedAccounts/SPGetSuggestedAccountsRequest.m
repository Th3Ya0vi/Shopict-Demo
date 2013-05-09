//
//  SPGetSuggestedAccountsRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetSuggestedAccountsRequest.h"
#import "SPGetSuggestedAccountsRequestData.h"
#import "SPGetAccountsResponseData.h"
#import "SPURLs.h"

@implementation SPGetSuggestedAccountsRequest

+ (id)requestWithRequestData:(SPGetSuggestedAccountsRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPGetSuggestedAccountsRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        NSArray *values = [NSArray arrayWithObjects:
                           data.token,
                           nil];
        
        NSArray *keys = [NSArray arrayWithObjects:
                         @"token",
                         nil];
        self.parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
    return self;
}

- (NSString *)urlString
{
    return SP_GETSUGGESTEDACCOUNTS;
}

- (SPGetAccountsResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPGetAccountsResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPGetSuggestedAccountsRequestDidFinish:)]) {
        [self.delegate SPGetSuggestedAccountsRequestDidFinish:self.response];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}


@end
