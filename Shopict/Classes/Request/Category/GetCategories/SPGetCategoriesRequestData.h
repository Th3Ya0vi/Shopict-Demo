//
//  SPGetCategoriesRequestData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequestData.h"
#import "SPEnum.h"

@interface SPGetCategoriesRequestData : SPBaseRequestData

@property (nonatomic, retain) NSString *categoryId;
@property (nonatomic, retain) NSString *token;

+(id)dataWithToken:(NSString*)token
        categoryId:(NSString *)categoryId;


-(id)initWithToken:(NSString*)token
        categoryId:(NSString *)categoryId;

@end
