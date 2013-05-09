//
//  SPAppDelegate.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月14日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPAppDelegate.h"
#import "SPLocationManager.h"
#import "SPUtility.h"
#import "AFPhotoEditorController.h"
#import "SPLogInOptionViewController.h"
#import "SDImageCache.h"
#import <FacebookSDK/FacebookSDK.h>
#import "SPSocialManager.h"
#import "SPBaseNavigationController.h"
#import "UIColor+SPColorUtility.h"
#import "SPSocialManager.h"
#import "UIFont+SPFontUtility.h"
#import "SPConfigurationRequest.h"
#import "SPConfigurationRequestData.h"

@implementation SPAppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [SPUtility clearImageCacheInstantly:NO];
    [self applicationCustomization];
    
    [[UIApplication sharedApplication]setStatusBarHidden:NO];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    
    
    SPLogInOptionViewController *viewController = [[SPLogInOptionViewController alloc]initWithNibName:(IS_IPAD? @"SPLogInOptionViewController_iPad":@"SPLogInOptionViewController") bundle:nil];
    SPBaseNavigationController *navigationController = [[SPBaseNavigationController alloc]initWithRootViewController:viewController];
    navigationController.navigationBarHidden = YES;
    self.window.rootViewController = navigationController;
    [navigationController release];
    [viewController release];
    
    [self.window makeKeyAndVisible];
    [[SPLocationManager sharedManager]startUpdatingLocation];
    [self sendConfigRequest];
    
    return YES;
}

- (void)applicationCustomization
{
    //UINavigationBar customization
    if ([[UINavigationBar class]respondsToSelector:@selector(appearance)]) {
        if ([UINavigationBar instancesRespondToSelector:@selector(setShadowImage:)]) {
            [[UINavigationBar appearance] setShadowImage:[[[UIImage alloc] init]autorelease]];
            
        }
        
        [[UINavigationBar appearance]setBackgroundImage:[UIImage imageNamed:@"background_navbar"] forBarMetrics:UIBarMetricsDefault];
        NSDictionary *textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIColor whiteColor], UITextAttributeTextColor,
                                        [UIColor darkGrayColor], UITextAttributeTextShadowColor,
                                        [NSValue valueWithUIOffset:UIOffsetMake(.5f,.5f)], UITextAttributeTextShadowOffset,
                                        [UIFont themeFontWithSize:20], UITextAttributeFont,
                                        nil];
        
        [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    }
    
    //UITabBar customization
    if ([[UITabBar class]respondsToSelector:@selector(appearance)]) {
        [[UITabBar appearance]setBackgroundImage:[UIImage imageNamed:@"background_tab"]];
        [[UITabBar appearance]setSelectionIndicatorImage:[UIImage imageNamed:@"background_tabselection"]];
        [[UITabBar appearance]setSelectedImageTintColor:[UIColor whiteColor]];
    }
    
    //UIBarButtonItem customization
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                                                  [UIColor whiteColor],
                                                                                                  UITextAttributeTextColor,
                                                                                                  [UIColor clearColor],
                                                                                                  UITextAttributeTextShadowColor,
                                                                                                  [NSValue valueWithUIOffset:UIOffsetMake(0, 0)],
                                                                                                  UITextAttributeTextShadowOffset,
                                                                                                  nil]
                                                                                        forState:UIControlStateNormal];
    UIImage *image = [UIImage imageNamed:@"background_button_cancel"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 5.0, 0.0, 5.0)];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundImage:image forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    //PhotoEditor customization
    [AFPhotoEditorCustomization setOptionValue:[UIColor themeColor] forKey:@"editor.accentColor"];
    NSArray *toolsArray = [NSArray arrayWithObjects:kAFEnhance,
                           kAFEffects,
                           kAFFrames,
                           kAFStickers,
                           kAFOrientation,
                           kAFBrightness,
                           kAFContrast,
                           kAFSaturation,
                           kAFSharpness,
                           kAFDraw,
                           kAFText,
                           kAFRedeye,
                           kAFWhiten,
                           kAFBlemish,
                           kAFMeme,nil];
    [AFPhotoEditorCustomization setOptionValue:toolsArray forKey:@"editor.toolOrder"];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if (![SPUtility getStoredToken]) {
        [[SPSocialManager sharedManager]disconnectToThirdParty:FACEBOOK];
        [[SPSocialManager sharedManager]disconnectToThirdParty:TWITTER];
        [[SPSocialManager sharedManager]disconnectToThirdParty:WEIBO];
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSession.activeSession handleDidBecomeActive];
    [[SPLocationManager sharedManager]startUpdatingLocation];
    [self sendConfigRequest];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)sendConfigRequest
{
    if (![SPUtility getStoredToken]) {
        return;
    }
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    if (![SPUtility getConfigDate]) {
        [SPUtility setConfigDate:[NSDate date]];
        SPConfigurationRequestData *data = [SPConfigurationRequestData dataWithToken:[SPUtility getStoredToken] locale:[SPUtility locale] country:[SPUtility country] currency:[SPUtility currency] device:[SPUtility device] longitude:[SPUtility getDeviceLongitude] latitude:[SPUtility getDeviceLatitude]];
        SPConfigurationRequest *request = [SPConfigurationRequest requestWithRequestData:data delegate:nil];
        [request retrieve];
        return;
    }
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:[SPUtility getConfigDate]];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:[NSDate date]];
    if (!([comp1 day]   == [comp2 day] &&
        [comp1 month] == [comp2 month] &&
        [comp1 year]  == [comp2 year])) {
        [SPUtility setConfigDate:[NSDate date]];
        SPConfigurationRequestData *data = [SPConfigurationRequestData dataWithToken:[SPUtility getStoredToken] locale:[SPUtility locale] country:[SPUtility country] currency:[SPUtility currency] device:[SPUtility device] longitude:[SPUtility getDeviceLongitude] latitude:[SPUtility getDeviceLatitude]];
        SPConfigurationRequest *request = [SPConfigurationRequest requestWithRequestData:data delegate:nil];
        [request retrieve];
    }
}


@end
