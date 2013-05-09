//
//  SPGetAccountInfoByUserIdRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetAccountInfoByUserIdRequest.h"
#import "SPGetAccountInfoByUserIdRequestData.h"
#import "SPGetAccountInfoResponseData.h"
#import "SPURLs.h"

@implementation SPGetAccountInfoByUserIdRequest

+ (id)requestWithRequestData:(SPGetAccountInfoByUserIdRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPGetAccountInfoByUserIdRequestData*)data delegate:(id)delegate
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
    return SP_GETACCOUNTINFOBYUSERID;
}

- (void)customizeRequest
{
    if (self.requestData.userId) {
        [self setCustomizedPostValue:self.requestData.userId forKey:@"uId"];
    }
}

- (SPGetAccountInfoResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPGetAccountInfoResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPGetAccountInfoByUserIdRequestDidFinish:)]) {
        [self.delegate SPGetAccountInfoByUserIdRequestDidFinish:self.response];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}

@end
