//
//  SPSubscribeAccountRequestData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequestData.h"
#import "SPEnum.h"

@class SPAccount;
@interface SPSubscribeAccountRequestData : SPBaseRequestData

@property (nonatomic, retain) SPAccount *account;
@property (nonatomic, retain) NSString *token;
@property (nonatomic, assign) BOOL type;

+ (id)dataWithAccount:(SPAccount *)account
                token:(NSString *)token
            subscribe:(BOOL)subscribe;

- (id)initWithAccount:(SPAccount *)account
                token:(NSString *)token
            subscribe:(BOOL)subscribe;

@end
