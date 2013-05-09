//
//  SPRepostRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPGetPostInfoResponseData, SPRepostRequestData, SPPost;

@protocol SPRepostRequestDelegate <NSObject>

- (void)SPRepostRequestDidFinish:(SPGetPostInfoResponseData*)response originalPost:(SPPost *)originalPost;

@end

@interface SPRepostRequest : SPBaseRequest

@property (nonatomic, retain) SPRepostRequestData *requestData;

+ (id)requestWithRequestData:(SPRepostRequestData*)data delegate:(id)delegate;

@end
