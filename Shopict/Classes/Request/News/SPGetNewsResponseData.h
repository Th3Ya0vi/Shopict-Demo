//
//  SPGetNewsResponseData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月19日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseResponseData.h"

@interface SPGetNewsResponseData : SPBaseResponseData

@property (nonatomic, retain) NSMutableArray *news;
@property (nonatomic, retain) NSString *nextKey;

@end
