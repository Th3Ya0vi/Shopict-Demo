//
//  SPBindAccountToCategoriesRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月16日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBindAccountToCategoriesRequestData.h"

@implementation SPBindAccountToCategoriesRequestData

- (void)dealloc
{
    [_token release];
    [_categoryIds release];
    [super dealloc];
}

+(id)dataWithToken:(NSString *)token categoryIds:(NSMutableArray *)categoryIds
{
    return [[[self alloc]initWithToken:token categoryIds:categoryIds]autorelease];
}

-(id)initWithToken:(NSString *)token categoryIds:(NSMutableArray *)categoryIds
{
    self = [super init];
    if (self) {
        self.token = token;
        self.categoryIds = categoryIds;
    }
    return self;
}

@end
