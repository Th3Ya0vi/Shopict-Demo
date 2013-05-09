//
//  SPUtility.h
//  SP
//
//  Created by bichenkk on 13年2月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SPEnum.h"

@class SPAccount;
@interface SPUtility : NSObject

+ (SPUtility*)Instance;

+ (NSString *) locale;
+ (NSString *) country;
+ (NSString *) currency;
+ (DeviceType ) device;

+ (void)clearImageCacheInstantly:(BOOL)instant;

//set Token
+ (void)setStoredToken:(NSString *)token;
+ (NSString *)getStoredToken;

//set Account
+ (void)setStoredAccountId:(NSString *)accountId;
+ (NSString *)getStoredAccountId;

+ (void)setConfigDate:(NSDate *)configDate;
+ (NSDate *)getConfigDate;

+ (void)setDeviceLatitude:(float)latitude;
+ (float)getDeviceLatitude;
+ (void)setDeviceLongitude:(float)longitude;
+ (float)getDeviceLongitude;

+ (void)addSearchHistory:(NSString *)token type:(SearchType)searchType;
+ (NSMutableArray *)getSearchHistoryWithType:(SearchType)searchType;
+ (void)clearSearchHistory;

+ (BOOL)isMainFeedGrid;
+ (void)setIsMainFeedGrid:(BOOL)isGrid;

+ (BOOL)isToSaveInCameraRoll;
+ (void)setToSavedInCameraRoll:(BOOL)save;

+ (BOOL)isToShareOnFacebook;
+ (void)setToShareOnFacebook:(BOOL)share;

+ (BOOL)isToShareOnTwitter;
+ (void)setToShareOnTwitter:(BOOL)share;

+ (BOOL)isInitialLaunch;
+ (void)isInitialLaunch:(BOOL)initialLaunch;

+ (void)postSPNotificationWithName:(NotificationType)type dictionary:(NSDictionary *)dictionary;

+ (BOOL)shouldReload;


@end
