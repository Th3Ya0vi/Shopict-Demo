//
//  SPGetTokenResponseData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月16日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseResponseData.h"

@class SPAccount;
@interface SPGetTokenResponseData : SPBaseResponseData

@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) SPAccount *account;

@end
