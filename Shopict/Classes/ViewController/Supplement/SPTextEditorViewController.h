//
//  SBTextEditorViewController.h
//  SHOPBOOK
//
//  Created by bichenkk on 12年12月13日.
//  Copyright (c) 2012年 biworks. All rights reserved.
//

#import "SPBaseTabbedViewController.h"

@protocol SBTextEditorViewControllerDelegate <NSObject>

- (void)SBTextEditorViewControllerDidFinishEdit:(NSInteger)tag text:(NSString *)text;

@end

@interface SPTextEditorViewController : SPBaseTabbedViewController
<UIActionSheetDelegate>

@property (nonatomic, assign) id delegate;

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) NSInteger wordLimit;
@property (nonatomic, retain) NSString *editorTitle;
@property (nonatomic, retain) NSString *editorText;
@property (retain, nonatomic) IBOutlet UITextView *editorTextView;
@property (retain, nonatomic) IBOutlet UILabel *wordLimitLabel;


@end
