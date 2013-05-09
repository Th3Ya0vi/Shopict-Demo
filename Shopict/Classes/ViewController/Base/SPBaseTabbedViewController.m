//
//  SPBaseTabbedViewController.m
//  SP
//
//  Created by bichenkk on 13年2月18日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPBaseTabbedViewController.h"
#import "SPUtility.h"
#import "SPSocialManager.h"
#import "SPEnum.h"
#import "SPPost.h"
#import "SPAccount.h"
#import "SPProduct.h"
#import "SPBaseViewController+SPRequestUtility.h"
#import "SPBaseResponseData.h"
#import "SPGetPostInfoResponseData.h"
#import "SPBaseViewController+SPViewControllerUtility.h"

@interface SPBaseTabbedViewController ()

@end

@implementation SPBaseTabbedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self addSPObservers];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationBarWithLogo
{
    UIImage *image = [UIImage imageNamed:@"logo_nav_bar_shopict"];
    self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:image] autorelease];
}

- (void)addSPObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(postDidAdd:)
                                                 name:@"POSTDIDADD"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(postDidDelete:)
                                                 name:@"POSTDIDDELETE"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(postDidWant:)
                                                 name:@"POSTDIDWANT"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(postDidUnwant:)
                                                 name:@"POSTDIDUNWANT"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(postDidComment:)
                                                 name:@"POSTDIDCOMMENT"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(accountDidFollow:)
                                                 name:@"ACCOUNTDIDFOLLOW"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(accountDidUnfollow:)
                                                 name:@"ACCOUNTDIDUNFOLLOW"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(accountDidUpdate:)
                                                 name:@"ACCOUNTDIDUPDATE"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(postDidRepost:)
                                                 name:@"POSTDIDREPOST"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(postDidUnrepost:)
                                                 name:@"POSTDIDUNREPOST"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(accountDidUpdateForPost:)
                                                 name:@"ACCOUNTDIDUPDATEFORPOST"
                                               object:nil];
}

- (void)postDidAdd:(NSNotification *)notification
{
}

- (void)postDidDelete:(NSNotification *)notification
{
}

- (void)postDidWant:(NSNotification *)notification
{
}

- (void)postDidUnwant:(NSNotification *)notification
{
}

- (void)postDidComment:(NSNotification *)notification
{
}

- (void)accountDidFollow:(NSNotification *)notification
{
}

- (void)accountDidUnfollow:(NSNotification *)notification
{
}

- (void)accountDidUpdate:(NSNotification *)notification
{
}

- (void)accountDidUpdateForPost:(NSNotification *)notification
{
}

- (void)postDidRepost:(NSNotification *)notification
{    
}

- (void)postDidUnrepost:(NSNotification *)notification
{
}

- (void)wantPost:(SPPost *)post want:(BOOL)want
{
    if (want) {
        post.isWanted = YES;
        post.wantCount++;
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:post forKey:@"post"];
        [SPUtility postSPNotificationWithName:POSTDIDWANT dictionary:dictionary];
    }else{
        post.isWanted = NO;
        post.wantCount--;
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:post forKey:@"post"];
        [SPUtility postSPNotificationWithName:POSTDIDUNWANT dictionary:dictionary];
    }
    [self sendWantPostRequestWithPost:post want:want delegate:self];
}

- (void)SPWantPostRequestDidFinish:(SPBaseResponseData*)response post:(SPPost *)post want:(BOOL)want
{
    if (response.error) {
        if (response.errorType == SPRequestConnectionTokenExpired) {
            [self presentLoginViewController];
            return;
        }
        if (!post.isWanted) {
            post.isWanted = YES;
            post.wantCount++;
            NSDictionary *dictionary = [NSDictionary dictionaryWithObject:post forKey:@"post"];
            [SPUtility postSPNotificationWithName:POSTDIDWANT dictionary:dictionary];
        }else{
            post.isWanted = NO;
            post.wantCount--;
            NSDictionary *dictionary = [NSDictionary dictionaryWithObject:post forKey:@"post"];
            [SPUtility postSPNotificationWithName:POSTDIDUNWANT dictionary:dictionary];
        }
    }
}

- (void)repostPost:(SPPost *)post repost:(BOOL)repost
{
    if (repost) {
        post.isReposted = YES;
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:post forKey:@"post"];
        [SPUtility postSPNotificationWithName:POSTDIDREPOST dictionary:dictionary];
        [self sendRepostRequestWithPost:post comment:nil delegate:self];
    }else{
        post.isReposted = NO;
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:post forKey:@"post"];
        [SPUtility postSPNotificationWithName:POSTDIDUNREPOST dictionary:dictionary];
        [self sendDeletePostRequestWithPost:post repost:YES delegate:self];
    }
}

- (void)SPDeletePostRequestDidFinish:(SPBaseResponseData*)response post:(SPPost *)post
{
    if (response.error) {
        if (response.errorType == SPRequestConnectionTokenExpired) {
            [self presentLoginViewController];
            return;
        }else if (response.errorType == SPRequestConnectionFailure){
            [self showHUDErrorViewWithMessage:response.error];
        }else if (response.errorType == SPRequestConnectionJSONError){
            [self showHUDErrorViewWithMessage:@"Please Try Later"];
        }else if (response.errorType == SPRequestConnectionServerError){
            [self showErrorAlert:response.error];
        }
        post.isReposted = YES;
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:post forKey:@"post"];
        [SPUtility postSPNotificationWithName:POSTDIDREPOST dictionary:dictionary];
    }
}

- (void)SPRepostRequestDidFinish:(SPGetPostInfoResponseData*)response originalPost:(SPPost *)originalPost
{
    if (response.error) {
        if (response.errorType == SPRequestConnectionTokenExpired) {
            [self presentLoginViewController];
            return;
        }else if (response.errorType == SPRequestConnectionFailure){
            [self showHUDErrorViewWithMessage:response.error];
        }else if (response.errorType == SPRequestConnectionJSONError){
            [self showHUDErrorViewWithMessage:@"Please Try Later"];
        }else if (response.errorType == SPRequestConnectionServerError){
            [self showErrorAlert:response.error];
        }
        originalPost.isReposted = NO;
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:originalPost forKey:@"post"];
        [SPUtility postSPNotificationWithName:POSTDIDUNREPOST dictionary:dictionary];
    }
}

- (void)SPAddPostFromURLViewControllerDidUploadNewPost:(SPPost *)post
{
    [self goToPostViewControllerWithPost:post];
}

- (void)SPAddPostFromPlaceViewControllerDidUploadNewPost:(SPPost *)post
{
    [self goToPostViewControllerWithPost:post];
}


- (void)subscribeAccount:(SPAccount *)account
                  follow:(BOOL)follow
{
    if (follow) {
        account.subscribed = YES;
        account.fansCount++;
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:account forKey:@"account"];
        [SPUtility postSPNotificationWithName:ACCOUNTDIDFOLLOW dictionary:dictionary];
    }else{
        account.subscribed = NO;
        account.fansCount--;
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:account forKey:@"account"];
        [SPUtility postSPNotificationWithName:ACCOUNTDIDUNFOLLOW dictionary:dictionary];
    }
    [self sendSubscribeAccountRequestWithAccount:account subscribe:follow delegate:self];
}

- (void)SPSubscribeAccountRequestDidFinish:(SPBaseResponseData*)response
                                   account:(SPAccount *)account
                                    follow:(BOOL)follow
{
    if (response.error) {
        if (response.errorType == SPRequestConnectionTokenExpired) {
            [self presentLoginViewController];
            return;
        }else if (response.errorType == SPRequestConnectionFailure){
            [self showHUDErrorViewWithMessage:response.error];
        }else if (response.errorType == SPRequestConnectionJSONError){
            [self showHUDErrorViewWithMessage:@"Please Try Later"];
        }else if (response.errorType == SPRequestConnectionServerError){
            [self showErrorAlert:response.error];
        }
        if (follow) {
            account.subscribed = NO;
            account.fansCount--;
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:account forKey:@"account"];
            [SPUtility postSPNotificationWithName:ACCOUNTDIDUNFOLLOW dictionary:userInfo];
        }else{
            account.subscribed = YES;
            account.fansCount++;
            NSDictionary *userInfo = [NSDictionary dictionaryWithObject:account forKey:@"account"];
            [SPUtility postSPNotificationWithName:ACCOUNTDIDFOLLOW dictionary:userInfo];
        }
    }
}


@end
