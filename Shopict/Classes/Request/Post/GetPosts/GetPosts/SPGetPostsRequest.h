//
//  SPGetPostsRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPGetPostsResponseData, SPGetPostsRequestData;

@protocol SPGetPostsRequestDelegate <NSObject>

- (void)SPGetPostsRequestDidFinish:(SPGetPostsResponseData*)response startKey:(NSString *)startKey;

@end

@interface SPGetPostsRequest : SPBaseRequest

@property (nonatomic, retain) SPGetPostsRequestData *requestData;

+ (id)requestWithRequestData:(SPGetPostsRequestData*)data delegate:(id)delegate;

@end
