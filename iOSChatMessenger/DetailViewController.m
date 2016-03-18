//
//  DetailViewController.m
//  iOSChatMessenger
//
//  Created by Jeremy Hartmann on 2016-03-16.
//  Copyright © 2016 Jeremy Hartmann. All rights reserved.
//

#import "DetailViewController.h"
#import "CustomCells/SenderTableViewCell.h"
#import "ReceiverTableViewCell.h"

@interface DetailViewController ()
@property NSMutableArray *objects;
- (void)keyboardWillShow:(NSNotification *)notification;
- (void)keyboardWillHide:(NSNotification *)notification;
- (void)moveViewsUp:(BOOL)up keyboardRect:(CGRect)rect;
- (void)sendMessageToGroup;
- (void)addGroupMessageToView:(NSString *)username message:(NSString *)message sender:(BOOL)isSender;
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
        self.groupID = [[self.detailItem description] lowercaseString];
    }
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    
    // Create and add gesture recognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnView)];
    [self.view addGestureRecognizer:tap];
    
    self.messageField.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if (!self.objects)
    {
        self.objects = [[NSMutableArray alloc] init];
    }
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
    if ([self.messageField.text length] == 0)
    {
        NSLog(@"Message field empty. Return");
        return;
    }
    
    NSString *message = [NSString stringWithFormat:@"sndgrp:%@:%@", self.groupID, self.messageField.text];
    [self.clientStream sendStringCommand:message];
}

- (void)addGroupMessageToView:(NSString *)username message:(NSString *)message sender:(BOOL)isSender
{
    // Add message to object
    NSArray *cellObj = [NSArray arrayWithObjects:username, message, (isSender) ? @"YES" : @"NO", nil];
    [self.objects addObject:cellObj];
    [self.tableView reloadData];
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
    [self sendMessageToGroup];
    [self addGroupMessageToView:@"me" message:self.messageField.text sender:YES];
    
    self.messageField.text = @"";
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
        [self addGroupMessageToView:command[1] message:command[2] sender:NO];
    }
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *object = self.objects[indexPath.row];
    NSString *isSender = object[2];
    
    if ([isSender isEqualToString:@"YES"])
    {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"SenderTableViewCell" owner:self options:0];
        SenderTableViewCell *cell = nibArray[0];
        
        // Set message
        cell.messageLabel.text = object[1];
        
        // Set date timestamp
        NSDateFormatter *dateFromator = [[NSDateFormatter alloc] init];
        [dateFromator setDateFormat:@"hh:mm:ss"];
        NSDate *now = [NSDate date];
        cell.timestampLabel.text = [dateFromator stringFromDate:now];
        
        // Update Layout
        [cell updateLayout:YES];
        
        return cell;
    }
    else
    {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"ReceiverTableViewCell" owner:self options:0];
        ReceiverTableViewCell *cell = nibArray[0];
        
        // Set Username
        cell.username.text = object[0];
        
        // Set message
        cell.messageLabel.text = object[1];
        
        // Set date timestamp
        NSDateFormatter *dateFromator = [[NSDateFormatter alloc] init];
        [dateFromator setDateFormat:@"hh:mm:ss"];
        NSDate *now = [NSDate date];
        cell.timestampLabel.text = [dateFromator stringFromDate:now];
        
        // Update Layout
        [cell updateLayout:YES];
        
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get message object
    return 100;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

@end
