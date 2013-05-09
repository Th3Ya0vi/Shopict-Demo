//
//  SPWantPostRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPWantPostRequestData.h"

@implementation SPWantPostRequestData

- (void)dealloc
{
    [_post release];
    [_token release];
    [super dealloc];
}

+ (id)dataWithPost:(SPPost *)post
             token:(NSString *)token
              want:(BOOL)want
{
    return [[[self alloc]initWithPost:post token:token want:want]autorelease];
}

- (id)initWithPost:(SPPost *)post
             token:(NSString *)token
              want:(BOOL)want
{
    self = [super init];
    if (self) {
        self.post = post;
        self.token = token;
        self.type = want;
    }
    return self;
}


@end
