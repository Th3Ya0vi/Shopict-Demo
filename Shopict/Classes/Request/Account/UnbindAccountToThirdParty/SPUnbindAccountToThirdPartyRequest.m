//
//  SPUnbindAccountToThirdPartyRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPUnbindAccountToThirdPartyRequest.h"
#import "SPUnbindAccountToThirdPartyRequestData.h"
#import "SPBaseResponseData.h"
#import "SPURLs.h"

@implementation SPUnbindAccountToThirdPartyRequest

+ (id)requestWithRequestData:(SPUnbindAccountToThirdPartyRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPUnbindAccountToThirdPartyRequestData*)data delegate:(id)delegate
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
                           path,
                           nil];
        
        NSArray *keys = [NSArray arrayWithObjects:
                         @"token",
                         @"path",
                         nil];
        self.parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
    return self;
}

- (NSString *)urlString
{
    return SP_UNBINDACCTTOTHIRDPARTY;
}

- (SPBaseResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPBaseResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPUnbindAccountToThirdPartyRequestDidFinish:path:)]) {
        [self.delegate SPUnbindAccountToThirdPartyRequestDidFinish:self.response path:self.requestData.path];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}


@end
