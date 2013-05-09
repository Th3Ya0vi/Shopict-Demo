//
//  SPUtility.m
//  SP
//
//  Created by bichenkk on 13年2月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPUtility.h"
#import <CommonCrypto/CommonDigest.h>
#import "SDImageCache.h"

@implementation SPUtility

static SPUtility *_instance = nil;

+(SPUtility *)Instance
{
    if (!_instance) {
        _instance = [[SPUtility alloc]init];
    }
    return _instance;
}

- (void)dealloc
{
    [super dealloc];
}

+(NSString *) locale
{
    NSString * locale = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLog(@"LOCALE = %@",locale);
    return locale;
}

+(NSString *) country
{
    NSLocale *theLocale = [NSLocale currentLocale];
    NSString *country = [theLocale objectForKey:NSLocaleCountryCode];
    NSLog(@"COUNTRY = %@",country);
    return country;
}

+(NSString *) currency
{
    NSLocale *theLocale = [NSLocale currentLocale];
    NSString *currency = [theLocale objectForKey:NSLocaleCurrencyCode];
    NSLog(@"CURRENCY = %@",currency);
    return currency;
}

+(DeviceType ) device
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return IPHONE;
    } else {
        return IPAD;
    }
}

#pragma mark - SDWebImageCache methods

+ (void)clearImageCacheInstantly:(BOOL)instant
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if (instant) {
        [[SDImageCache sharedImageCache] clearMemory];
        NSDate *now = [NSDate date];
        [def setObject:now forKey:@"lastClearCacheDate"];
        [def synchronize];
    }else{
        NSDate *lastClearCacheDate = [def objectForKey:@"lastClearCacheDate"];
        if (lastClearCacheDate) {
            NSDate *now = [NSDate date];
            double deltaSeconds = fabs([lastClearCacheDate timeIntervalSinceDate:now]);
            double deltaMinutes = deltaSeconds / 60.0f;
            
            //Clear cache 2days once
            if (deltaMinutes > (24 * 60 * 2)){
                [[SDImageCache sharedImageCache] clearMemory];
                [def setObject:now forKey:@"lastClearCacheDate"];
                [def synchronize];
            }
        }else{
            NSDate *now = [NSDate date];
            [def setObject:now forKey:@"lastClearCacheDate"];
            [def synchronize];
        }
    }
}

//Call this method everytime when request is sent
+ (BOOL)shouldReload
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSDate *lastActiveDate = [def objectForKey:@"lastActiveDate"];
    if (lastActiveDate) {
        NSDate *now = [NSDate date];
        double deltaSeconds = fabs([lastActiveDate timeIntervalSinceDate:now]);
        double deltaMinutes = deltaSeconds / 60.0f;
        //Reload All 1 hours once
        if (deltaMinutes > (60)){
            [def setObject:now forKey:@"lastActiveDate"];
            [def synchronize];
            return YES;
        }
    }
    NSDate *now = [NSDate date];
    [def setObject:now forKey:@"lastActiveDate"];
    [def synchronize];
    return NO;
}

#pragma mark - Token methods

+ (void)setStoredToken:(NSString *)token
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:token forKey:@"token"];
    [def synchronize];
}

+ (NSString *)getStoredToken
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:@"token"];
}

//set Account
+ (void)setStoredAccountId:(NSString *)accountId
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:accountId forKey:@"accountId"];
    [def synchronize];
}
+ (NSString *)getStoredAccountId
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:@"accountId"];
}

+ (void)setConfigDate:(NSDate *)configDate
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:configDate forKey:@"configDate"];
    [def synchronize];
}

+ (NSDate *)getConfigDate
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:@"configDate"];
}

+ (void)setDeviceLatitude:(float)latitude
{
    NSNumber *number = [NSNumber numberWithFloat:latitude];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:number forKey:@"Devicelatitude"];
    [def synchronize];
}
+ (float)getDeviceLatitude
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [[def objectForKey:@"Devicelatitude"]floatValue];
}

+ (void)setDeviceLongitude:(float)longitude
{
    NSNumber *number = [NSNumber numberWithFloat:longitude];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:number forKey:@"Devicelongitude"];
    [def synchronize];
}
+ (float)getDeviceLongitude
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [[def objectForKey:@"Devicelongitude"]floatValue];
}

+ (void)setIsMainFeedGrid:(BOOL)isGrid
{
    NSNumber *number = [NSNumber numberWithBool:isGrid];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:number forKey:@"isMainFeedGrid"];
    [def synchronize];
}

+ (BOOL)isMainFeedGrid
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if (![def objectForKey:@"isMainFeedGrid"]) {
        return NO;
    }
    return [[def objectForKey:@"isMainFeedGrid"]boolValue];
}

+ (void)setToSavedInCameraRoll:(BOOL)save
{
    NSNumber *number = [NSNumber numberWithBool:save];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:number forKey:@"toSavePhoto"];
    [def synchronize];
}

+ (BOOL)isToSaveInCameraRoll
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if (![def objectForKey:@"toSavePhoto"]) {
        return YES;
    }
    return [[def objectForKey:@"toSavePhoto"]boolValue];
}

+ (void)setToShareOnFacebook:(BOOL)share
{
    NSNumber *number = [NSNumber numberWithBool:share];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:number forKey:@"toShareOnFacebook"];
    [def synchronize];
}

+ (BOOL)isToShareOnFacebook
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [[def objectForKey:@"toShareOnFacebook"]boolValue];
}

+ (void)setToShareOnTwitter:(BOOL)share
{
    NSNumber *number = [NSNumber numberWithBool:share];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:number forKey:@"toShareOnTwitter"];
    [def synchronize];
}

+ (BOOL)isToShareOnTwitter
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [[def objectForKey:@"toShareOnTwitter"]boolValue];
}

+ (BOOL)isInitialLaunch
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if (![def objectForKey:@"initialLaunch"]) {
        return YES;
    }
    return [[def objectForKey:@"initialLaunch"]boolValue];
}

+ (void)isInitialLaunch:(BOOL)initialLaunch
{
    NSNumber *number = [NSNumber numberWithBool:initialLaunch];
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:number forKey:@"initialLaunch"];
    [def synchronize];
}

+ (void)postSPNotificationWithName:(NotificationType)type dictionary:(NSDictionary *)dictionary{
    NSString *name = nil;
    switch (type) {
        case POSTDIDADD:
            name = @"POSTDIDADD";
            break;
        case POSTDIDDELETE:
            name = @"POSTDIDDELETE";
            break;
        case POSTDIDWANT:
            name = @"POSTDIDWANT";
            break;
        case POSTDIDUNWANT:
            name = @"POSTDIDUNWANT";
            break;
        case POSTDIDCOMMENT:
            name = @"POSTDIDCOMMENT";
            break;
        case ACCOUNTDIDFOLLOW:
            name = @"ACCOUNTDIDFOLLOW";
            break;
        case ACCOUNTDIDUNFOLLOW:
            name = @"ACCOUNTDIDUNFOLLOW";
            break;
        case ACCOUNTDIDUPDATE:
            name = @"ACCOUNTDIDUPDATE";
            break;
        case POSTDIDREPOST:
            name = @"POSTDIDREPOST";
            break;
        case POSTDIDUNREPOST:
            name = @"POSTDIDUNREPOST";
            break;
        case ACCOUNTDIDUPDATEFORPOST:
            name = @"ACCOUNTDIDUPDATEFORPOST";
            break;
        default:
            break;
    }
    
    if (name) {
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter postNotificationName:name
                                          object:nil
                                        userInfo:dictionary];
    }
}

+ (void)addSearchHistory:(NSString *)record type:(SearchType)searchType
{
//    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//    NSString *key = nil;
//    switch (searchType) {
//        case PRODUCT:
//            key = @"searchHistoryProduct";
//            break;
//        case PEOPLE:
//            key = @"searchHistoryPeople";
//            break;
//        case TAG:
//            key = @"searchHistoryHashTag";
//            break;
//        default:
//            break;
//    }
//    NSMutableArray *array = [def objectForKey:key];
//    if (!array) {
//        array = [NSMutableArray array];
//    }else{
//        for (NSString *string in array) {
//            if ([string isEqualToString:record]) {
//                [array removeObject:string];
//            }
//        }
//    }
//    [array insertObject:record atIndex:0];
//    [def setObject:array forKey:key];
//    [def synchronize];
}

+ (NSMutableArray *)getSearchHistoryWithType:(SearchType)searchType
{
//    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
//    NSString *key = nil;
//    switch (searchType) {
//        case PRODUCT:
//            key = @"searchHistoryProduct";
//            break;
//        case PEOPLE:
//            key = @"searchHistoryPeople";
//            break;
//        case TAG:
//            key = @"searchHistoryHashTag";
//            break;
//        default:
//            break;
//    }
//    return [def objectForKey:key];
    return nil;
}

+ (void)clearSearchHistory
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:nil forKey:@"searchHistoryProduct"];
    [def setObject:nil forKey:@"searchHistoryPeople"];
    [def setObject:nil forKey:@"searchHistoryHashTag"];
    [def synchronize];
}


@end
