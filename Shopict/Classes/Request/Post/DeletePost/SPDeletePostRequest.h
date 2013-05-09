//
//  SPDeletePostRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPBaseResponseData, SPDeletePostRequestData, SPPost;

@protocol SPDeletePostRequestDelegate <NSObject>

- (void)SPDeletePostRequestDidFinish:(SPBaseResponseData*)response post:(SPPost *)post;

@end

@interface SPDeletePostRequest : SPBaseRequest

@property (nonatomic, retain) SPDeletePostRequestData *requestData;

+ (id)requestWithRequestData:(SPDeletePostRequestData*)data delegate:(id)delegate;

@end
