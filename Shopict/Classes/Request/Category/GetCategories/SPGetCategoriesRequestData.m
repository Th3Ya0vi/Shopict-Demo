//
//  SPGetCategoriesRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetCategoriesRequestData.h"

@implementation SPGetCategoriesRequestData

- (void)dealloc
{
    [_categoryId release];
    [_token release];
    [super dealloc];
}

+(id)dataWithToken:(NSString*)token
        categoryId:(NSString *)categoryId
{
    return [[[self alloc]initWithToken:token categoryId:categoryId]autorelease];
}

-(id)initWithToken:(NSString*)token
        categoryId:(NSString *)categoryId
{
    self = [super init];
    if (self) {
        self.token = token;
        if (!categoryId) {
            self.categoryId = @"0";
        }else{
            self.categoryId = categoryId;
        }
    }
    return self;
}


@end
