//
//  DetailViewController.m
//  iOSChatMessenger
//
//  Created by Jeremy Hartmann on 2016-03-16.
//  Copyright © 2016 Jeremy Hartmann. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)moveViewsUp:(BOOL)up keyboardRect:(CGRect)rect;
- (void)sendMessageToGroup;
- (void)addGroupMessageToView:(NSString *)username message:(NSString *)message;
- (void)didTapOnView;
// recieve
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
            
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
        self.groupID = [self.detailItem description];
    }
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    // Add gesture recognizer for keyboard
    // Create and add gesture recognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnView)];
    [self.view addGestureRecognizer:tap];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Regester keyboard listeners
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove the keyboard observers.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark message control
- (void)sendMessageToGroup
{
    NSString *message = [NSString stringWithFormat:@"sndgrp:%@:%@", self.groupID, self.messageField.text];
}

- (void)addGroupMessageToView:(NSString *)username message:(NSString *)message
{
    
}

#pragma mark keyboard listeners
- (void)keyboardWillShow:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSValue *keyFrame = [info valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect rect = [keyFrame CGRectValue];
    
    CGRect srec = self.view.frame;
    
    if (self.view.frame.origin.y >= 0)
    {
        [self moveViewsUp:YES keyboardRect:rect];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self moveViewsUp:NO keyboardRect:rect];
    }
    
    srec = self.view.frame;
}

/// Callback from notification center
- (void)keyboardWillHide:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    NSValue *keyFrame = [info valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect rect = [keyFrame CGRectValue];
    
    CGRect srec = self.view.frame;
    
    if (self.view.frame.origin.y >= 0)
    {
        [self moveViewsUp:YES keyboardRect:rect];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self moveViewsUp:NO keyboardRect:rect];
    }
}

/// Move the frame up or down
- (void)moveViewsUp:(BOOL)up keyboardRect:(CGRect)rect
{
    // Animate the view moving
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect srect = self.view.frame;
        if (up)
        {
            // Move the view up
            srect.origin.y = -(rect.size.height);
        }
        else
        {
            // Move rect to original pos
            srect.origin.y = 0;
        }
        
        self.view.frame = srect;
    }];
}

/// Dismiss the keyboard view
- (void)didTapOnView
{
    [self.messageField resignFirstResponder];
}

#pragma mark UITextField Delegate Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // Resign responder and send message.
    [self.messageField resignFirstResponder];
    
    
    return YES;
}

#pragma mark -
#pragma mark Chat Delegate Methods
- (void)receiveMessageFromServer:(NSString *)message
{
    NSArray *command = [message componentsSeparatedByString:@":"];
    
    // Parse Commands Here.
    if ([command[0] isEqualToString:@"msg"])
    {
        
    }
}

@end
