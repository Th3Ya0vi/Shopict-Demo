//
//  SBTextEditorViewController.m
//  SHOPBOOK
//
//  Created by bichenkk on 12年12月13日.
//  Copyright (c) 2012年 biworks. All rights reserved.
//

#import "SPTextEditorViewController.h"
#import "UIButton+SPButtonUtility.h"

@interface SPTextEditorViewController ()

@end

@implementation SPTextEditorViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = self.editorTitle;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.wordLimit == 0) {
        self.wordLimit = 500;
    }
    [self.editorTextView setText:self.editorText];
    [self.editorTextView becomeFirstResponder];
    UIButton *rightBarButton = [UIButton barButtonItemWithTitle:@"Save"];
    [rightBarButton addTarget:self action:@selector(saveButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    [self.navigationItem setRightBarButtonItem:rightBarButtonItem];
    [rightBarButtonItem release];
    [self.wordLimitLabel setText:[NSString stringWithFormat:@"%d/%d",self.editorTextView.text.length,self.wordLimit]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_editorTitle release];
    [_editorText release];
    [_editorTextView release];
    [_wordLimitLabel release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setEditorTextView:nil];
    [self setWordLimitLabel:nil];
    [super viewDidUnload];
}

- (IBAction)saveButtonPressed:(id)sender {
    if ([self validation]) {
        if ([self.delegate respondsToSelector:@selector(SBTextEditorViewControllerDidFinishEdit:text:)]) {
            [self.delegate SBTextEditorViewControllerDidFinishEdit:self.tag text:self.editorTextView.text];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSInteger textLength = 0;
    textLength = [textView.text length] + [text length] - range.length;
    [self.wordLimitLabel setText:[NSString stringWithFormat:@"%d/%d",textLength,self.wordLimit]];
    return YES;
}

- (BOOL)validation{
    if (self.editorTextView.text.length > self.wordLimit) {
        [self showErrorAlert:[NSString stringWithFormat:@"You should enter %d characters or fewer.",self.wordLimit]];
        return NO;
    }
    
    return YES;
}

- (void)backButtonPressed
{
    if ([self.editorText isEqualToString:self.editorTextView.text]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        UIActionSheet *actionSheet;
        actionSheet = [[[UIActionSheet alloc]initWithTitle:nil
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                    destructiveButtonTitle:@"Delete Modification"
                                         otherButtonTitles:@"Save Modification",nil]
                       autorelease];
        [actionSheet showFromTabBar:self.navigationController.tabBarController.tabBar];
    }
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([title isEqualToString:@"Delete Modification"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else if([title isEqualToString:@"Save Modification"]){
        if ([self validation]) {
            if ([self.delegate respondsToSelector:@selector(SBTextEditorViewControllerDidFinishEdit:text:)]) {
                [self.delegate SBTextEditorViewControllerDidFinishEdit:self.tag text:self.editorTextView.text];
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}


@end
