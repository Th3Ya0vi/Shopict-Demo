//
//  SPGetCategoriesRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetCategoriesRequest.h"
#import "SPGetCategoriesRequestData.h"
#import "SPGetCategoriesResponseData.h"
#import "SPURLs.h"

@implementation SPGetCategoriesRequest

+ (id)requestWithRequestData:(SPGetCategoriesRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPGetCategoriesRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.requestData = data;
        NSArray *values = [NSArray arrayWithObjects:
                           data.token,
                           data.categoryId,
                           @"1",
                           nil];
        
        NSArray *keys = [NSArray arrayWithObjects:
                         @"token",
                         @"cId",
                         @"cType",
                         nil];
        self.parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
    return self;
}

- (NSString *)urlString
{
    return SP_GETCATEGORY;
}

- (SPGetCategoriesResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPGetCategoriesResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPGetCategoriesRequestDidFinish:)]) {
        [self.delegate SPGetCategoriesRequestDidFinish:self.response];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}


@end
