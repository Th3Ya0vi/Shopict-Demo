//
//  SPWebSupportViewController.h
//  Shopict
//
//  Created by Bi Chen Ka Kit on 13年4月5日.
//  Copyright (c) 2013年 Shopict. All rights reserved.
//

#import "SPBaseTabbedViewController.h"

@interface SPWebSupportViewController : SPBaseTabbedViewController

@property (retain, nonatomic) NSString *websiteURL;
@property (retain, nonatomic) IBOutlet UIWebView *webView;

@end
