//
//  SPGetCategoriesRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPGetCategoriesResponseData, SPGetCategoriesRequestData;

@protocol SPGetCategoriesRequestDelegate <NSObject>

- (void)SPGetCategoriesRequestDidFinish:(SPGetCategoriesResponseData*)response;

@end

@interface SPGetCategoriesRequest : SPBaseRequest

@property (nonatomic, retain) SPGetCategoriesRequestData *requestData;

+ (id)requestWithRequestData:(SPGetCategoriesRequestData*)data delegate:(id)delegate;

@end
