//
//  SPBindAccountToThirdPartyRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBindAccountToThirdPartyRequest.h"
#import "SPBindAccountToThirdPartyRequestData.h"
#import "SPBaseResponseData.h"
#import "SPURLs.h"

@implementation SPBindAccountToThirdPartyRequest

+ (id)requestWithRequestData:(SPBindAccountToThirdPartyRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPBindAccountToThirdPartyRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        
        self.requestData = data;
        
        NSString *path = nil;
        switch (data.path) {
            case FACEBOOK:
                path = @"1";
                break;
            case TWITTER:
                path = @"2";
                break;
            case WEIBO:
                path = @"3";
                break;
        }
        
        NSArray *values = [NSArray arrayWithObjects:
                           data.token,
                           data.thirdPartyId,
                           path,
                           nil];
        
        NSArray *keys = [NSArray arrayWithObjects:
                         @"token",
                         @"tId",
                         @"path",
                         nil];
        self.parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
    return self;
}

- (NSString *)urlString
{
    return SP_BINDACCTTOTHIRDPARTY;
}

- (SPBaseResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPBaseResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPBindAccountToThirdPartyRequestDidFinish:path:)]) {
        [self.delegate SPBindAccountToThirdPartyRequestDidFinish:self.response path:self.requestData.path];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}


@end
