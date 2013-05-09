//
//  SBLogoutRequest.h
//  ShopbookAPI
//
//  Created by BCKK on 12年11月10日.
//  Copyright (c) 2012年 biworks. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPBaseResponseData, SPLogoutRequestData;

@protocol SPLogoutRequestDelegate <NSObject>

- (void)SPLogoutRequestDidFinish:(SPBaseResponseData*)response;

@end

@interface SPLogoutRequest : SPBaseRequest

@property (nonatomic, retain) SPLogoutRequestData *requestData;

+ (id)requestWithRequestData:(SPLogoutRequestData*)data delegate:(id)delegate;

@end
