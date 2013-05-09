//
//  SPGetPostsRequestData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequestData.h"

@interface SPGetPostsRequestData : SPBaseRequestData

@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSString *startKey;

+(id)dataWithToken:(NSString *)token
          startKey:(NSString *)startKey;
-(id)initWithToken:(NSString *)token
          startKey:(NSString *)startKey;

@end
