//
//  SPGetPostsByUserIdRequestData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequestData.h"
#import "SPEnum.h"

@interface SPGetPostsByUserIdRequestData : SPBaseRequestData

@property (nonatomic, retain) NSString *userId;
@property (nonatomic, assign) PostType type;
@property (nonatomic, retain) NSString *startKey;
@property (nonatomic, retain) NSString *token;

+(id)dataWithToken:(NSString *)token
            userId:(NSString *)userId
              type:(PostType)type
          startKey:(NSString *)startKey;

-(id)initWithToken:(NSString *)token
            userId:(NSString *)userId
              type:(PostType)type
          startKey:(NSString *)startKey;

@end
