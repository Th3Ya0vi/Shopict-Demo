//
//  SPGetPostsByCategoryRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetPostsByCategoryRequestData.h"

@implementation SPGetPostsByCategoryRequestData

- (void)dealloc
{
    [_categoryId release];
    [_startKey release];
    [super dealloc];
}

+(id)dataWithToken:(NSString *)token
        categoryId:(NSString *)categoryId
          startKey:(NSString *)startKey
{
    return [[[self alloc]initWithToken:token categoryId:categoryId startKey:startKey]autorelease];
}

-(id)initWithToken:(NSString *)token
        categoryId:(NSString *)categoryId
          startKey:(NSString *)startKey
{
    self = [super init];
    if (self) {
        self.token = token;
        self.categoryId = categoryId;
        self.startKey = startKey;
    }
    return self;
}

@end
