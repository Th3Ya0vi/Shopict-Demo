//
//  SPGetSubscriptionAccountsRequestData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequestData.h"
#import "SPEnum.h"

@interface SPGetSubscriptionAccountsRequestData : SPBaseRequestData

@property (nonatomic, retain) NSString *token;
@property (nonatomic, assign) FollowType type;
@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *startKey;

+(id)dataWithToken:(NSString *)token userId:(NSString *)userId follow:(FollowType)follow startKey:(NSString *)startKey;
-(id)initWithToken:(NSString *)token userId:(NSString *)userId follow:(FollowType)follow startKey:(NSString *)startKey;

@end
