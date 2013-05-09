//
//  SPGetPostsByKeywordRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPGetPostsResponseData, SPSearchRequestData;

@protocol SPGetPostsByKeywordRequestDelegate <NSObject>

- (void)SPGetPostsByKeywordRequestDidFinish:(SPGetPostsResponseData*)response startKey:(NSString *)startKey;

@end

@interface SPGetPostsByKeywordRequest : SPBaseRequest

@property (nonatomic, retain) SPSearchRequestData *requestData;

+ (id)requestWithRequestData:(SPSearchRequestData*)data delegate:(id)delegate;

@end