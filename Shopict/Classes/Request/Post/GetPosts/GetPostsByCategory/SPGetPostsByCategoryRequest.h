//
//  SPGetPostsByCategoryRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPGetPostsResponseData, SPGetPostsByCategoryRequestData;

@protocol SPGetPostsByCategoryRequestDelegate <NSObject>

- (void)SPGetPostsByCategoryRequestDidFinish:(SPGetPostsResponseData*)response startKey:(NSString *)startKey;

@end

@interface SPGetPostsByCategoryRequest : SPBaseRequest

@property (nonatomic, retain) SPGetPostsByCategoryRequestData *requestData;

+ (id)requestWithRequestData:(SPGetPostsByCategoryRequestData*)data delegate:(id)delegate;

@end

