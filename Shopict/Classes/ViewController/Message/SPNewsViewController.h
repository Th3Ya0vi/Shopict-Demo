//
//  SPNewsViewController.h
//  SP
//
//  Created by bichenkk on 13年2月18日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPBaseTabbedViewController.h"

@class SPTableViewFooterView;
@interface SPNewsViewController : SPBaseTabbedViewController
<UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate>

//Product feed table
@property (retain, nonatomic) IBOutlet UITableView *newsTableView;

//Products from server
@property (retain, nonatomic) NSMutableArray *news;

//Key to get the next products
@property (retain, nonatomic) NSString *nextKey;

//No more products to get
@property (assign, nonatomic) BOOL isLastPost;

//Is waiting for a request to response
@property (assign, nonatomic) BOOL isLoading;
@property (assign, nonatomic) BOOL isRequestFailed;

@property (nonatomic, retain) SPTableViewFooterView *footerView;


@end
