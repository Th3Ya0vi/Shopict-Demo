//
//  SPSocialManager.h
//  SP
//
//  Created by bichenkk on 13年2月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPEnum.h"

@protocol SPSocialManagerDelegate <NSObject>

- (void)SPSocialManagerDelegateDidFinishConnectedToThirdParty:(ThirdPartyPath)thirdParty userId:(NSString *)userId errorMessage:(NSString *)errorMessage;

- (void)SPSocialManagerDelegateDidFinishConnectedToThirdParty:(ThirdPartyPath)thirdParty errorMessage:(NSString *)errorMessage;

@end

@interface SPSocialManager : NSObject

@property (assign, nonatomic) id delegate;

+ (SPSocialManager*)sharedManager;
- (BOOL)isThirdPartyConnected:(ThirdPartyPath)thirdParty;
- (void)connectToThirdParty:(ThirdPartyPath)thirdParty;
- (void)disconnectToThirdParty:(ThirdPartyPath)thirdParty;
+ (NSString *)getConnectedTwitterUserId;
+ (NSString *)getConnectedTwitterIdentifier;
+ (NSString *)getConnectedFacebookUserId;

@end
