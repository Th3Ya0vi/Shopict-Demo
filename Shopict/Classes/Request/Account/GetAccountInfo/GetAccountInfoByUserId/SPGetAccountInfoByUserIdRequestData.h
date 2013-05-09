//
//  SPGetAccountInfoByUserIdRequestData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequestData.h"

@interface SPGetAccountInfoByUserIdRequestData : SPBaseRequestData

@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *token;

+(id)dataWithToken:(NSString *)token userId:(NSString *)userId;
-(id)initWithToken:(NSString *)token userId:(NSString *)userId;

@end
