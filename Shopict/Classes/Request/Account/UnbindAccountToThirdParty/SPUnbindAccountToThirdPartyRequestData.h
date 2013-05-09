//
//  SPUnbindAccountToThirdPartyRequestData.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseRequestData.h"
#import "SPEnum.h"

@interface SPUnbindAccountToThirdPartyRequestData : SPBaseRequestData

@property (nonatomic, retain) NSString *token;
@property (nonatomic, assign) ThirdPartyPath path;

+(id)dataWithToken:(NSString *)token
              path:(ThirdPartyPath)path;

-(id)initWithToken:(NSString *)token
              path:(ThirdPartyPath)path;

@end
