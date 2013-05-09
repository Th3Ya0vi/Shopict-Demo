//
//  SPChangePasswordRequestData.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPChangePasswordRequestData.h"
#import "NSString+SPStringUtility.h"

@implementation SPChangePasswordRequestData

- (void)dealloc
{
    [_token release];
    [_changedPassword release];
    [_oldPassword release];
    [super dealloc];
}

+(id)dataWithToken:(NSString *)token oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword
{
    return [[[self alloc]initWithToken:token oldPassword:oldPassword newPassword:newPassword]autorelease];
}

-(id)initWithToken:(NSString *)token oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword
{
    self = [super init];
    if (self) {
        self.token = token;
        self.oldPassword = [oldPassword md5];
        self.changedPassword = [newPassword md5];
    }
    return self;
}


@end
