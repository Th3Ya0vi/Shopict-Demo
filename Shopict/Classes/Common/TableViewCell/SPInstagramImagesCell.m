//
//  SPInstagramImagesCell.m
//  SHOPBOOK
//
//  Created by bichenkk on 13年1月25日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPInstagramImagesCell.h"
#import "UIButton+WebCache.h"

@implementation SPInstagramImagesCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.imageButtons = [self.imageButtons sortedArrayWithOptions:NSSortStable
                                                  usingComparator:^NSComparisonResult(UIButton *obj1, UIButton *obj2) {
                                                      if (obj1.tag > obj2.tag) {
                                                          return NSOrderedDescending;
                                                      } else if (obj1.tag < obj2.tag) {
                                                          return NSOrderedAscending;
                                                      }
                                                      return NSOrderedSame;
                                                  }];
    
    for (UIButton *button in self.imageButtons) {
        [button addTarget:self action:@selector(imageButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setImageUrls:(NSMutableArray *)imageUrls
{
    if (_imageUrls != imageUrls) {
        [_imageUrls release];
        _imageUrls = [imageUrls retain];
        
    }
    
    for (UIButton *button in self.imageButtons) {
        [button setHidden:YES];
    }
    
    for (NSInteger i = 0; i < self.imageUrls.count; i++) {
        NSString *url = [self.imageUrls objectAtIndex:i];
        UIButton *button = [self.imageButtons objectAtIndex:i];
        [button setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
        [button setHidden:NO];
    }
}

- (IBAction)imageButtonPressed:(id)sender
{
    UIButton *button = sender;
    if ([self.delegate respondsToSelector:@selector(SPInstagramImagesCellDidSelectImage:)]) {
        NSString *imageUrl = [self.imageUrls objectAtIndex:button.tag];
        [self.delegate SPInstagramImagesCellDidSelectImage:imageUrl];
    }
}

@end
