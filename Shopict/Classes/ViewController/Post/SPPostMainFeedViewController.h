//
//  SPProductMainFeedViewController.h
//  SP
//
//  Created by bichenkk on 13年2月18日.
//  Copyright (c) 2013年 biworks. All rights reserved.
//

#import "SPPostFeedViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AFPhotoEditorController.h"

@class SPAddPostFromURLBrowserViewController;
@interface SPPostMainFeedViewController : SPPostFeedViewController
<UITabBarControllerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AFPhotoEditorControllerDelegate>


@property (nonatomic, retain) SPAddPostFromURLBrowserViewController *addPostFromURLBrowserViewController;
@property (nonatomic, retain) IBOutlet UIView *addPostOptionView;

@end
