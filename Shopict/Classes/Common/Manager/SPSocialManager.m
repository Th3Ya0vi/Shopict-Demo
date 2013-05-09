//
//  SPSocialManager.m
//  SP
//
//  Created by bichenkk on 13年2月15日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPSocialManager.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Accounts/Accounts.h>
#import "SPBaseNavigationController.h"
#import "SPBaseViewController.h"
#import "SPTwitterAccountFeedViewController.h"

@implementation SPSocialManager

static SPSocialManager *_instance = nil;

+(SPSocialManager *)sharedManager
{
    if (!_instance) {
        _instance = [[SPSocialManager alloc]init];
    }
    return _instance;
}

- (void)connectToThirdParty:(ThirdPartyPath)thirdParty
{
    switch (thirdParty) {
        case FACEBOOK:
            [self connectFacebook];
            break;
        case TWITTER:
            [self connectTwitter];
            break;
        default:
            break;
    }
}

- (void)disconnectToThirdParty:(ThirdPartyPath)thirdParty
{
    switch (thirdParty) {
        case FACEBOOK:
            [self disconnectFacebook];
            break;
        case TWITTER:
            [self disconnectTwitter];
            break;
        default:
            break;
    }
}

- (void)connectFacebook{
    [FBSession openActiveSessionWithReadPermissions:[NSArray arrayWithObjects:@"email",nil]
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                      if (!error) {
                                          [self getFacebookUserId];
                                      }else{
                                          [self returnData:FACEBOOK userId:nil errorMessage:[NSString stringWithFormat:@"%@",error]];
                                      }
                                  }];
}

- (void)disconnectFacebook
{
    [[FBSession activeSession] closeAndClearTokenInformation];
    [SPSocialManager setConnectedFacebookUserId:nil];
}

- (void)getFacebookUserId
{
    if (FBSession.activeSession.isOpen) {
        [[FBRequest requestForMe] startWithCompletionHandler:
         ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
             if (!error) {
                 [SPSocialManager setConnectedFacebookUserId:[user objectForKey:@"id"]];
                 [self returnData:FACEBOOK userId:[user objectForKey:@"id"] errorMessage:nil];
             }else{
                 [self returnData:FACEBOOK userId:nil errorMessage:[NSString stringWithFormat:@"%@",error]];
             }
         }];
    }
}

- (void)connectTwitter{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    if ([accountStore respondsToSelector:@selector(requestAccessToAccountsWithType:options:completion:)]) {
        [accountStore requestAccessToAccountsWithType:(ACAccountType *)accountType options:nil completion:^(BOOL granted, NSError *error) {
            if (error) {
                [[SPSocialManager sharedManager]disconnectTwitter];
                [self returnData:TWITTER userId:nil errorMessage:@"There are no Twitter accounts configured. You can add or create a Twitter account in Settings."];
            }else{
                if(granted) {
                    NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
                    if (accountsArray.count > 0) {
                        if (accountsArray.count == 1) {
                            NSString *userID = [[[accountsArray objectAtIndex:0] valueForKey:@"properties"] valueForKey:@"user_id"];
                            [SPSocialManager setConnectedTwitterUserId:userID];
                            ACAccount *account = [accountsArray objectAtIndex:0];
                            [SPSocialManager setConnectedTwitterIdentifier:account.identifier];
                            [self returnData:TWITTER userId:userID errorMessage:nil];
                        }else{
                            SPTwitterAccountFeedViewController *viewController = [[SPTwitterAccountFeedViewController alloc]initWithNibName:@"SPTwitterAccountFeedViewController" bundle:nil];
                            SPBaseNavigationController *navigationController = [[SPBaseNavigationController alloc]initWithRootViewController:viewController];
                            viewController.delegate = self;
                            viewController.accounts = accountsArray;
                            SPBaseViewController *delegateViewController = (SPBaseViewController*)self.delegate;
                            [delegateViewController.navigationController presentViewController:navigationController animated:YES completion:nil];
                            [viewController release];
                            [navigationController release];
                        }
                    }else{
                        [[SPSocialManager sharedManager]disconnectTwitter];
                        [self returnData:TWITTER userId:nil errorMessage:@"There are no Twitter accounts configured. You can add or create a Twitter account in Settings."];
                    }
                }else{
                    [[SPSocialManager sharedManager]disconnectTwitter];
                    [self returnData:TWITTER userId:nil errorMessage:@"Twitter Access is denied. We need access to your Twitter account to continue. You can enable access in Privacy Settings."];
                }
            }
        }];
    }else{
        [accountStore requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error){
            if (error) {
                [[SPSocialManager sharedManager]disconnectTwitter];
                [self returnData:TWITTER userId:nil errorMessage:@"There are no Twitter accounts configured. You can add or create a Twitter account in Settings."];
            }else{
                if(granted) {
                    NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
                    if (accountsArray.count > 0) {
                        if (accountsArray.count == 1) {
                            NSString *userID = [[[accountsArray objectAtIndex:0] valueForKey:@"properties"] valueForKey:@"user_id"];
                            
                            [SPSocialManager setConnectedTwitterUserId:userID];
                            ACAccount *account = [accountsArray objectAtIndex:0];
                            [SPSocialManager setConnectedTwitterIdentifier:account.identifier];
                            [self returnData:TWITTER userId:userID errorMessage:nil];
                        }else{
                            SPTwitterAccountFeedViewController *viewController = [[SPTwitterAccountFeedViewController alloc]initWithNibName:@"SPTwitterAccountFeedViewController" bundle:nil];
                            SPBaseNavigationController *navigationController = [[SPBaseNavigationController alloc]initWithRootViewController:viewController];
                            viewController.delegate = self;
                            viewController.accounts = accountsArray;
                            SPBaseViewController *delegateViewController = (SPBaseViewController*)self.delegate;
                            [delegateViewController.navigationController presentViewController:navigationController animated:YES completion:nil];
                            [viewController release];
                            [navigationController release];
                        }
                    }else{
                        [[SPSocialManager sharedManager]disconnectTwitter];
                        [self returnData:TWITTER userId:nil errorMessage:@"There are no Twitter accounts configured. You can add or create a Twitter account in Settings."];
                    }
                }else{
                    [[SPSocialManager sharedManager]disconnectTwitter];
                    [self returnData:TWITTER userId:nil errorMessage:@"Twitter Access is denied. We need access to your Twitter account to continue. You can enable access in Privacy Settings."];
                }
            }
        }];
    }
    [accountStore release];
}

- (void)disconnectTwitter
{
    [SPSocialManager setConnectedTwitterUserId:nil];
    [SPSocialManager setConnectedTwitterIdentifier:nil];
}

- (void)SPTwitterAccountFeedViewControllerDidSelectAccount:(ACAccount *)account
{
    if (account) {
        NSString *userID = [[account valueForKey:@"properties"] valueForKey:@"user_id"];
        [SPSocialManager setConnectedTwitterUserId:userID];
        [SPSocialManager setConnectedTwitterIdentifier:account.identifier];
        [self returnData:TWITTER userId:userID errorMessage:nil];
    }else{
        [self.delegate hideHUDLoadingView];
    }
}

- (void)returnData:(ThirdPartyPath)thirdParty userId:(NSString *)userId errorMessage:(NSString *)errorMessage
{
    if ([self.delegate respondsToSelector:@selector(SPSocialManagerDelegateDidFinishConnectedToThirdParty:userId:errorMessage:)]) {
        [self.delegate SPSocialManagerDelegateDidFinishConnectedToThirdParty:thirdParty userId:userId errorMessage:errorMessage];
    }
}

+ (NSString *)getConnectedTwitterUserId
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:@"twitterUserId"];
}

+ (void)setConnectedTwitterUserId:(NSString *)twitterUserId
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:twitterUserId forKey:@"twitterUserId"];
    [def synchronize];
}


+ (NSString *)getConnectedTwitterIdentifier
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:@"twitterIdentifier"];
}

+ (void)setConnectedTwitterIdentifier:(NSString *)twitterIdentifier
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:twitterIdentifier forKey:@"twitterIdentifier"];
    [def synchronize];
}

+ (NSString *)getConnectedFacebookUserId
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    return [def objectForKey:@"facebookUserId"];
}

+ (void)setConnectedFacebookUserId:(NSString *)FacebookUserId
{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:FacebookUserId forKey:@"facebookUserId"];
    [def synchronize];
}

- (BOOL)isThirdPartyConnected:(ThirdPartyPath)thirdParty
{
    switch (thirdParty) {
        case FACEBOOK:
            if ([FBSession activeSession].isOpen && [SPSocialManager getConnectedFacebookUserId]) {
                return YES;
            }
            break;
        case TWITTER:
            if ([SPSocialManager getConnectedTwitterIdentifier] && [SPSocialManager getConnectedTwitterUserId]) {
                NSString *accountIdentifier = [SPSocialManager getConnectedTwitterIdentifier];
                ACAccountStore *accountStore = [[ACAccountStore alloc]init];
                ACAccount *account = [accountStore accountWithIdentifier:accountIdentifier];
                [accountStore release];
                if (account) {
                    return YES;
                }else{
                    [[SPSocialManager sharedManager]disconnectToThirdParty:TWITTER];
                }
            }
            break;
        default:
            break;
    }
    return NO;
}


@end
