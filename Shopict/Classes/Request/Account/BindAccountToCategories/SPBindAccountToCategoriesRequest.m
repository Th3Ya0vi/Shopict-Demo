//
//  SPBindAccountToCategoriesRequest.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月16日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBindAccountToCategoriesRequest.h"
#import "SPBindAccountToCategoriesRequestData.h"
#import "SPBaseResponseData.h"
#import "SPURLs.h"
#import "NSObject+SBJSON.h"

@implementation SPBindAccountToCategoriesRequest

+ (id)requestWithRequestData:(SPBindAccountToCategoriesRequestData*)data delegate:(id)delegate
{
    return [[[self alloc]initWithRequestData:data delegate:delegate]autorelease];
}

- (id)initWithRequestData:(SPBindAccountToCategoriesRequestData*)data delegate:(id)delegate
{
    self = [super initWithDelegate:delegate];
    if (self) {
        self.requestData = data;
        NSMutableArray *categoryIdsINT = [NSMutableArray array];
        for (NSString *categoryIdString in data.categoryIds) {
            NSNumber *categoryNUM = [NSNumber numberWithInt:[categoryIdString intValue]];
            [categoryIdsINT addObject:categoryNUM];
        }
        NSString * categoryIdsJSON = [NSString stringWithFormat:@"{\"categoryIDs\":%@}",[categoryIdsINT JSONRepresentation]];
        NSLog(@"%@",categoryIdsJSON);
        NSArray *values = [NSArray arrayWithObjects:
                           data.token,
                           categoryIdsJSON,
                           nil];
        
        NSArray *keys = [NSArray arrayWithObjects:
                         @"token",
                         @"categoryIDsJson",
                         nil];
        self.parameters = [NSDictionary dictionaryWithObjects:values forKeys:keys];
    }
    return self;
}

- (NSString *)urlString
{
    return SP_BINDACCTTOCATEGORY;
}

- (SPBaseResponseData *)responseHandlerWithResponse:(NSString*)response
{
    return [SPBaseResponseData responseWithString:response];
}

- (void)responseToDelegate
{
    if ([self.delegate respondsToSelector:@selector(SPBindAccountToCategoriesRequestDidFinish:)]) {
        [self.delegate SPBindAccountToCategoriesRequestDidFinish:self.response];
    }
}

- (void)dealloc
{
    [_requestData release];
    [super dealloc];
}

@end
