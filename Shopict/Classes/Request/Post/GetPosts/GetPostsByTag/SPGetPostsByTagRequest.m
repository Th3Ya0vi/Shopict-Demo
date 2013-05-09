//
//  SPGetPostsByTagRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetPostsByTagRequest.h"
#import "SPGetPostsByTagRequestData.h"
#import "SPGetPostsResponseData.h"
#import "SPURLs.h"
#import "ASIFormDataRequest.h"

@implementation SPGetPostsByTagRequest

+ (id)requestWithRequestData:(SPGetPostsByTagRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPGetPostsByTagRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.requestData = data;
        NSArray *values = [NSArray arrayWithObjects:
                           data.tag,
                           data.token,
                           nil];
        
        NSArray *keys = [NSArray arrayWithObjects:
                         @"tag",
                         @"token",
                         nil];
        self.parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
    return self;
}

- (NSString *)urlString
{
    return SP_GETPOSTSBTCATEGORY;
}

- (void)customizeRequest
{
        [self setCustomizedPostValue:self.requestData.startKey forKey:@"startKey"];
}

- (SPGetPostsResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPGetPostsResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPGetPostsByTagRequestDidFinish:startKey:)]) {
        [self.delegate SPGetPostsByTagRequestDidFinish:self.response startKey:self.requestData.startKey];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}


@end
