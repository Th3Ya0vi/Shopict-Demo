//
//  SBLogoutRequestData.h
//  ShopbookAPI
//
//  Created by BCKK on 12年11月10日.
//  Copyright (c) 2012年 biworks. All rights reserved.
//

#import "SPBaseRequestData.h"

@interface SPLogoutRequestData : SPBaseRequestData

@property (nonatomic, retain) NSString *token;

+(id)dataWithToken:(NSString *)token;
-(id)initWithToken:(NSString *)token;

@end
