//
//  SPGetAccountInfoResponseData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseResponseData.h"

@class SPAccount;

@interface SPGetAccountInfoResponseData : SPBaseResponseData

@property (nonatomic, retain)  SPAccount *account;

@end
