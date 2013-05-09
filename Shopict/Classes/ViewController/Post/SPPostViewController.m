//
//  SBProductViewController.m
//  SHOPBOOK
//
//  Created by bichenkk on 12年11月25日.
//  Copyright (c) 2012年 biworks. All rights reserved.
//

#import "SPPostViewController.h"
#import "SPProduct.h"
#import "SPAccount.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+WebCache.h"
#import "SPPostCommentCell.h"
#import "SPUtility.h"
#import "SPComment.h"
#import "SPEnum.h"
#import "NSDate+TimeAgo.h"
#import "UIColor+SPColorUtility.h"
#import "NSString+SPStringUtility.h"
#import "SPTableViewFooterView.h"
#import "SPBaseViewController+SPRequestUtility.h"
#import "SPBaseViewController+SPViewControllerUtility.h"
#import "SPPost.h"
#import "SPBaseResponseData.h"
#import "SPGetPostCommentsResponseData.h"
#import "SPGetAccountInfoResponseData.h"
#import "SPVenue.h"
#import "IFTweetLabel.h"

#define LAYOUTMARGIN 5
#define LAYOUTTHUMBNAILIMAGEBUTTONWIDTH 37
@interface SPPostViewController ()

@end

@implementation SPPostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = NO;
    [self setNavigationBarWithLogo];
    
    // Do any additional setup after loading the view from its nib.
    UIButton *rightBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBarButton setFrame:CGRectMake(0, 0, 35, 35)];
    [rightBarButton setImage:[UIImage imageNamed:@"button_white_options"] forState:UIControlStateNormal];
    [rightBarButton addTarget:self action:@selector(optionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    [rightBarButtonItem release];
    
    self.productCommentTableView.tableHeaderView =  self.productMainContentView;
    [self.productSellerImageButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self adjustProductImages];
    [self adjustProductDesc];

    self.productURLButton.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
    [self.productURLButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
    [self.productSellerButton setTitleColor:[UIColor colorWithRed:208/255.0 green:35/255.0 blue:28/255.0 alpha:1] forState:UIControlStateNormal] ;
    [self.productSellerButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    
    [self.wantItButton setImage:[UIImage imageNamed:@"button_list_heart_selected"] forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.wantItButton setTitle:@"Want" forState:UIControlStateNormal];
    [self.wantItButton setTitle:@"Want" forState:UIControlStateNormal|UIControlStateHighlighted];
    [self.wantItButton setTitle:@"Want'd" forState:UIControlStateSelected];
    [self.wantItButton setTitle:@"Want'd" forState:UIControlStateSelected|UIControlStateHighlighted];
    
    [self.repostButton setImage:[UIImage imageNamed:@"button_list_repost_selected"] forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.repostButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal|UIControlStateHighlighted];
    [self.repostButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected|UIControlStateHighlighted];
    [self.repostButton setTitle:@"Repict" forState:UIControlStateNormal];
    [self.repostButton setTitle:@"Repict'd" forState:UIControlStateSelected];
    [self.repostButton setTitle:@"Repict'd" forState:UIControlStateSelected|UIControlStateHighlighted];
    
    SPTableViewFooterView *footerView = [SPTableViewFooterView footerView];
    self.footerView = footerView;
    self.footerView.delegate = self;
    
//    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//    [self.productMainContentView addGestureRecognizer:singleTapGestureRecognizer];
//    [singleTapGestureRecognizer release];
    
    if (_refreshHeaderView == nil) {
		
		EGORefreshTableHeaderView *view = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.productCommentTableView.bounds.size.height, self.navigationController.view.frame.size.width, self.productCommentTableView.bounds.size.height)];
		view.delegate = self;
		[self.productCommentTableView addSubview:view];
		_refreshHeaderView = view;
		[view release];
		
	}
    
    [self sendGetProductCommetsRequest];
    
    [self.commentButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
    [self.commentButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled|UIControlStateHighlighted];
    
    [self.commentButton setEnabled:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleTweetNotification:) name:IFTweetLabelURLNotification object:nil];
}

- (void)viewDidUnload
{
    self.productMainContentView = nil;
    self.productFeaturedImagesScrollView = nil;
    [self setProductCommentTableView:nil];
    [self setWantItButton:nil];
    [self setBuyItButton:nil];
    [self setProductTitleLabel:nil];
    [self setProductSellerLabel:nil];
    [self setProductPriceLabel:nil];
    [self setProductDescLabel:nil];
    [self setCommentField:nil];
    [self setProductSellerImageView:nil];
    [self setProductSellerImageButton:nil];
    [self setPageControlView:nil];
    [self setProductPostTimeLabel:nil];
    [self setProductDescriptionView:nil];
    [self setWantCountView:nil];
    [self setWantCountLabel:nil];
    [self setCommentCountView:nil];
    [self setCommentCountLabel:nil];
    [self setProductURLButton:nil];
    [self setWantItButtonSeperator:nil];
    [self setProductInfoSeperator:nil];
    [self setCommentInputView:nil];
    [self setCommentViewSeperator:nil];
    [self setProductFeaturedImageSeperator:nil];
    [self setRepostButton:nil];
    [self setCommentButton:nil];
    [self setEditorsPictView:nil];
    [self setProductSellerLabel:nil];
    [self setProductPostTimeImageView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IFTweetLabelURLNotification object:nil];
    [_productSellerStatusLabel release];
    [_post release];
    [_productMainContentView release];
    [_productFeaturedImagesScrollView release];
    [_productFeaturedImageActivityIndicators release];
    [_productFeaturedImageViews release];
    [_productFeaturedImageButtons release];
    [_productCommentTableView release];
    [_wantItButton release];
    [_buyItButton release];
    [_productTitleLabel release];
    [_productSellerButton release];
    [_productPriceLabel release];
    [_productDescLabel release];
    [_commentField release];
    [_productSellerImageView release];
    [_productSellerImageButton release];
    [_nextKey release];
    [_comments release];
    [_pageControlView release];
    [_productPostTimeLabel release];
    [_productDescriptionView release];
    [_wantCountView release];
    [_wantCountLabel release];
    [_commentCountView release];
    [_commentCountLabel release];
    [_productURLButton release];
    [_wantItButtonSeperator release];
    [_productInfoSeperator release];
    [_commentInputView release];
    [_commentViewSeperator release];
    [_productFeaturedImageSeperator release];
    [_buyItOptionView release];
    [_buyItView release];
    [_selectedBuyItOption release];
    [_repostButton release];
    [_commentButton release];
    [_editorsPictView release];
    [_productSellerLabel release];
    [_productPostTimeImageView release];
    [super dealloc];
}

#pragma mark -
#pragma mark Layout Adjustment

- (void)initProductContentView
{
    self.productCommentTableView.tableHeaderView = self.productMainContentView;
}

- (void)adjustProductImages
{
    self.productFeaturedImageViews = [NSMutableArray array];
    self.productFeaturedImageActivityIndicators = [NSMutableArray array];
    self.productFeaturedImageButtons = [NSMutableArray array];
    
    NSInteger imagesNumber = self.post.product.imgURLs.count;
    if (imagesNumber <= 1) {
        [self.pageControlView setHidden:YES];
    }else{
        [self.pageControlView setNumberOfPages:imagesNumber];
        [self.pageControlView setCurrentPage:0];
    }
    
    float imageRatio = [[self.post.product.ratios objectAtIndex:0]floatValue];
    if (imageRatio > 1){
        imageRatio = 1;
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.productFeaturedImagesScrollView.frame.size.width * imagesNumber, self.productFeaturedImagesScrollView.frame.size.height*imageRatio)];
    CGPoint startPoint = CGPointZero;
    
    for (NSInteger i = 0; i<imagesNumber; i++) {
        
        //Add UIActivityIndicatorView
        UIActivityIndicatorView * activityIndicator = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(startPoint.x, startPoint.y, self.productFeaturedImagesScrollView.frame.size.width, self.productFeaturedImagesScrollView.frame.size.height*imageRatio)]autorelease];
        [activityIndicator setHidesWhenStopped:YES];
        [activityIndicator setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleGray];
        [view addSubview:activityIndicator];
        [activityIndicator startAnimating];
        [self.productFeaturedImageActivityIndicators addObject:activityIndicator];
        
        //Add Image
        UIImageView *imageView = [[UIImageView alloc]init];
        [imageView setFrame:CGRectMake(startPoint.x, startPoint.y, self.productFeaturedImagesScrollView.frame.size.width, self.productFeaturedImagesScrollView.frame.size.height*imageRatio)];
        imageView.tag = i;
        imageView.clipsToBounds = YES;
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setImageWithURL:[self.post.product.imgURLs objectAtIndex:i]];
        [imageView setImageWithURL:[self.post.product.imgURLs objectAtIndex:i] placeholderImage:nil options:SDWebImageCacheMemoryOnly completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            [activityIndicator stopAnimating];
            [activityIndicator setHidden:YES];
        }];
        [self.productFeaturedImageViews addObject:imageView];
        [view addSubview:imageView];
        [imageView release];
        
        //Add Shadow
        UIImageView *shadowImageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageView.frame), CGRectGetMaxY(imageView.frame) - 80*imageRatio, CGRectGetWidth(imageView.frame), 80*imageRatio)];
        [shadowImageView setImage:[UIImage imageNamed:@"background_shadow"]];
        [view addSubview:shadowImageView];
        [shadowImageView release];
        
        startPoint.x = startPoint.x+self.productFeaturedImagesScrollView.frame.size.width;
    }
    self.productFeaturedImagesScrollView.contentSize = view.frame.size;
    [self.productFeaturedImagesScrollView addSubview:view];
    self.productFeaturedImagesScrollView.pagingEnabled = YES;
    self.productFeaturedImagesScrollView.backgroundColor = [UIColor clearColor];
    self.productFeaturedImagesScrollView.showsHorizontalScrollIndicator = NO;
    self.productFeaturedImagesScrollView.showsVerticalScrollIndicator = NO;
    self.productFeaturedImagesScrollView.scrollsToTop = NO;
    self.productFeaturedImagesScrollView.delegate = self;
    [view release];
    
    for (NSInteger i = 0; i<imagesNumber; i++) {
        [self loadFeaturedImageWithPage:i];
    }
    
}

- (void)adjustProductDesc
{
    SPProduct *product = self.post.product;
    SPAccount *account = self.post.author;
    
    //Set Product Data
    [self.productSellerButton setTitle:account.name forState:UIControlStateNormal];
    [self.productSellerImageButton setImageWithURL:[NSURL URLWithString:account.profileImgURL] forState:UIControlStateNormal];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSTimeZone *gmt = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    [dateFormatter setTimeZone:gmt];
    NSDate *date = [dateFormatter dateFromString:self.post.createTime];
    [dateFormatter release];
    NSString *ago = [date timeAgo];
    [self.productPostTimeLabel setText:ago];
    self.productTitleLabel.text = product.name;
    //if (self.product.productType == SELL) {
    if (YES) {
        NSString *currencyCode = product.currency;
        NSLocale *locale = [[[NSLocale alloc] initWithLocaleIdentifier:currencyCode] autorelease];
        NSString *currencySymbol = [NSString stringWithFormat:@"%@",[locale displayNameForKey:NSLocaleCurrencySymbol value:currencyCode]];
        [self.productPriceLabel setText:[NSString stringWithFormat:@"%@ %@%.2f",product.currency,currencySymbol,product.price]];
    }else{
        [self.productPriceLabel setText:nil];
    }
    
    
    if (product.type == 2) {
        [self.productDescLabel setText:product.venue.address];
        [self.productURLButton setTitle:product.venue.name forState:UIControlStateNormal];
    }else if (self.post.product.type == 0){
        [self.productDescLabel setText:nil];
        NSString *urlAddress = product.url;
        if ([[urlAddress lowercaseString]hasPrefix:@"http://"]) {
            urlAddress = [urlAddress stringByReplacingOccurrencesOfString:@"http://" withString:@""];
        }
        if ([[urlAddress lowercaseString]hasPrefix:@"https://"]) {
            urlAddress = [urlAddress stringByReplacingOccurrencesOfString:@"https://" withString:@""];
        }
        NSArray *urlComponents = [urlAddress componentsSeparatedByString:@"/"];
        [self.productURLButton setTitle:[urlComponents objectAtIndex:0] forState:UIControlStateNormal];
    }
    
    [self.wantCountLabel setText:[NSString stringWithFormat:@"%d",self.post.wantCount]];
    [self.commentCountLabel setText:[NSString stringWithFormat:@"%d",self.post.commentCount]];
    
    self.pageControlView.currentPage = 0;
    self.wantItButton.selected = self.post.isWanted;
    self.repostButton.selected = self.post.isReposted;
    
    //Seller Name Button
//    CGSize maximumSellerButtonSize = CGSizeMake(CGRectGetWidth(self.productSellerButton.frame),CGRectGetHeight(self.productSellerButton.frame));
//    CGSize expectedSellerButtonSize = [self.productSellerButton.titleLabel.text sizeWithFont:self.productSellerButton.titleLabel.font constrainedToSize:maximumSellerButtonSize lineBreakMode:self.productSellerButton.titleLabel.lineBreakMode];
//    [self.productSellerButton setFrame:CGRectMake(CGRectGetMinX(self.productSellerButton.frame), CGRectGetMinY(self.productSellerButton.frame), expectedSellerButtonSize.width, expectedSellerButtonSize.height)];
    
    //Time Label
//    [self.productPostTimeLabel setFrame:CGRectMake(CGRectGetMinX(self.productPostTimeLabel.frame), CGRectGetMinY(self.productPostTimeLabel.frame), CGRectGetWidth(self.productPostTimeLabel.frame), CGRectGetHeight(self.productPostTimeLabel.frame))];
    
    //Seller State Label
    CGSize maximumSellerLabelSize = CGSizeMake(CGRectGetWidth(self.productSellerLabel.frame),9999);
    CGSize expectedSellerLabelSize = [self.post.comment sizeWithFont:self.productSellerLabel.font constrainedToSize:maximumSellerLabelSize lineBreakMode:self.productSellerLabel.lineBreakMode];
    [self.productSellerLabel setFrame:CGRectMake(CGRectGetMinX(self.productSellerLabel.frame), CGRectGetMinY(self.productSellerLabel.frame), CGRectGetWidth(self.productSellerLabel.frame), expectedSellerLabelSize.height)];
    
    [self.productSellerStatusLabel removeFromSuperview];
    self.productSellerStatusLabel = [[[IFTweetLabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.productSellerLabel.frame), CGRectGetMinY(self.productSellerLabel.frame), CGRectGetWidth(self.productSellerLabel.frame), expectedSellerLabelSize.height)] autorelease];
	[self.productSellerStatusLabel setFont: [UIFont fontWithName:@"Helvetica" size:14.0]];
	[self.productSellerStatusLabel setTextColor:[UIColor darkGrayColor]];
	[self.productSellerStatusLabel setBackgroundColor:[UIColor clearColor]];
	[self.productSellerStatusLabel setNumberOfLines:0];
	[self.productSellerStatusLabel setText:self.post.comment];
	[self.productSellerStatusLabel setLinksEnabled:YES];
	[self.productMainContentView addSubview:self.productSellerStatusLabel];
    
    if (![self.post.comment isValid]) {
        [self.productSellerButton setFrame:CGRectMake(CGRectGetMinX(self.productSellerButton.frame), 18, self.productSellerButton.frame.size.width, self.productSellerButton.frame.size.height)];
        [self.productPostTimeLabel setFrame:CGRectMake(CGRectGetMinX(self.productPostTimeLabel.frame), CGRectGetMinY(self.productSellerButton.frame), CGRectGetWidth(self.productPostTimeLabel.frame), CGRectGetHeight(self.productPostTimeLabel.frame))];
        [self.productPostTimeImageView setFrame:CGRectMake(CGRectGetMinX(self.productPostTimeImageView.frame), CGRectGetMinY(self.productSellerButton.frame), CGRectGetWidth(self.productPostTimeImageView.frame), CGRectGetHeight(self.productPostTimeImageView.frame))];
    }
    
    float imageRatio = [[product.ratios objectAtIndex:0]floatValue];
    if (imageRatio > 1){
        imageRatio = 1;
    }
    
    //ImageView
    if (CGRectGetMaxY(self.productSellerLabel.frame) > CGRectGetMaxY(self.productSellerImageView.frame)) {
        [self.productFeaturedImagesScrollView setFrame:CGRectMake(CGRectGetMinX(self.productFeaturedImagesScrollView.frame), CGRectGetMaxY(self.productSellerLabel.frame)+5, CGRectGetWidth(self.productFeaturedImagesScrollView.frame), CGRectGetWidth(self.productFeaturedImagesScrollView.frame)*imageRatio)];
    }else{
        [self.productFeaturedImagesScrollView setFrame:CGRectMake(CGRectGetMinX(self.productFeaturedImagesScrollView.frame), CGRectGetMaxY(self.productSellerImageView.frame)+3, CGRectGetWidth(self.productFeaturedImagesScrollView.frame), CGRectGetWidth(self.productFeaturedImagesScrollView.frame)*imageRatio)];
    }
    
    //[self.pageControlView setFrame:CGRectMake(CGRectGetWidth(self.productFeaturedImagesScrollView.frame)-product.imgURLs.count *15-5, CGRectGetMaxY(self.productFeaturedImagesScrollView.frame)-30, product.imgURLs.count *15 , CGRectGetHeight(self.pageControlView.frame))];
    
    [self.pageControlView setFrame:CGRectMake(0, CGRectGetMaxY(self.productFeaturedImagesScrollView.frame)-30, 320 , CGRectGetHeight(self.pageControlView.frame))];
    
    //[self.productFeaturedImageSeperator setFrame:CGRectMake(CGRectGetMinX(self.productFeaturedImagesScrollView.frame), CGRectGetMaxY(self.productFeaturedImagesScrollView.frame)-25, CGRectGetWidth(self.productFeaturedImagesScrollView.frame), CGRectGetHeight(self.productFeaturedImageSeperator.frame))];
    
    [self.wantCountView setFrame:CGRectMake(CGRectGetMinX(self.productFeaturedImagesScrollView.frame)+5, CGRectGetMaxY(self.productFeaturedImagesScrollView.frame)-26, CGRectGetWidth(self.wantCountView.frame), CGRectGetHeight(self.wantCountView.frame))];
    [self.commentCountView setFrame:CGRectMake(CGRectGetMaxX(self.wantCountView.frame), CGRectGetMaxY(self.productFeaturedImagesScrollView.frame)-25, CGRectGetWidth(self.commentCountView.frame), CGRectGetHeight(self.commentCountView.frame))];
    
//    //Want and Buy Button
//    if (self.product.productType == SELL || self.product.url) {
//        self.buyItButton.hidden = NO;
//        [self.wantItButton setFrame:CGRectMake(self.wantItButton.frame.origin.x, CGRectGetMaxY(self.productFeaturedImagesScrollView.frame)+5, self.wantItButton.frame.size.width, self.wantItButton.frame.size.height)];
//        [self.buyItButton setFrame:CGRectMake(self.buyItButton.frame.origin.x, CGRectGetMaxY(self.productFeaturedImagesScrollView.frame)+5, self.buyItButton.frame.size.width, self.buyItButton.frame.size.height)];
//    }else{
//        self.buyItButton.hidden = YES;
//        [self.wantItButton setCenter:self.productMainContentView.center];
//        [self.wantItButton setFrame:CGRectMake(self.wantItButton.frame.origin.x, CGRectGetMaxY(self.productFeaturedImagesScrollView.frame)+5, self.wantItButton.frame.size.width, self.wantItButton.frame.size.height)];
//    }
//
    [self.editorsPictView setFrame:CGRectMake(CGRectGetMaxX(self.productFeaturedImagesScrollView.frame)-CGRectGetWidth(self.editorsPictView.frame), CGRectGetMinY(self.productFeaturedImagesScrollView.frame)+5, CGRectGetWidth(self.editorsPictView.frame), CGRectGetHeight(self.editorsPictView.frame))];
    self.editorsPictView.hidden = !self.post.isEditorPick;
    
    [self.repostButton setFrame:CGRectMake(self.repostButton.frame.origin.x, CGRectGetMaxY(self.productFeaturedImagesScrollView.frame)+5, self.repostButton.frame.size.width, self.repostButton.frame.size.height)];
    [self.wantItButton setFrame:CGRectMake(self.wantItButton.frame.origin.x, CGRectGetMaxY(self.productFeaturedImagesScrollView.frame)+5, self.wantItButton.frame.size.width, self.wantItButton.frame.size.height)];
    [self.buyItButton setFrame:CGRectMake(self.buyItButton.frame.origin.x, CGRectGetMaxY(self.productFeaturedImagesScrollView.frame)+5, self.buyItButton.frame.size.width, self.buyItButton.frame.size.height)];
    
    if (self.post.product.account.me || self.post.author.me) {
        [self.repostButton setHidden:YES];
        [self.wantItButton setFrame:CGRectMake(0, CGRectGetMaxY(self.productFeaturedImagesScrollView.frame)+5, 160, self.wantItButton.frame.size.height)];
        [self.buyItButton setFrame:CGRectMake(161, CGRectGetMaxY(self.productFeaturedImagesScrollView.frame)+5, 160, self.buyItButton.frame.size.height)];
    }else{
        [self.repostButton setFrame:CGRectMake(self.repostButton.frame.origin.x, CGRectGetMaxY(self.productFeaturedImagesScrollView.frame)+5, self.repostButton.frame.size.width, self.repostButton.frame.size.height)];
        [self.wantItButton setFrame:CGRectMake(self.wantItButton.frame.origin.x, CGRectGetMaxY(self.productFeaturedImagesScrollView.frame)+5, self.wantItButton.frame.size.width, self.wantItButton.frame.size.height)];
        [self.buyItButton setFrame:CGRectMake(self.buyItButton.frame.origin.x, CGRectGetMaxY(self.productFeaturedImagesScrollView.frame)+5, self.buyItButton.frame.size.width, self.buyItButton.frame.size.height)];
    }
    
    //WantButton Seperator
    [self.wantItButtonSeperator setFrame:CGRectMake(self.wantItButtonSeperator.frame.origin.x, CGRectGetMaxY(self.wantItButton.frame)+5, self.wantItButtonSeperator.frame.size.width, self.wantItButtonSeperator.frame.size.height)];
    
    //Title
    CGSize maximumTitleLabelSize = CGSizeMake(CGRectGetWidth(self.productTitleLabel.frame),1000);
    CGSize expectedTitleLabelSize = [self.productTitleLabel.text sizeWithFont:self.productTitleLabel.font constrainedToSize:maximumTitleLabelSize lineBreakMode:self.productTitleLabel.lineBreakMode];
    [self.productTitleLabel setFrame:CGRectMake(CGRectGetMinX(self.productTitleLabel.frame),CGRectGetMinY(self.wantItButtonSeperator.frame)+10, CGRectGetWidth(self.productTitleLabel.frame), expectedTitleLabelSize.height)];
    
    //Price Label
    CGSize maximumPriceLabelSize = CGSizeMake(CGRectGetWidth(self.productPriceLabel.frame),1000);
    CGSize expectedPriceLabelSize = [self.productPriceLabel.text sizeWithFont:self.productPriceLabel.font constrainedToSize:maximumPriceLabelSize lineBreakMode:self.productPriceLabel.lineBreakMode];
    [self.productPriceLabel setFrame:CGRectMake(CGRectGetMinX(self.productPriceLabel.frame),CGRectGetMaxY(self.productTitleLabel.frame), CGRectGetWidth(self.productPriceLabel.frame), expectedPriceLabelSize.height)];
    
    CGPoint descStartPoint;
    if (NO) {
        descStartPoint = CGPointMake(0, CGRectGetMinY(self.productPriceLabel.frame)+5);
    }else{
        descStartPoint = CGPointMake(0, CGRectGetMaxY(self.productPriceLabel.frame)+5);
    }
    
    //URL Button
    CGSize maximumURLButtonSize = CGSizeMake(CGRectGetWidth(self.productURLButton.frame),1000);
    CGSize expectedURLButtonSize = [self.productURLButton.titleLabel.text sizeWithFont:self.productURLButton.titleLabel.font constrainedToSize:maximumURLButtonSize lineBreakMode:self.productURLButton.titleLabel.lineBreakMode];
    [self.productURLButton setFrame:CGRectMake(CGRectGetMinX(self.productURLButton.frame),descStartPoint.y, CGRectGetWidth(self.productURLButton.frame), expectedURLButtonSize.height)];
    
    if ([product.url isValid]||[product.venue.name isValid]) {
        descStartPoint = CGPointMake(0, descStartPoint.y + CGRectGetHeight(self.productURLButton.frame));
    }
    
    //Desc Label
    CGSize maximumDescLabelSize = CGSizeMake(CGRectGetWidth(self.productDescLabel.frame),1000);
    CGSize expectedDescLabelSize = [self.productDescLabel.text sizeWithFont:self.productDescLabel.font constrainedToSize:maximumDescLabelSize lineBreakMode:self.productDescLabel.lineBreakMode];
    [self.productDescLabel setFrame:CGRectMake(CGRectGetMinX(self.productDescLabel.frame),descStartPoint.y, CGRectGetWidth(self.productDescLabel.frame), expectedDescLabelSize.height)];
    
    if ([product.venue.address isValid]) {
        descStartPoint = CGPointMake(0, descStartPoint.y + CGRectGetHeight(self.productDescLabel.frame));
    }
    
//    //Tag
//    self.tagButtons = [NSMutableArray array];
//    for (NSString *tag in product.tags) {
//        UIButton *tagButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        [tagButton setTitle:tag forState:UIControlStateNormal];
//        [tagButton setTitleColor:[UIColor themeColor] forState:UIControlStateNormal];
//        [tagButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
//        [tagButton setBackgroundColor:[UIColor whiteColor]];
//        [tagButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
//        [tagButton.titleLabel setFont:self.productDescLabel.font];
//        
//        CGSize maximumTagButtonSize = CGSizeMake(CGRectGetWidth(self.productDescLabel.frame),18);
//        CGSize expectedTagButtonSize = [tagButton.titleLabel.text sizeWithFont:self.productDescLabel.font constrainedToSize:maximumTagButtonSize lineBreakMode:tagButton.titleLabel.lineBreakMode];
//        
//        if (self.tagButtons.count > 0) {
//            UIButton *previousButton = self.tagButtons.lastObject;
//            if (CGRectGetMaxX(previousButton.frame) + expectedTagButtonSize.width + 5 > CGRectGetMaxX(self.productDescLabel.frame)){
//                [tagButton setFrame:CGRectMake(CGRectGetMinX(self.productDescLabel.frame), CGRectGetMaxY(previousButton.frame), expectedTagButtonSize.width, expectedTagButtonSize.height)];
//            }else{
//                [tagButton setFrame:CGRectMake(CGRectGetMaxX(previousButton.frame) + 5, CGRectGetMinY(previousButton.frame), expectedTagButtonSize.width, expectedTagButtonSize.height)];
//            }
//            
//        }else{
//            [tagButton setFrame:CGRectMake(CGRectGetMinX(self.productDescLabel.frame), descStartPoint.y, expectedTagButtonSize.width, expectedTagButtonSize.height)];
//        }
//        [tagButton addTarget:self action:@selector(tagButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        [self.tagButtons addObject:tagButton];
//        [self.productMainContentView addSubview:tagButton];
//    }
//    
//    if (self.tagButtons.count > 0) {
//        UIButton *lastTagButton = self.tagButtons.lastObject;
//        descStartPoint = CGPointMake(0, CGRectGetMaxY(lastTagButton.frame));
//    }
    
    if (![product.venue.address isValid] &&![product.venue.name isValid]&&![product.url isValid]&&self.tagButtons.count==0) {
        descStartPoint = CGPointMake(0, descStartPoint.y - 5);
    }
    
    [self.productMainContentView setFrame:CGRectMake(0, 0, self.productCommentTableView.frame.size.width, descStartPoint.y+10)];
    
    self.productCommentTableView.tableHeaderView = self.productMainContentView;
    
}

//- (void)addBuyItView
//{
//    //3 Methods
//    
//    //Call seller
//    //Message seller
//    //Go to website
//    
//    NSMutableArray *buttonTitles = [NSMutableArray array];
//    
//    if (self.product.productType == SELL) {
//        [buttonTitles addObject:@"Send messages to seller"];
//    }
//    
////    if (self.product.productType == SELL && self.product.account.phoneNumber) {
////        [buttonTitles addObject:@"Call seller"];
////    }
//    
//    if (self.product.url) {
//        [buttonTitles addObject:@"Go to website"];
//    }
//    
//    if (buttonTitles.count == 0) {
//        return;
//    }
//    
//    UIView *buyItView = [[UIView alloc]initWithFrame:self.navigationController.view.frame];
//    [buyItView setBackgroundColor:[UIColor clearColor]];
//    
//    UIView *buyItShadow = [[UIView alloc]initWithFrame:self.navigationController.view.frame];
//    [buyItShadow setBackgroundColor:[UIColor blackColor]];
//    [buyItShadow setAlpha:0.7f];
//    [buyItView addSubview:buyItShadow];
//    
//    UIImageView *buyItOptionTopImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"buyit_background_top"]];
//    UIImageView *buyItOptionMidImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"buyit_background_mid"]];
//    UIImageView *buyItOptionBottomImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"buyit_background_bottom"]];
//    
//    UIView *buyItOptionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(buyItOptionTopImageView.frame), 0)];
//    self.buyItOptionView = buyItOptionView;
//    
//    [buyItOptionView addSubview:buyItOptionTopImageView];
//    [buyItOptionView addSubview:buyItOptionMidImageView];
//    [buyItOptionView addSubview:buyItOptionBottomImageView];
//    
//    CGPoint startPoint = CGPointMake((CGRectGetWidth(buyItOptionTopImageView.frame)-264)/2, CGRectGetMaxY(buyItOptionTopImageView.frame));
//    
//    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(buyItOptionTopImageView.frame), startPoint.y, CGRectGetWidth(buyItOptionTopImageView.frame), 25)];
//    [titleLabel setText:@"Buy it now!"];
//    [titleLabel setTextColor:[UIColor blackColor]];
//    [titleLabel setTextAlignment:NSTextAlignmentCenter];
//    [titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
//    [titleLabel setBackgroundColor:[UIColor clearColor]];
//    [buyItOptionView addSubview:titleLabel];
//    
//    startPoint.y = startPoint.y + CGRectGetHeight(titleLabel.frame) + CGRectGetHeight(buyItOptionTopImageView.frame);
//    
//    NSMutableArray *buyItOptionButtons = [NSMutableArray array];
//    
//    for (NSInteger i = 0; i<buttonTitles.count; i++) {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        [button setBackgroundImage:[UIImage imageNamed:@"buyit_option"] forState:UIControlStateNormal];
//        [button setBackgroundImage:[UIImage imageNamed:@"buyit_option_highlight"] forState:UIControlStateHighlighted];
//        [button.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
//        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
//        [button setFrame:CGRectMake(startPoint.x, startPoint.y, 264, 51)];
//        [button setTitle:[buttonTitles objectAtIndex:i] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(buyItOptionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//        startPoint.y = startPoint.y + button.frame.size.height + 5;
//        [buyItOptionButtons addObject:button];
//        [buyItOptionView addSubview:button];
//    }
//    
//    startPoint.y = startPoint.y+5;
//    UILabel *seperator = [[UILabel alloc]initWithFrame:CGRectMake(startPoint.x, startPoint.y, 264, 1)];
//    [seperator setBackgroundColor:[UIColor whiteColor]];
//    [buyItOptionView addSubview:seperator];
//    startPoint.y = startPoint.y+10;
//    
//    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [cancelButton setBackgroundImage:[UIImage imageNamed:@"buyit_cancel"] forState:UIControlStateNormal];
//    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [cancelButton setFrame:CGRectMake((CGRectGetWidth(buyItOptionTopImageView.frame)-264)/2, startPoint.y, 264, 51)];
//    [cancelButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
//    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
//    [cancelButton addTarget:self action:@selector(buyItOptionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    [buyItOptionView addSubview:cancelButton];
//    
//    [buyItOptionTopImageView setFrame:CGRectMake(0, 0, CGRectGetWidth(buyItOptionTopImageView.frame), CGRectGetHeight(buyItOptionTopImageView.frame))];
//    [buyItOptionMidImageView setFrame:CGRectMake(0, CGRectGetMaxY(buyItOptionTopImageView.frame), CGRectGetWidth(buyItOptionMidImageView.frame), CGRectGetMaxY(cancelButton.frame)-CGRectGetMaxY(buyItOptionTopImageView.frame))];
//    [buyItOptionBottomImageView setFrame:CGRectMake(0, CGRectGetMaxY(buyItOptionMidImageView.frame), CGRectGetWidth(buyItOptionTopImageView.frame), CGRectGetHeight(buyItOptionTopImageView.frame))];
//    [buyItOptionView setFrame:CGRectMake(0, 0, CGRectGetWidth(buyItOptionTopImageView.frame), CGRectGetHeight(buyItOptionTopImageView.frame)+CGRectGetHeight(buyItOptionMidImageView.frame)+CGRectGetHeight(buyItOptionBottomImageView.frame))];
//    
//    [buyItView addSubview:buyItOptionView];
//    [buyItOptionView setCenter:buyItView.center];
//    CGRect frame = buyItOptionView.frame;
//    frame.origin.y = frame.origin.y + self.navigationController.view.frame.size.height;
//    [buyItOptionView setFrame:frame];
//    
//    [buyItView setAlpha:0.0f];
//    [self.navigationController.view addSubview:buyItView];
//    
//    self.buyItOptionView = buyItOptionView;
//    self.buyItView = buyItView;
//    
//    [titleLabel release];
//    [seperator release];
//    [buyItOptionTopImageView release];
//    [buyItOptionMidImageView release];
//    [buyItOptionBottomImageView release];
//    [buyItOptionView release];
//    [buyItShadow release];
//    [buyItView release];
//    
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.2f];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(buyItViewDidShow:)];
//    
//    [buyItView setAlpha:1.0f];
//    [UIView commitAnimations];
//}
//
//- (IBAction)buyItViewDidShow:(id)sender
//{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.3f];
//    
//    [self.buyItOptionView setCenter:self.buyItView.center];
//    
//    [UIView commitAnimations];
//}
//
//- (IBAction)buyItOptionButtonPressed:(id)sender
//{
//    UIButton *button = sender;
//    self.selectedBuyItOption = button.titleLabel.text;
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.3f];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(buyItOptionViewDidHide:)];
//    
//    CGRect frame = self.buyItOptionView.frame;
//    frame.origin.y = frame.origin.y + self.navigationController.view.frame.size.height;
//    [self.buyItOptionView setFrame:frame];
//    
//    [UIView commitAnimations];
//}
//
//- (IBAction)buyItOptionViewDidHide:(id)sender
//{
//    [UIView beginAnimations:nil context:nil];
//    [UIView setAnimationDuration:0.2f];
//    [UIView setAnimationDelegate:self];
//    [UIView setAnimationDidStopSelector:@selector(buyItViewDidHide:)];
//    
//    [self.buyItView setAlpha:0.0f];
//    
//    [UIView commitAnimations];
//    
//}
//
//- (IBAction)buyItViewDidHide:(id)sender
//{
//    if ([self.selectedBuyItOption isEqualToString:@"Send messages to seller"]) {
//        if (self.product.account.me) {
//            [self showErrorAlert:@"You cannot send message to yourself"];
//            return;
//        }
////        SBMessengerViewController *viewController = [[SBMessengerViewController alloc]initWithNibName:@"SBMessengerViewController" bundle:nil];
////        viewController.account = self.product.account;
////        [self.navigationController pushViewController:viewController animated:YES];
////        [viewController release];
//        
//    }else if ([self.selectedBuyItOption isEqualToString:@"Call seller"]){
//        
//    }else if ([self.selectedBuyItOption isEqualToString:@"Go to website"]){
//        
//        [self productURLButtonPressed:nil];
//        
//    }
//}

#pragma mark -
#pragma mark ScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    UIScrollView *scrollView = sender;
    
    if (scrollView.contentOffset.y < self.lastContentOffsetY) {
        [self.commentField resignFirstResponder];
    }
    
    self.lastContentOffsetY = scrollView.contentOffset.y;
    
    [_refreshHeaderView egoRefreshScrollViewDidScroll:sender];
    if ([sender isEqual:self.productFeaturedImagesScrollView]) {
        UIScrollView *scrollView = self.productFeaturedImagesScrollView;
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        [self loadFeaturedImageWithPage:page - 1];
        [self loadFeaturedImageWithPage:page];
        [self loadFeaturedImageWithPage:page + 1];
    }
    
    
}

- (void)loadFeaturedImageWithPage:(NSInteger) page
{
    [self.pageControlView setCurrentPage:page-1];
    
    if (page < 0)
    {
        return;
    }
    
    if (page >= self.post.product.imgURLs.count)
    {
        return;
    }
    
//    UIImageView *imageView = [self.productFeaturedImageViews objectAtIndex:page];
//    UIActivityIndicatorView *activityIndicator = [self.productFeaturedImageActivityIndicators objectAtIndex:page];
    
//    [imageView setImageWithURL:[self.post.product.imgURLs objectAtIndex:page] placeholderImage:nil options:SDWebImageCacheMemoryOnly completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
//        [activityIndicator stopAnimating];
//    }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark -
#pragma mark Button Events

- (IBAction)featuredImageButtonPressed:(id)sender
{
}

- (IBAction)sellerButtonPressed:(id)sender
{
    [self goToProfileViewControllerWithAccount:self.post.author];
}

- (IBAction)commentButtonPressed:(id)sender {
    [self sendCommentPostRequest];
}

- (IBAction)optionButtonPressed:(id)sender{
    UIActionSheet *actionSheet;
    if (self.post.author.me) {
        actionSheet = [[[UIActionSheet alloc]initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                    destructiveButtonTitle:@"Delete"
                                         otherButtonTitles:nil]
                       autorelease];
    }else{
        actionSheet = [[[UIActionSheet alloc]initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                    destructiveButtonTitle:@"Report Inappropriate"
                                         otherButtonTitles:nil]
                       autorelease];
    }
    [actionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
}

- (IBAction)wantButtonPressed:(id)sender {
    
    if (self.wantItButton.selected) {
        [self wantPost:self.post want:NO];
    }else{
        [self wantPost:self.post want:YES];
    }
}

- (IBAction)productURLButtonPressed:(id)sender {
    if (self.post.product.type == 2) {
        if (self.post.product.venue) {
            [self showWebSupportViewControllerWithUrl:self.post.product.venue.fourSquareUrl withTitle:@"FOURSQUARE"];
        }
    }else if (self.post.product.type == 0){
        if (self.post.product.url) {
             [self goToAddPostFromURLBrowserViewControllerWithUrl:self.post.product.url];
        }
    }
}

- (IBAction)buyButtonPressed:(id)sender {
    if (self.post.product.type == 0) {
        if ([self.post.product.url isValid]) {
            if (self.post.product.url) {
                [self goToAddPostFromURLBrowserViewControllerWithUrl:self.post.product.url];
            }
        }
    }else if (self.post.product.type == 2)
    {
        if (self.post.product.venue) {
            [self goToVenueViewControllerWithVenue:self.post.product.venue];
        }
    }
}

- (IBAction)repostButtonPressed:(id)sender {
    if (self.repostButton.selected) {
        UIActionSheet *actionSheet = [[[UIActionSheet alloc]initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:@"Undo Repict"
                                                        otherButtonTitles:nil]
                                                  autorelease];
        [actionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
    }else{
        [self showRepostViewControllerWithPost:self.post];
    }
}


- (IBAction)sendCommentButtonPressed:(id)sender {
    if ([self valiadation]) {
        self.comments = nil;
        self.nextKey = nil;
        self.isLastComment = NO;
        self.isRequestFailed = NO;
        [self.productCommentTableView reloadData];
        
        [self sendCommentPostRequest];
        [self.commentField setText:nil];
        [self.commentButton setEnabled:NO];
    }
}

- (IBAction)tagButtonPressed:(id)sender{
    UIButton *button = sender;
    
    NSString *tag = button.titleLabel.text;
    
    NSString *objectTag = @"#";
    NSRange objectTagrange = [tag rangeOfString:objectTag];
    if (objectTagrange.location != NSNotFound) {
        
        [self goToPostHashTagFeedViewControllerWithHashTag:tag];

    }
    
    NSString *peopleTag = @"@";
    NSRange peopleTagrange = [tag rangeOfString:peopleTag];
    if (peopleTagrange.location != NSNotFound) {
        [self sendGetAccountInfoByUsername:tag];
    }
    
}

- (IBAction)wantCountButtonPressed:(id)sender {
    [self goToWantedCountViewController:self.post];
}



#pragma mark -
#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0 && self.comments) {
        return [self.comments count];
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SPPostCommentCell";
    SPPostCommentCell *cell = (SPPostCommentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SPPostCommentCell" owner:nil options:nil] objectAtIndex:0 ];
    }
    SPComment *comment = [self.comments objectAtIndex:indexPath.row];
    CGSize maximumCommentLabelSize = CGSizeMake(CGRectGetWidth(cell.commentLabel.frame),1000);
    CGSize expectedCommentLabelSize = [comment.comment sizeWithFont:cell.commentLabel.font constrainedToSize:maximumCommentLabelSize lineBreakMode:cell.commentLabel.lineBreakMode];
    
    
    if (CGRectGetMaxY(cell.commentLabel.frame) > CGRectGetMaxY(cell.accountImageButton.superview.frame)) {
        return CGRectGetMaxY(cell.accountNameButton.frame)+expectedCommentLabelSize.height+LAYOUTMARGIN;
    }else{
        return CGRectGetMaxY(cell.accountNameButton.frame)+expectedCommentLabelSize.height+LAYOUTMARGIN*2;
    }
    
    return CGRectGetMaxY(cell.accountNameButton.frame)+expectedCommentLabelSize.height+LAYOUTMARGIN;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SPPostCommentCell";
    
    SPPostCommentCell *cell = (SPPostCommentCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"SPPostCommentCell" owner:nil options:nil] objectAtIndex:0 ];
    }
    cell.delegate = self;
    cell.comment = [self.comments objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        if (!self.isLastComment) {
            return 50;
        }else{
            if (self.comments.count == 0) {
                return 50;
            }
        }
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 1) {
            [self.footerView setFrame:CGRectMake(0, 0, self.productCommentTableView.frame.size.width, 50)];
            [self.footerView recenterSubviews];
            if (self.isRequestFailed) {
                [self.footerView showReloadButton];
                return self.footerView;
            }
            
            if (!self.isLastComment) {
                [self.footerView showLoading];
                if (!self.isLoading) {
                    [self sendGetProductCommetsRequest];
                }
                return self.footerView;
            }else{
                if (self.comments.count == 0) {
                    [self.footerView showTitleLabel:@"Be the first to comment :)"];
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
        [self.productCommentTableView reloadData];
        [self sendGetProductCommetsRequest];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.commentInputView.frame.size.height;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.commentInputView;
    }
    return nil;
}

#pragma mark -
#pragma mark TextField Delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    if (newLength > 0) {
        self.commentButton.enabled = YES;
    }else{
        self.commentButton.enabled = NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self.productCommentTableView setContentOffset:CGPointMake(0, CGRectGetMinY(self.commentInputView.frame)) animated:YES];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self sendCommentButtonPressed:nil];
    return YES;
}

-(void)handleSingleTap:(UITapGestureRecognizer *)sender{
}

- (BOOL)valiadation
{
    NSString *commentText = [self.commentField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (commentText.length > 0) {
        return YES;
    }
    return NO;
}

#pragma mark - Request Methods

- (void)sendCommentPostRequest
{
    NSString *comment = [self.commentField.text stringByTrimmingTopTailWhitespace];
    [self sendCommentPostRequestWithPostId:self.post.postId comment:comment delegate:self];
}

- (void)SPCommentPostRequestDidFinish:(SPBaseResponseData*)response comment:(NSString *)comment
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
        
        [self.commentField setText:comment];
        [self.commentButton setEnabled:YES];
    }else{
        
        self.post.commentCount++;
        [self adjustProductDesc];
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:self.post forKey:@"post"];
        [SPUtility postSPNotificationWithName:POSTDIDCOMMENT dictionary:userInfo];
        
        _reloading = YES;
        self.isLastComment = NO;
        self.nextKey = nil;
        self.comments = nil;
        [self.productCommentTableView reloadData];
        [self sendGetProductCommetsRequest];
    }
}

- (void)sendGetProductCommetsRequest
{
    self.isRequestFailed = NO;
    self.isLoading = YES;
    
    [self sendGetPostCommentsRequestWithPostId:self.post.postId startKey:self.nextKey delegate:self];
}

- (void)SPGetPostCommentsRequestDidFinish:(SPGetPostCommentsResponseData*)response startKey:(NSString *)startKey
{
    if (_reloading) {
        self.isLastComment = NO;
        self.comments = nil;
        [self.productCommentTableView reloadData];
        [self doneLoadingTableViewData];
    }
    if (response.error) {
        
        self.isRequestFailed = YES;
        
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
        
    }else{
        NSLog(@"Success");
        
        if (self.comments) {
            for (SPComment *toAddComment in response.comments) {
                BOOL included = NO;
                for (SPComment *comment in self.comments) {
                    if ([comment.commentId isEqualToString:toAddComment.commentId]) {
                        included = YES;
                    }
                }
                if (!included) {
                    [self.comments addObject:toAddComment];
                }
                
            }
        }else{
            self.comments = response.comments;
        }
        
        self.nextKey = response.nextKey;
        
        if (!response.nextKey) {
            self.isLastComment = YES;
        }
    }
    [self.productCommentTableView reloadData];
    self.isLoading = NO;
}

- (void)SPPostCommentCellDidSelectAccount:(SPAccount *)account
{
    [self goToProfileViewControllerWithAccount:account];
}

- (void)SBProductCommentCellDidReplyAccount:(SPAccount *)account
{
    NSString *comment = self.commentField.text;
    NSString *newComment = [NSString stringWithFormat:@"%@@%@",comment,account.username];
    [self.commentField setText:newComment];
}


- (void)sendDeleteProductRequest
{
    [self showHUDLoadingViewWithTitle:@"Deleting..."];
    [self sendDeletePostRequestWithPost:self.post repost:NO delegate:self];
}

- (void)SPDeletePostRequestDidFinish:(SPBaseResponseData*)response post:(SPPost *)post
{
    [self hideHUDLoadingView];
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
    }else{
        NSLog(@"Success");
        NSDictionary *dictionary = [NSDictionary dictionaryWithObject:self.post forKey:@"post"];
        [SPUtility postSPNotificationWithName:POSTDIDDELETE dictionary:dictionary];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)sendGetAccountInfoByUsername:(NSString *)username
{
    [self showHUDLoadingViewWithTitle:@"Loading..."];
    NSString *tag = [username stringByReplacingOccurrencesOfString:@"@" withString:@""];
    [self sendGetAccountInfoByUsernameRequestWithUsername:tag delegate:self];
}

- (void)SPGetAccountInfoByUsernameRequestDidFinish:(SPGetAccountInfoResponseData*)response
{
    [self hideHUDLoadingView];
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
    }else{
        NSLog(@"Success");
        [self goToProfileViewControllerWithAccount:response.account];
    }
}

#pragma mark -
#pragma mark EGORefreshTableHeaderDelegate Methods

- (void)reloadTableViewDataSource{
	_reloading = YES;
    self.nextKey = nil;
    [self sendGetProductCommetsRequest];
}

- (void)doneLoadingTableViewData{
    
    _reloading = NO;
    if (_refreshHeaderView && self.productCommentTableView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.productCommentTableView];
    }
}

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view{
	[self reloadTableViewDataSource];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	return _reloading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
	
	return [NSDate date]; // should return date data source was last changed
	
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Delete"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirmation Deletion" message:@"Delete this item?" delegate:self cancelButtonTitle:@"Don't delete" otherButtonTitles:@"Delete",nil];
        [alert show];
        [alert release];
    }else if ([title isEqualToString:@"Go To website"]){
        [self productURLButtonPressed:nil];
    }else if ([title isEqualToString:@"Report Inappropriate"]){
        UIActionSheet *actionSheet = [[[UIActionSheet alloc]initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Inappropriate Content",@"Item Not Available",@"With Incorrect Price",@"With Bad Image",nil]
                                      autorelease];
        [actionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
    }else if ([title isEqualToString:@"Repict"]){
        [self showHUDViewWithRepost];
        [self repostPost:self.post repost:YES];
    }else if ([title isEqualToString:@"Repict With Comment"]){
        [self showRepostViewControllerWithPost:self.post];
    }else if ([title isEqualToString:@"Undo Repict"]){
        [self repostPost:self.post repost:NO];
    }else if ([title isEqualToString:@"Inappropriate Content"]){
        [self showHUDLoadingViewWithTitle:@"Reporting"];
        [self sendReportPostRequestWithPost:self.post delegate:self type:INAPPROPRIATECONTENT];
    }else if ([title isEqualToString:@"Item Not Available"]){
        [self showHUDLoadingViewWithTitle:@"Reporting"];
        [self sendReportPostRequestWithPost:self.post delegate:self type:NOTAVAILABLE];
    }else if ([title isEqualToString:@"With Incorrect Price"]){
        [self showHUDLoadingViewWithTitle:@"Reporting"];
        [self sendReportPostRequestWithPost:self.post delegate:self type:INCORRECTPRICE];
    }else if ([title isEqualToString:@"With Bad Image"]){
        [self showHUDLoadingViewWithTitle:@"Reporting"];
        [self sendReportPostRequestWithPost:self.post delegate:self type:BADIMAGE];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Delete"]) {
        [self sendDeleteProductRequest];
    }
}

- (void)SPReportPostRequestDidFinish:(SPBaseResponseData*)response
{
    [self hideHUDLoadingView];
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
    }else{
        [self showHUDTickViewWithMessage:@"Report'd. Thanks!"];
    }
}

#pragma mark - Notification-

- (void)postDidWant:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPPost *post = [dictionary objectForKey:@"post"];
    if ([self.post.postId isEqualToString:post.postId]) {
        self.post = post;
    }
    [self adjustProductDesc];
}

- (void)postDidUnwant:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPPost *post = [dictionary objectForKey:@"post"];
    if ([self.post.postId isEqualToString:post.postId]) {
        self.post = post;
    }
    [self adjustProductDesc];
}

- (void)postDidRepost:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPPost *post = [dictionary objectForKey:@"post"];
    if ([self.post.product.productId isEqualToString:post.product.productId]) {
        self.post.isReposted = YES;
    }
    [self adjustProductDesc];
}

- (void)postDidUnrepost:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPPost *post = [dictionary objectForKey:@"post"];
    if ([self.post.product.productId isEqualToString:post.product.productId]) {
        self.post.isReposted = NO;
    }
    [self adjustProductDesc];
}

- (void)accountDidUpdate:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPAccount *account = [dictionary objectForKey:@"account"];
    
    for (SPComment *comment in self.comments) {
        if ([comment.account.accountId isEqualToString:account.accountId]) {
            comment.account = account;
        }
    }
    if ([self.post.author.accountId isEqualToString:account.accountId]) {
        self.post.author = account;
    }
    if ([self.post.product.account.accountId isEqualToString:account.accountId]) {
        self.post.product.account = account;
    }
}

- (void)accountDidUpdateForPost:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPAccount *account = [dictionary objectForKey:@"account"];
    for (SPComment *comment in self.comments) {
        if ([comment.account.accountId isEqualToString:account.accountId]) {
            comment.account = account;
        }
    }
    if ([self.post.author.accountId isEqualToString:account.accountId]) {
        self.post.author = account;
    }
    if ([self.post.product.account.accountId isEqualToString:account.accountId]) {
        self.post.product.account = account;
    }
}

- (void)postDidComment:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPPost *post = [dictionary objectForKey:@"post"];
    if ([self.post.postId isEqualToString:post.postId]) {
        self.post = post;
        [self adjustProductDesc];
    }
}

- (void)accountDidFollow:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPAccount *account = [dictionary objectForKey:@"account"];
    
    for (SPComment *comment in self.comments) {
        if ([comment.account.accountId isEqualToString:account.accountId]) {
            comment.account = account;
        }
    }
    if ([self.post.author.accountId isEqualToString:account.accountId]) {
        self.post.author = account;
    }
    if ([self.post.product.account.accountId isEqualToString:account.accountId]) {
        self.post.product.account = account;
    }
}

- (void)accountDidUnfollow:(NSNotification *)notification
{
    NSDictionary *dictionary = [notification userInfo];
    SPAccount *account = [dictionary objectForKey:@"account"];
    
    for (SPComment *comment in self.comments) {
        if ([comment.account.accountId isEqualToString:account.accountId]) {
            comment.account = account;
        }
    }
    if ([self.post.author.accountId isEqualToString:account.accountId]) {
        self.post.author = account;
    }
    if ([self.post.product.account.accountId isEqualToString:account.accountId]) {
        self.post.product.account = account;
    }
}

- (void)selectedMention:(NSString *)string {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Selected" message:string delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    [alert show];
}
- (void)selectedHashtag:(NSString *)string {
    [self goToPostHashTagFeedViewControllerWithHashTag:string];
}
- (void)selectedLink:(NSString *)string {
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Selected" message:string delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//    [alert show];
}

- (void)handleTweetNotification:(NSNotification *)notification
{
    if ([self isShown]) {
        NSLog(@"handleTweetNotification: notification = %@", notification);
        NSString *tag = notification.object;
        [self goToPostHashTagFeedViewControllerWithHashTag:tag];
    }
}


@end
