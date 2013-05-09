//
//  SBLogoutRequest.m
//  ShopbookAPI
//
//  Created by BCKK on 12年11月10日.
//  Copyright (c) 2012年 biworks. All rights reserved.
//

#import "SPLogoutRequest.h"
#import "SPLogoutRequestData.h"
#import "SPBaseResponseData.h"
#import "SPURLs.h"

@implementation SPLogoutRequest

+ (id)requestWithRequestData:(SPLogoutRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPLogoutRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.requestData = data;
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
    return SP_LOGOUT;
}

- (SPBaseResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPBaseResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPLogoutRequestDidFinish:)]) {
        [self.delegate SPLogoutRequestDidFinish:self.response];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}

@end
