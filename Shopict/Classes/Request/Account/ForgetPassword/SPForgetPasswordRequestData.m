//
//  SPForgetPasswordRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPForgetPasswordRequestData.h"

@implementation SPForgetPasswordRequestData

- (void)dealloc
{
    [_email release];
    [super dealloc];
}

+(id)dataWithEmail:(NSString *)email
{
    return [[[self alloc]initWithEmail:email]autorelease];
}

-(id)initWithEmail:(NSString *)email
{
    self = [super init];
    if (self) {
        self.email = email;
    }
    return self;
}

@end
