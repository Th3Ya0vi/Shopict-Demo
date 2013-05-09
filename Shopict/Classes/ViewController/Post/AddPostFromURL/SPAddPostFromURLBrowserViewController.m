//
//  SPAddPostFromURLBrowserViewController.m
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年3月28日.
//  Copyright (c) 1413年 Shopict. All rights reserved.
//

#import "SPAddPostFromURLBrowserViewController.h"
#import "SPBaseViewController+SPViewControllerUtility.h"
#import <QuartzCore/QuartzCore.h>
#import "UIButton+SPButtonUtility.h"
#import "NSString+SPStringUtility.h"
#import "UIImageView+WebCache.h"
#import "NSString+SPStringUtility.h"

@interface SPAddPostFromURLBrowserViewController ()

@end

@implementation SPAddPostFromURLBrowserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.hidesBottomBarWhenPushed = YES;
        self.navigationItem.title = @"FROM LINK";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.loadingView.hidden = YES;
    self.reloadButton.hidden = NO;
    self.previousButton.enabled = self.webView.canGoBack;
    self.nextButton.enabled = self.webView.canGoForward;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
#ifdef __IPHONE_5_0
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
#endif

    [self.webView.scrollView setDelegate:self];
    
    if (self.websiteURL) {
        [self.navigationItem setRightBarButtonItem:nil];
        self.navigationItem.title = self.websiteURL;
        NSString *urlAddress = self.websiteURL;
        BOOL result = [[urlAddress lowercaseString] hasPrefix:@"http://"]||[[urlAddress lowercaseString] hasPrefix:@"https://"];
        if (!result) {
            urlAddress = [NSString stringWithFormat:@"http://redirect.viglink.com/?key=ac40c65a20678b2d5fdeb764f2c68058&out=http://%@", urlAddress];
        }else{
            urlAddress = [NSString stringWithFormat:@"http://redirect.viglink.com/?key=ac40c65a20678b2d5fdeb764f2c68058&out=%@", urlAddress];
        }
        self.websiteURL = urlAddress;
        NSURL *url = [NSURL URLWithString:urlAddress];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:requestObj];
    }else{
        UIButton *addPostButton = [UIButton longBarButtonItemWithTitle:@"Pict"];
        [addPostButton addTarget:self action:@selector(addPictButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *addPostButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addPostButton];
        [self.navigationItem setRightBarButtonItem:addPostButtonItem];
        [addPostButton release];
        [self.urlTextField becomeFirstResponder];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.imageSelectionView.hidden = YES;
    if (!self.websiteURL){
        UIButton *addPostButton = [UIButton longBarButtonItemWithTitle:@"Pict"];
        [addPostButton addTarget:self action:@selector(addPictButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *addPostButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addPostButton];
        [self.navigationItem setRightBarButtonItem:addPostButtonItem];
        [addPostButton release];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_websiteURL release];
    [_URLView release];
    [_previousButton release];
    [_nextButton release];
    [_loadingView release];
    [_reloadButton release];
    [_webView release];
    [_urlTextField release];
    [_imageSelectionView release];
    [_imageSelectionPageControl release];
    [_imageSelectionContentView release];
    [_imageSelectionScrollView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setURLView:nil];
    [self setPreviousButton:nil];
    [self setNextButton:nil];
    [self setLoadingView:nil];
    [self setReloadButton:nil];
    [self setWebView:nil];
    [self setUrlTextField:nil];
    [self setImageSelectionView:nil];
    [self setImageSelectionPageControl:nil];
    [self setImageSelectionContentView:nil];
    [self setImageSelectionScrollView:nil];
    [super viewDidUnload];
}

- (void)keyboardWillShow:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:keyboardRect fromView:[[UIApplication sharedApplication] keyWindow]];
    CGFloat keyboardHeight = keyboardFrame.size.height;
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [self.webView.scrollView setContentInset:UIEdgeInsetsMake(0, 0, keyboardHeight+self.URLView.frame.size.height, 0)];
    if (self.urlTextField.isFirstResponder) {
        [self.URLView setFrame:CGRectMake(0, self.view.frame.size.height-keyboardHeight-self.URLView.frame.size.height, self.URLView.frame.size.width,self.URLView.frame.size.height)];
    }
    [UIView commitAnimations];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:animationDuration];
    [self.webView.scrollView setContentInset:UIEdgeInsetsMake(0, 0, 44, 0)];
    [self.URLView setFrame:CGRectMake(0, self.view.frame.size.height, self.URLView.frame.size.width,self.URLView.frame.size.height)];
    [UIView commitAnimations];
}

- (IBAction)keyboardButtonPressed:(id)sender {
    [self.urlTextField becomeFirstResponder];
}

- (IBAction)goButtonPressed:(id)sender {
    NSString *urlAddress = self.urlTextField.text;
    
    BOOL result = [[urlAddress lowercaseString] hasPrefix:@"http://"]||[[urlAddress lowercaseString] hasPrefix:@"https://"];
    if (!result) {
        urlAddress = [NSString stringWithFormat:@"http://redirect.viglink.com/?key=ac40c65a20678b2d5fdeb764f2c68058&out=http://%@", urlAddress];
    }else{
        urlAddress = [NSString stringWithFormat:@"http://redirect.viglink.com/?key=ac40c65a20678b2d5fdeb764f2c68058&out=%@", urlAddress];
    }
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    [self.urlTextField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *urlAddress = self.urlTextField.text;
    
    BOOL result = [[urlAddress lowercaseString] hasPrefix:@"http://"]||[[urlAddress lowercaseString] hasPrefix:@"https://"];
    if (!result) {
        urlAddress = [NSString stringWithFormat:@"http://redirect.viglink.com/?key=ac40c65a20678b2d5fdeb764f2c68058&out=http://%@", urlAddress];
    }else{
        urlAddress = [NSString stringWithFormat:@"http://redirect.viglink.com/?key=ac40c65a20678b2d5fdeb764f2c68058&out=%@", urlAddress];
    }
    NSURL *url = [NSURL URLWithString:urlAddress];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:requestObj];
    [self.urlTextField resignFirstResponder];
    return NO;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.loadingView.hidden = YES;
    self.reloadButton.hidden = NO;
    self.previousButton.enabled = self.webView.canGoBack;
    self.nextButton.enabled = self.webView.canGoForward;
    
    if ([error code] != -999) {
        [self showHUDErrorViewWithMessage:@"Failed"];
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    self.loadingView.hidden = NO;
    [self.loadingView.layer removeAllAnimations];
    self.loadingView.hidden = NO;
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * 10.0 ];
    rotationAnimation.duration = 10.0;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = NSIntegerMax;
    [self.loadingView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    [CATransaction commit];
    
    self.reloadButton.hidden = YES;
    self.previousButton.enabled = self.webView.canGoBack;
    self.nextButton.enabled = self.webView.canGoForward;
    self.urlTextField.text = self.webView.request.URL.absoluteString;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (self.websiteURL) {
        self.navigationItem.title = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
    
    if ([self.webView.request.URL.absoluteString isEqualToString:self.websiteURL]) {
        [self.navigationItem setRightBarButtonItem:nil];
    }else{
        if (self.imageSelectionView.hidden) {
            UIButton *addPostButton = [UIButton longBarButtonItemWithTitle:@"Pict"];
            [addPostButton addTarget:self action:@selector(addPictButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *addPostButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addPostButton];
            [self.navigationItem setRightBarButtonItem:addPostButtonItem];
            [addPostButton release];
        }
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    self.loadingView.hidden = YES;
    self.reloadButton.hidden = NO;
    self.previousButton.enabled = self.webView.canGoBack;
    self.nextButton.enabled = self.webView.canGoForward;
    if (![self.urlTextField isFirstResponder]) {
        self.urlTextField.text = self.webView.request.URL.absoluteString;
    }
}

- (IBAction)goBackButtonPressed:(id)sender {
    [self.webView goBack];
}

- (IBAction)reloadButtonPressed:(id)sender {
    [self.webView reload];
}

- (IBAction)goNextButtonPressed:(id)sender {
    [self.webView goForward];
}

- (IBAction)addPictButtonPressed:(id)sender {
    
    if ([self.webView.request.URL.absoluteString isValid]) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Pict this item?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        alertView.tag = 1;
        [alertView show];
        [alertView release];
    }
}

- (NSMutableArray *)arrayForExtrationOfImagesRegularExpression:(NSString *)regularExpression text:(NSString *)text
{
    
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regularExpression
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *matches = [regex matchesInString:text
                                      options:0
                                        range:NSMakeRange(0, [text length])];
    NSMutableArray *imagesURLs = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        NSString *imgUrl = [text substringWithRange:[match rangeAtIndex:0]];
        [imagesURLs addObject:imgUrl];
    }
    return imagesURLs;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex == 1) {
            
            NSString *html = [self.webView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"];
            
            NSString *script = @"var n = document.images.length; var names = [];"
            "for (var i = 0; i < n; i++) {"
            "     names.push(document.images[i].src);"
            "} String(names);";
            NSString *urls = [self.webView stringByEvaluatingJavaScriptFromString:script];
            NSLog(@"Image urls = %@",urls);
            
            NSArray *JSarray = [urls componentsSeparatedByString:@","];
            
            NSMutableArray *imagesURLs = [NSMutableArray array];
            
            NSMutableArray *imageArrayFromFirstRegex = [self arrayForExtrationOfImagesRegularExpression:@"(//[a-z\\-_0-9\\/\\:\\.\\!\\$\\,\\=\\(\\)\\~]*\\.(jpg|jpeg|png|PNG|JPG|JPEG))" text:html];
            
            for (NSString *match in imageArrayFromFirstRegex) {
                NSString *imgUrl = [NSString stringWithFormat:@"http:%@",match];
                NSRange avatarTextRange =[[imgUrl lowercaseString] rangeOfString:[@"avatar" lowercaseString]];
                if(avatarTextRange.location == NSNotFound)
                {
                    BOOL notIncluded = YES;
                    for (NSString *url in imagesURLs) {
                        if ([[url lowercaseString]isEqualToString:[imgUrl lowercaseString]]) {
                            notIncluded = NO;
                        }else if ([[imgUrl lowercaseString]isEqualToString:[@"http://assets.pinterest.com/images/PinExt.png" lowercaseString]]) {
                            notIncluded = NO;
                        }else if ([[imgUrl lowercaseString]isEqualToString:[@"http://wanelo.com/assets/save-it-button.png" lowercaseString]]) {
                            notIncluded = NO;
                        }else if ([[imgUrl lowercaseString]isEqualToString:[@"http://s3.amazonaws.com/thefancy/_ui/images/fancy_it1.png" lowercaseString]]) {
                            notIncluded = NO;
                        }
                    }
                    if (notIncluded) {
                        if (imagesURLs.count < 14) {
                            [imagesURLs addObject:imgUrl];
                        }else{
                            break;
                        }
                    }
                }
            }
            
            NSMutableArray *imageArrayFromSecondRegex = [self arrayForExtrationOfImagesRegularExpression:@"(src=\"[a-z\\-_0-9\\/\\:\\.\\!\\$\\,\\=\\(\\)\\~]*\\.(jpg|jpeg|png|PNG|JPG|JPEG))" text:html];
            
            if (imagesURLs.count < 14 && imageArrayFromSecondRegex.count>0) {
                NSString *websiteURL = self.webView.request.URL.absoluteString;
                if ([[websiteURL lowercaseString]hasPrefix:@"http://"]) {
                    websiteURL = [websiteURL stringByReplacingOccurrencesOfString:@"http://" withString:@""];
                }
                if ([[websiteURL lowercaseString]hasPrefix:@"https://"]) {
                    websiteURL = [websiteURL stringByReplacingOccurrencesOfString:@"https://" withString:@""];
                }
                NSArray *urlComponents = [websiteURL componentsSeparatedByString:@"/"];
                
                
                for (NSString *match in imageArrayFromSecondRegex) {
                    NSString *matchPart = [match stringByReplacingOccurrencesOfString:@"src=\"" withString:@""];
                    for (NSInteger i = 0; i < 5; i++) {
                        matchPart = [matchPart stringByReplacingOccurrencesOfString:@"//" withString:@"/"];
                    }
                    NSString *imgUrl = [NSString stringWithFormat:@"http://%@/%@",[urlComponents objectAtIndex:0],matchPart];
                    
                    NSRange avatarTextRange =[[imgUrl lowercaseString] rangeOfString:[@"avatar" lowercaseString]];
                    NSRange dotTextRange =[[imgUrl lowercaseString] rangeOfString:[@".." lowercaseString]];
                    if(dotTextRange.location == NSNotFound && avatarTextRange.location == NSNotFound)
                    {
                        BOOL notIncluded = YES;
                        for (NSString *url in imagesURLs) {
                            if ([[url lowercaseString]isEqualToString:[imgUrl lowercaseString]]) {
                                notIncluded = NO;
                            }else if ([[imgUrl lowercaseString]isEqualToString:[@"http://assets.pinterest.com/images/PinExt.png" lowercaseString]]) {
                                notIncluded = NO;
                            }else if ([[imgUrl lowercaseString]isEqualToString:[@"http://wanelo.com/assets/save-it-button.png" lowercaseString]]) {
                                notIncluded = NO;
                            }else if ([[imgUrl lowercaseString]isEqualToString:[@"http://s3.amazonaws.com/thefancy/_ui/images/fancy_it1.png" lowercaseString]]) {
                                notIncluded = NO;
                            }else if ([[url lowercaseString] rangeOfString:[[match stringByReplacingOccurrencesOfString:@"src=\"" withString:@""] lowercaseString]].location != NSNotFound){
                                notIncluded = NO;
                            }
                        }
                        if (notIncluded) {
                            if (imagesURLs.count < 14) {
                                [imagesURLs addObject:imgUrl];
                            }else{
                                break;
                            }
                        }
                    }
                }
            }
            
            for (NSString *imgUrl in JSarray) {
                BOOL notIncluded = YES;
                for (NSString *url in imagesURLs) {
                    if ([[url lowercaseString]isEqualToString:[imgUrl lowercaseString]]) {
                        notIncluded = NO;
                    }else if ([[imgUrl lowercaseString]isEqualToString:[@"http://assets.pinterest.com/images/PinExt.png" lowercaseString]]) {
                        notIncluded = NO;
                    }else if ([[imgUrl lowercaseString]isEqualToString:[@"http://wanelo.com/assets/save-it-button.png" lowercaseString]]) {
                        notIncluded = NO;
                    }else if ([[imgUrl lowercaseString]isEqualToString:[@"http://s3.amazonaws.com/thefancy/_ui/images/fancy_it1.png" lowercaseString]]) {
                        notIncluded = NO;
                    }
                }
                if (notIncluded) {
                    if (imagesURLs.count < 14) {
                        [imagesURLs addObject:imgUrl];
                    }else{
                        break;
                    }
                }
            }
            
            for (NSString *url in imagesURLs) {
                NSLog(@"save = %@",url);
            }
            
            if (imagesURLs.count == 0) {
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"" message:@"No image is found. Do you want to continue to pict this item?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
                alertView.tag = 2;
                [alertView show];
                [alertView release];
                return;
            }
            
            if (!self.selectedImageViews) {
                self.selectedImageViews = [NSMutableArray array];
            }
            if (!self.imageSelectionImageViews) {
                self.imageSelectionImageViews = [NSMutableArray array];
            }
            [self.selectedImageViews removeAllObjects];
            [self.imageSelectionImageViews removeAllObjects];
            
            UIButton *cancelButton = [UIButton longBarButtonItemWithTitle:@"Cancel"];
            [cancelButton addTarget:self action:@selector(hideSelectionView:) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *cancelButtonItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
            [self.navigationItem setRightBarButtonItem:cancelButtonItem];
            [cancelButton release];
            
            self.imageSelectionView.hidden = NO;
            [self.imageSelectionContentView setCenter:self.imageSelectionView.center];
            [[self.imageSelectionScrollView subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.imageSelectionScrollView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
            
            NSInteger imagesNumber = imagesURLs.count;
            if (imagesNumber <= 1) {
                [self.imageSelectionPageControl setHidden:YES];
            }else{
                [self.imageSelectionPageControl setHidden:NO];
                [self.imageSelectionPageControl setNumberOfPages:imagesNumber];
                [self.imageSelectionPageControl setCurrentPage:0];
            }
            
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.imageSelectionScrollView.frame.size.width * imagesNumber, self.imageSelectionScrollView.frame.size.height)];
            CGPoint startPoint = CGPointZero;
            
            for (NSInteger i = 0; i<imagesNumber; i++) {
                //Add UIActivityIndicatorView
                UIActivityIndicatorView * activityIndicator = [[[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(startPoint.x, startPoint.y, self.imageSelectionScrollView.frame.size.width, self.imageSelectionScrollView.frame.size.height)]autorelease];
                [activityIndicator setHidesWhenStopped:YES];
                [activityIndicator setActivityIndicatorViewStyle: UIActivityIndicatorViewStyleWhiteLarge];
                [view addSubview:activityIndicator];
                [activityIndicator startAnimating];
                
                //Add Image
                UIImageView *imageView = [[UIImageView alloc]init];
                [imageView setFrame:CGRectMake(startPoint.x+5, startPoint.y+5, self.imageSelectionScrollView.frame.size.width-10, self.imageSelectionScrollView.frame.size.height-10)];
                imageView.tag = i;
                imageView.clipsToBounds = YES;
                [imageView setContentMode:UIViewContentModeScaleAspectFit];
                [imageView setImageWithURL:[imagesURLs objectAtIndex:i] placeholderImage:nil options:SDWebImageCacheMemoryOnly completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                    [activityIndicator stopAnimating];
                    [activityIndicator setHidden:YES];
                }];
                [view addSubview:imageView];
                [self.imageSelectionImageViews addObject:imageView];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                [button setFrame:imageView.frame];
                [button setImage:[UIImage imageNamed:@"button_select_tick"] forState:UIControlStateSelected];
                [button setImage:[UIImage imageNamed:@"button_select_tick"] forState:UIControlStateSelected|UIControlStateHighlighted];
                [button addTarget:self action:@selector(selectImageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
                button.tag = i;
                [view addSubview:button];
                
                [imageView release];
                
                startPoint.x = startPoint.x+self.imageSelectionScrollView.frame.size.width;
            }
            self.imageSelectionScrollView.contentSize = view.frame.size;
            [self.imageSelectionScrollView addSubview:view];
            self.imageSelectionScrollView.pagingEnabled = YES;
            self.imageSelectionScrollView.backgroundColor = [UIColor clearColor];
            self.imageSelectionScrollView.showsHorizontalScrollIndicator = NO;
            self.imageSelectionScrollView.showsVerticalScrollIndicator = NO;
            self.imageSelectionScrollView.scrollsToTop = NO;
            self.imageSelectionScrollView.delegate = self;
            [view release];
        }
    }else if (alertView.tag == 2){
        if (buttonIndex == 1) {
            [self finishImageSelectionButtonPressed:nil];
        }
    }
}

- (IBAction)hideSelectionView:(id)sender
{
    self.imageSelectionView.hidden = YES;
    UIButton *addPostButton = [UIButton longBarButtonItemWithTitle:@"Pict"];
    [addPostButton addTarget:self action:@selector(addPictButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addPostButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addPostButton];
    [self.navigationItem setRightBarButtonItem:addPostButtonItem];
    [addPostButton release];

}

- (IBAction)selectImageButtonPressed:(id)sender
{
    UIButton *button = sender;
    UIImageView *imageView = [self.imageSelectionImageViews objectAtIndex:button.tag];
    if (imageView.image) {
        if (button.selected == YES) {
            
            NSMutableArray *includedImageViews = [NSMutableArray array];
            
            for (UIImageView *imageView in self.selectedImageViews) {
                if (imageView.tag == button.tag) {
                    [includedImageViews addObject:imageView];
                }
            }
            
            if (includedImageViews.count > 0) {
                for (UIImageView *imageView in includedImageViews) {
                    [self.selectedImageViews removeObject:imageView];
                }
            }
            
            button.selected = NO;
        }else{
            if (self.selectedImageViews.count >=4) {
                [self showHUDErrorViewWithMessage:@"At most 4 picts."];
                return;
            }
            button.selected = YES;
            [self.selectedImageViews addObject:imageView];
        }
    }
}

- (IBAction)finishImageSelectionButtonPressed:(id)sender {
    
    UIButton *addPostButton = [UIButton longBarButtonItemWithTitle:@"Pict"];
    [addPostButton addTarget:self action:@selector(addPictButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *addPostButtonItem = [[UIBarButtonItem alloc] initWithCustomView:addPostButton];
    [self.navigationItem setRightBarButtonItem:addPostButtonItem];
    [addPostButton release];
    
    self.imageSelectionView.hidden = YES;
    
    NSNumber *websitePrice = nil;
    NSString *websiteTitle = nil;
    NSString *websiteURL = nil;
    NSString *websiteCurrency = nil;
    
    NSString *html = [self.webView stringByEvaluatingJavaScriptFromString: @"document.body.innerHTML"];
    
    websitePrice = [self priceExtractFromText:html currenySymbol:@"$"];
    websiteCurrency = @"USD";
    if (!websitePrice) {
        websitePrice = [self priceExtractFromText:html currenySymbol:@"€"];
        websiteCurrency = @"EUR";
    }
    if (!websitePrice) {
        websitePrice = [self priceExtractFromText:html currenySymbol:@"£"];
        websiteCurrency = @"GBP";
    }
    if (!websitePrice) {
        websitePrice = [self priceExtractFromText:html currenySymbol:@"¥"];
        websiteCurrency = @"JPY";
    }
    
    websiteTitle = [self.webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    websiteTitle = [[websiteTitle componentsSeparatedByString:@"|"]objectAtIndex:0];
    websiteURL = self.webView.request.URL.absoluteString;
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    if (websitePrice) {
        [dictionary setValue:websitePrice forKey:@"price"];
        [dictionary setValue:websiteCurrency forKey:@"currency"];
    }
    
    if (websiteTitle) {
        [dictionary setValue:websiteTitle forKey:@"title"];
    }
    
    if (websiteURL) {
        [dictionary setValue:websiteURL forKey:@"url"];
    }
    
    if (self.selectedImageViews.count > 0) {
        NSMutableArray *images = [NSMutableArray array];
        for (UIImageView *imageView in self.selectedImageViews) {
            [images addObject:imageView.image];
        }
        [dictionary setValue:images forKey:@"images"];
    }
    
    [self showAddPostFromURLViewControllerWithWebsite:dictionary];
    
}


- (IBAction)safariButtonPressed:(id)sender {
    NSString *currentURL = self.webView.request.URL.absoluteString;
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:currentURL]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.urlTextField resignFirstResponder];
    
    if ([scrollView isEqual:self.imageSelectionScrollView]) {
        CGFloat pageWidth = scrollView.frame.size.width;
        int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        [self loadFeaturedImageWithPage:page - 1];
        [self loadFeaturedImageWithPage:page];
        [self loadFeaturedImageWithPage:page + 1];
    }
}

- (void)loadFeaturedImageWithPage:(NSInteger) page
{
    [self.imageSelectionPageControl setCurrentPage:page-1];
    
    if (page < 0)
    {
        return;
    }
    
    if (page >= self.imageSelectionPageControl.numberOfPages)
    {
        return;
    }
}

- (NSNumber *)priceExtractFromText:(NSString *)text currenySymbol:(NSString *)currenySymbol
{
    NSNumber *price = nil;
    NSString *priceRegex = [NSString stringWithFormat:@"\\%@\\d+(?:\\.\\d+)?",currenySymbol];
    NSRange USDPriceRange = [text rangeOfString:priceRegex options:NSRegularExpressionSearch];
    if (USDPriceRange.location != NSNotFound){
        NSNumberFormatter * formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        price = [formatter numberFromString:[[text substringWithRange:USDPriceRange]stringByReplacingOccurrencesOfString:currenySymbol withString:@""]];
        if ([price floatValue]==0) {
            return nil;
        }
        [formatter release];
    }
    return price;
}

@end
