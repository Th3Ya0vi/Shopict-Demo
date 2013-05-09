//
//  SPGetNewsRequest.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月19日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequest.h"

@class SPGetNewsResponseData, SPGetNewsRequestData;

@protocol SPGetNewsRequestDelegate <NSObject>

- (void)SPGetNewsRequestDidFinish:(SPGetNewsResponseData*)response startKey:(NSString *)startKey;

@end

@interface SPGetNewsRequest : SPBaseRequest

@property (nonatomic, retain) SPGetNewsRequestData *requestData;

+ (id)requestWithRequestData:(SPGetNewsRequestData*)data delegate:(id)delegate;

@end
