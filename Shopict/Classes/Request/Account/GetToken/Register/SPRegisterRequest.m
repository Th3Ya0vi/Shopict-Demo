//
//  SPRegisterRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPRegisterRequest.h"
#import "SPRegisterRequestData.h"
#import "SPGetTokenResponseData.h"
#import "SPURLs.h"
#import "NSString+SPStringUtility.h"
#import "SPEnum.h"

@implementation SPRegisterRequest

+ (id)requestWithRequestData:(SPRegisterRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPRegisterRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.requestData = data;
        NSString *device = (data.device==IPHONE?@"1":@"2");
        NSArray *values = [NSArray arrayWithObjects:
                  data.email,
                  data.name,
                  [data.username lowercaseString],
                  [data.password md5],
                  device,
                  nil];
        NSArray *keys = [NSArray arrayWithObjects:
                @"email",
                @"name",
                @"username",
                @"password",
                @"device",
                nil];
        self.parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
    return self;
}

- (NSString *)urlString
{
    return SP_REGISTER;
}

- (void)customizeRequest
{
    if (self.requestData.profilePic) {
        [self setCustomizedImageData:UIImageJPEGRepresentation(self.requestData.profilePic, 0.5) forKey:@"profilePic"];
    }
    
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
    if ([self.delegate respondsToSelector:@selector(SPRegisterRequestDidFinish:)]) {
        [self.delegate SPRegisterRequestDidFinish:self.response];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}


@end
