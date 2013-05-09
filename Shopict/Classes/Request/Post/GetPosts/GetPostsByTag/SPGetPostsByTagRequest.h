//
//  SPGetPostsByTagRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPGetPostsResponseData, SPGetPostsByTagRequestData;

@protocol SPGetPostsByTagRequestDelegate <NSObject>

- (void)SPGetPostsByTagRequestDidFinish:(SPGetPostsResponseData*)response startKey:(NSString *)startKey;

@end

@interface SPGetPostsByTagRequest : SPBaseRequest

@property (nonatomic, retain) SPGetPostsByTagRequestData *requestData;

+ (id)requestWithRequestData:(SPGetPostsByTagRequestData*)data delegate:(id)delegate;

@end
