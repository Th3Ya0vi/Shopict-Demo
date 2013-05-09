//
//  SPAddPostFromPlaceFromPlaceRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年4月3日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPGetPostInfoResponseData, SPAddPostFromPlaceRequestData;

@protocol SPAddPostFromPlaceRequestDelegate <NSObject>

- (void)SPAddPostFromPlaceRequestDidFinish:(SPGetPostInfoResponseData*)response;

@end

@interface SPAddPostFromPlaceRequest : SPBaseRequest

@property (nonatomic, retain) SPAddPostFromPlaceRequestData *requestData;

+ (id)requestWithRequestData:(SPAddPostFromPlaceRequestData*)data delegate:(id)delegate;

@end
