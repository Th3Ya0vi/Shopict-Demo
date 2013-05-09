//
//  SBInstagramImagePickerControllerViewController.m
//  SHOPBOOK
//
//  Created by bichenkk on 13年1月25日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPInstagramImagePickerController.h"
#import "UIImageView+WebCache.h"
#import "SPInstagramImagesCell.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+SPButtonUtility.h"
#import "SPTableViewFooterView.h"
#import "SPBaseViewController+SPRequestUtility.h"
#import "SPGetInstagramUserMediaResponseData.h"

NSString * const kClientId = @"b7c336f97ebb47729e9a158d30ce9cff";
NSString * const kRedirectUrl = @"http://biworks.mobi/instagramAPI";
NSString * const kAuthenticationEndpoint =
@"https://instagram.com/oauth/authorize/?client_id=%@&redirect_uri=%@&response_type=token";

@interface SPInstagramImagePickerController ()
@end

@implementation SPInstagramImagePickerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = [@"Instagram" uppercaseString];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.thumbnailUrls = [NSMutableArray array];
    self.standardUrls = [NSMutableArray array];

    self.webView.delegate = self;
    NSURLRequest* request =
    [NSURLRequest requestWithURL:[NSURL URLWithString:
                                  [NSString stringWithFormat:kAuthenticationEndpoint, kClientId, kRedirectUrl]]];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
    
    UIButton *rightBarButton = [UIButton longBarButtonItemWithTitle:@"Cancel"];
    [rightBarButton addTarget:self action:@selector(cancelButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    [self.navigationItem setLeftBarButtonItem:barButtonItem];
    [barButtonItem release];
    
    SPTableViewFooterView *footerView = [SPTableViewFooterView footerView];
    self.footerView = footerView;
    self.footerView.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    
    [self.imageTableView reloadData];
    [self.footerView restartLoadingAnimation];
}

- (void)didBecomeActive:(NSNotification *)aNotification {
    
    if ([self isShown]) {
        [self.footerView restartLoadingAnimation];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_webView release];
    [_imageTableView release];
    [_accessToken release];
    [_nextUrl release];
    [_thumbnailUrls release];
    [_standardUrls release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setWebView:nil];
    [self setImageTableView:nil];
    [super viewDidUnload];
}

- (IBAction)cancelButtonPressed:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - WebView Delegate

- (BOOL)webView:(UIWebView *)webView
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString rangeOfString:@"#"].location != NSNotFound) {
        NSString *params = [[request.URL.absoluteString componentsSeparatedByString:@"#"] objectAtIndex:1];
        NSString *accessToken = [params stringByReplacingOccurrencesOfString:@"access_token=" withString:@""];
        self.nextUrl = [NSString stringWithFormat:@"https://api.instagram.com/v1/users/self/media/recent/?access_token=%@",accessToken];
        self.webView.hidden = YES;
        [self sendGetInstagramImageRequest];
    }
	return YES;
}

#pragma mark - Request Method

- (void)sendGetInstagramImageRequest
{
    if (self.nextUrl) {
        self.isLoading = YES;
        [self sendGetInstagramUserMediaRequestWithNextUrl:self.nextUrl delegate:self];
    }
}

- (void)SPGetInstagramUserMediaRequestDidFinish:(SPGetInstagramUserMediaResponseData*)response
{
    if (response.error) {
        self.isRequestFailed = YES;
    }else{
        NSLog(@"Success");
        if (self.thumbnailUrls) {
            for (NSString *toAddThumbnailUrl in response.thumbnailUrls) {
                BOOL included = NO;
                for (NSString *thumbnailUrl in self.thumbnailUrls) {
                    if ([thumbnailUrl isEqualToString:toAddThumbnailUrl]) {
                        included = YES;
                    }
                }
                if (!included) {
                    [self.thumbnailUrls addObjectsFromArray:response.thumbnailUrls];
                    [self.standardUrls addObjectsFromArray:response.standardUrls];
                }
                
            }
        }else{
            self.thumbnailUrls = response.thumbnailUrls;
            self.standardUrls = response.standardUrls;
        }
        self.nextUrl = response.nextUrl;
        self.lastImage = response.lastImage;
    }
    [self.imageTableView reloadData];
    self.isLoading = NO;
}

#pragma mark - TableView Delegate

#pragma mark -
#pragma mark TableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 && self.thumbnailUrls) {
        NSInteger wholeRow = [self.thumbnailUrls count]/4;
        if( [self.thumbnailUrls count]%4 == 0 )
            return wholeRow;
        else {
            return wholeRow + 1;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && self.thumbnailUrls) {
            static NSString *CellIdentifier = @"SPInstagramImagesCell";
            
            SPInstagramImagesCell *cell = (SPInstagramImagesCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            
            if (cell == nil)
            {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"SPInstagramImagesCell" owner:nil options:nil] objectAtIndex:0 ];
                NSLog(@"Grid Cell Created");
            }
            cell.delegate = self;
            NSInteger cellNumber = indexPath.row * 4;
            NSMutableArray *mutableArray = [NSMutableArray array];
            for( int i=0; i<4; i++ )
            {
                if( cellNumber <= [self.thumbnailUrls count]-1 )
                {
                    NSString *thumbnailUrl = [self.thumbnailUrls objectAtIndex:cellNumber];
                    [mutableArray addObject:thumbnailUrl];
                }
                cellNumber ++;
            }
            [cell setImageUrls:mutableArray];
            return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        if (!self.thumbnailUrls || self.thumbnailUrls.count == 0) {
            return self.imageTableView.frame.size.height - self.imageTableView.tableHeaderView.frame.size.height;
        }
        if (self.thumbnailUrls && self.thumbnailUrls.count != 0) {
            return 50;
        }
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 79;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        
        if (!self.thumbnailUrls || self.thumbnailUrls.count == 0) {
            [self.footerView setFrame:CGRectMake(0, 0, self.imageTableView.frame.size.width, self.imageTableView.frame.size.height - self.imageTableView.tableHeaderView.frame.size.height)];
            [self.footerView recenterSubviews];
        }
        
        if (self.thumbnailUrls && self.thumbnailUrls.count != 0) {
            [self.footerView setFrame:CGRectMake(0, 0, self.imageTableView.frame.size.width, 50)];
            [self.footerView recenterSubviews];
        }
        
        if (self.isRequestFailed) {
            [self.footerView showReloadButton];
            return self.footerView;
        }
        
        if (!self.lastImage) {
            [self.footerView showLoading];
            if (!self.isLoading) {
                [self sendGetInstagramImageRequest];
            }
            return self.footerView;
        }else{
            if (self.thumbnailUrls.count == 0) {
                [self.footerView showTitleLabel:@"No image"];
            }else{
                [self.footerView showTitleLabel:[NSString stringWithFormat:@"%d %@",self.thumbnailUrls.count, (self.thumbnailUrls.count==0?@"image":@"images")]];
            }
            return self.footerView;
        }
    }
    return nil;
}

- (void)SPTableViewFooterViewDidSelectReload
{
    if (!self.isLoading) {
        self.isRequestFailed = NO;
        [self.imageTableView reloadData];
        [self sendGetInstagramImageRequest];
    }
}


- (void)SPInstagramImagesCellDidSelectImage:(NSString *)imageUrl
{
    NSLog(@"imageUrl %@",imageUrl);
    
    NSString *standUrls = nil;
    for (NSString *url in self.thumbnailUrls) {
        if ([url isEqualToString:imageUrl]) {
            NSInteger index = [self.thumbnailUrls indexOfObject:url];
            standUrls = [self.standardUrls objectAtIndex:index];
            break;
        }
    }
    
    [self showHUDLoadingViewWithTitle:@"Loading..."];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadWithURL:[NSURL URLWithString:standUrls]
                     options:0
                    progress:^(NSUInteger receivedSize, long long expectedSize)
     {
         // progression tracking code
     }completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished){
         [self hideHUDLoadingView];
         if (image)
         {
             // do something with image
             [self.navigationController dismissViewControllerAnimated:YES completion:^{
                 if ([self.delegate respondsToSelector:@selector(SBInstagramImagePickerControllerDidSelectImage:)]) {
                     [self.delegate SBInstagramImagePickerControllerDidSelectImage:image];
                 }
             }];
         }else{
             [self showHUDErrorViewWithMessage:@"Please Try Later."];
         }
     }];
}

@end
