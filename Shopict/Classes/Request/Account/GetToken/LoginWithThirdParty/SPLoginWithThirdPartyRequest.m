//
//  SPLoginWithThirdPartyRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPLoginWithThirdPartyRequest.h"
#import "SPLoginWithThirdPartyRequestData.h"
#import "SPGetTokenResponseData.h"
#import "SPURLs.h"

@implementation SPLoginWithThirdPartyRequest

+ (id)requestWithRequestData:(SPLoginWithThirdPartyRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPLoginWithThirdPartyRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.requestData = data;
        
        NSString *path = nil;
        switch (self.requestData.path) {
            case FACEBOOK:
                path = @"1";
                break;
            case TWITTER:
                path = @"2";
                break;
            case WEIBO:
                path = @"3";
                break;
            default:
                break;
        }
        
        NSString *device = (data.device==IPHONE?@"1":@"2");
        
        NSLog(@"Request thirdPartyId = %@",data.thirdPartyId);
        
        NSArray *values = [NSArray arrayWithObjects:
                           path,
                           data.thirdPartyId,
                           device,
                           nil];
        
        NSArray *keys = [NSArray arrayWithObjects:
                         @"path",
                         @"tId",
                         @"device",
                         nil];
        self.parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
    return self;
}

- (NSString *)urlString
{
    return SP_LOGINWITHTHIRDPARTY;
}

- (void)customizeRequest
{
    if (self.requestData.latitude!=0) {
        [self setCustomizedPostValue:[NSString stringWithFormat:@"%f",self.requestData.latitude] forKey:@"lat"];
        [self setCustomizedPostValue:[NSString stringWithFormat:@"%f",self.requestData.longitude] forKey:@"long"];
    }
    
    [self setCustomizedPostValue:self.requestData.locale forKey:@"locale"];
    [self setCustomizedPostValue:self.requestData.country forKey:@"country"];
    [self setCustomizedPostValue:self.requestData.currency forKey:@"currency"];
}

- (SPGetTokenResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPGetTokenResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPLoginWithThirdPartyRequestDidFinish:path:)]) {
        [self.delegate SPLoginWithThirdPartyRequestDidFinish:self.response path:self.requestData.path];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}


@end
