//
//  SPGetTagsByKeywordResponseData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseResponseData.h"

@interface SPGetTagsByKeywordResponseData : SPBaseResponseData

@property (nonatomic, retain) NSMutableArray *tags;
@property (nonatomic, retain) NSString *nextKey;

@end
