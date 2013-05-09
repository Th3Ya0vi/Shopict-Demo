//
//  SPGetAccountInfoByUsernameRequestData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequestData.h"

@interface SPGetAccountInfoByUsernameRequestData : SPBaseRequestData

@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSString *username;

+(id)dataWithToken:(NSString *)token username:(NSString *)username;
-(id)initWithToken:(NSString *)token username:(NSString *)username;

@end
