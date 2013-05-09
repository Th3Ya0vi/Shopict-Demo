//
//  SPTableViewFooterView.m
//  SP
//
//  Created by bichenkk on 13年2月21日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPTableViewFooterView.h"
#import "SPLoadingView.h"

@implementation SPTableViewFooterView

- (id)init
{
    self = [super init];
    if (self) {
        SPLoadingView *loadingView = [SPLoadingView loadingView];
        self.loadingView = loadingView;
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 40)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0];
        [label setShadowOffset:CGSizeMake(0, 1)];
        [label setShadowColor:[UIColor whiteColor]];
        label.text = @"Shopict";
        
        label.textAlignment = UITextAlignmentCenter;
        label.textColor = [UIColor darkGrayColor];
        label.adjustsFontSizeToFitWidth=YES;
        label.minimumFontSize=15;
        label.numberOfLines=1;
        self.titleLabel = label;
        [label release];
        
        UIButton *reloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [reloadButton setFrame:CGRectMake(0, 0, 150, 40)];
        [reloadButton setBackgroundColor:[UIColor clearColor]];
        [reloadButton setImage:[UIImage imageNamed:@"button_reload"] forState:UIControlStateNormal];
        [reloadButton setTitle:@"Tap to reload" forState:UIControlStateNormal];
        [reloadButton.titleLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:15]];
        [reloadButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [reloadButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [reloadButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
        [reloadButton setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [reloadButton.titleLabel setShadowOffset:CGSizeMake(0, 1)];
        [reloadButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [reloadButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 10)];
        [reloadButton addTarget:self action:@selector(reloadButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.reloadButton = reloadButton;
        
        [self addSubview:self.loadingView];
        [self addSubview:self.reloadButton];
        [self addSubview:self.titleLabel];
        
        [self recenterSubviews];
    }
    return self;
}

+ (SPTableViewFooterView *)footerView
{
    return [[[self alloc]init]autorelease];
}

- (void)recenterSubviews
{
    [self.loadingView setCenter:self.center];
    [self.reloadButton setCenter:self.center];
    [self.titleLabel setCenter:self.center];
}

- (void)showLoading
{
    self.loadingView.hidden = NO;
    self.reloadButton.hidden = YES;
    self.titleLabel.hidden = YES;
    [self recenterSubviews];
    [self.loadingView startAnimation];
}

- (void)restartLoadingAnimation
{
    [self recenterSubviews];
    if (self.loadingView.hidden == NO &&
        self.reloadButton.hidden == YES &&
        self.titleLabel.hidden == YES) {
        [self.loadingView startAnimation];
    }
}

- (void)showReloadButton
{
    [self recenterSubviews];
    self.loadingView.hidden = YES;
    self.reloadButton.hidden = NO;
    self.titleLabel.hidden = YES;
}

- (void)showTitleLabel:(NSString *)title
{
    [self recenterSubviews];
    self.loadingView.hidden = YES;
    self.reloadButton.hidden = YES;
    self.titleLabel.hidden = NO;
    [self.titleLabel setText:title];
}

- (IBAction)reloadButtonPressed:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(SPTableViewFooterViewDidSelectReload)]) {
        [self.delegate SPTableViewFooterViewDidSelectReload];
    }
}

- (void)dealloc
{
    [_titleLabel release];
    [_loadingView release];
    [_reloadButton release];
    [super dealloc];
}



@end
