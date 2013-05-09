//
//  SPGetInstagramUserMediaRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPGetInstagramUserMediaRequestData.h"

@implementation SPGetInstagramUserMediaRequestData

+(id)dataWithNextUrl:(NSString *)nextUrl
{
    return [[[self alloc]initWithNextUrl:nextUrl]autorelease];
}

-(id)initWithNextUrl:(NSString *)nextUrl
{
    self = [super init];
    if (self) {
        self.nextUrl = nextUrl;
    }
    return self;
}

@end
