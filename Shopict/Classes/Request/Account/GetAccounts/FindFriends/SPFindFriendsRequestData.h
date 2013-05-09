//
//  SPFindFriendsRequestData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月15日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequestData.h"
#import "SPEnum.h"

@interface SPFindFriendsRequestData : SPBaseRequestData

@property (nonatomic, retain) NSString *token;
@property (nonatomic, assign) ThirdPartyPath path;
@property (nonatomic, retain) NSMutableArray *thirdPartyIds;

+(id)dataWithToken:(NSString *)token
              path:(ThirdPartyPath)path
     thirdPartyIds:(NSMutableArray *)thirdPartyIds;

-(id)initWithToken:(NSString *)token
              path:(ThirdPartyPath)path
     thirdPartyIds:(NSMutableArray *)thirdPartyIds;

@end
