//
//  SPGetPostsByUserIdRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetPostsByUserIdRequest.h"
#import "SPGetPostsByUserIdRequestData.h"
#import "SPGetPostsResponseData.h"
#import "SPURLs.h"
#import "SPEnum.h"
#import "ASIFormDataRequest.h"

@implementation SPGetPostsByUserIdRequest

+ (id)requestWithRequestData:(SPGetPostsByUserIdRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPGetPostsByUserIdRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.requestData = data;
        NSString *type = nil;
        switch (data.type) {
            case SHARE:
                type = @"0";
                break;
            case WANT:
                type = @"1";
                break;
            default:
                break;
        }
        
        NSArray *values = [NSArray arrayWithObjects:
                           type,
                           data.token,
                           nil];
        
        NSArray *keys = [NSArray arrayWithObjects:
                         @"type",
                         @"token",
                         nil];
        self.parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
    return self;
}

- (NSString *)urlString
{
    return SP_GETPOSTSBYUSERID;
}

- (void)customizeRequest
{
    [self setCustomizedPostValue:self.requestData.startKey forKey:@"startKey"];
    [self.request setPostValue:self.requestData.userId forKey:@"uId"];
}

- (SPGetPostsResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPGetPostsResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPGetPostsByUserIdRequestDidFinish:type:startKey:)]) {
        [self.delegate SPGetPostsByUserIdRequestDidFinish:self.response type:self.requestData.type startKey:self.requestData.startKey];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}

@end
