//
//  UIButton+SPButtonUtility.h
//  SP
//
//  Created by bichenkk on 13年2月18日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (SPButtonUtility)

+ (UIButton *)barButtonItemWithTitle:(NSString *)title;
+ (UIButton *)longBarButtonItemWithTitle:(NSString *)title;
+ (UIButton *)barButtonItemWithImage:(UIImage *)image;

@end