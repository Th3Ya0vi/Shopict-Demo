//
//  SPInstagramImagesCell.h
//  SHOPBOOK
//
//  Created by bichenkk on 13年1月25日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SPInstagramImagesCellDelegate <NSObject>

- (void)SPInstagramImagesCellDidSelectImage:(NSString *)imageUrl;

@end

@interface SPInstagramImagesCell : UITableViewCell

@property (assign, nonatomic) id delegate;
@property (retain, nonatomic) IBOutletCollection (UIButton) NSArray *imageButtons;
@property (retain, nonatomic) NSMutableArray *imageUrls;

@end
