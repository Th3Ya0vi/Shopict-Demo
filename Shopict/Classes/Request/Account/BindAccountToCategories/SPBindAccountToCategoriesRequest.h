//
//  SPBindAccountToCategoriesRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月16日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPBaseResponseData, SPBindAccountToCategoriesRequestData;

@protocol SPBindAccountToCategoriesRequestDelegate <NSObject>

- (void)SPBindAccountToCategoriesRequestDidFinish:(SPBaseResponseData*)response;

@end

@interface SPBindAccountToCategoriesRequest : SPBaseRequest

@property (nonatomic, retain) SPBindAccountToCategoriesRequestData *requestData;

+ (id)requestWithRequestData:(SPBindAccountToCategoriesRequestData*)data delegate:(id)delegate;
@end