//
//  SPGetSuggestedAccountsRequestData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequestData.h"

@interface SPGetSuggestedAccountsRequestData : SPBaseRequestData

@property (nonatomic, retain) NSString *token;

+(id)dataWithToken:(NSString *)token;
-(id)initWithToken:(NSString *)token;

@end
