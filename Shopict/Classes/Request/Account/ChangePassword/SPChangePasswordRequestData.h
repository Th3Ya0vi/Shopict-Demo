//
//  SPChangePasswordRequestData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequestData.h"

@interface SPChangePasswordRequestData : SPBaseRequestData

@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSString *oldPassword;
@property (nonatomic, retain) NSString *changedPassword;

+(id)dataWithToken:(NSString *)token oldPassword:(NSString *)oldPassword newPassword:(NSString *)oldPassword;
-(id)initWithToken:(NSString *)token oldPassword:(NSString *)oldPassword newPassword:(NSString *)oldPassword;

@end
