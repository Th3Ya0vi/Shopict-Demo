//
//  SPFacebookAccount.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月19日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SPFacebookAccount : NSObject

@property (nonatomic, retain) NSString *userId;
@property (nonatomic, retain) NSString *username;

+ (id)facebookAccountWithUserId:(NSString *)userId username:(NSString *)username;

@end
