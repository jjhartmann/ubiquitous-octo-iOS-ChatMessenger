//
//  LoginViewController.m
//  iOSChatMessenger
//
//  Created by Jeremy Hartmann on 2016-03-16.
//  Copyright © 2016 Jeremy Hartmann. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    // Create and add gesture recognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnView)];
    [self.view addGestureRecognizer:tap];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark UI Actions
- (IBAction)loginBtnPressed:(id)sender
{
    NSString *user = [self.usernameField text];
    if ([user isEqualToString:@"Username"] || [user length] == 0)
    {
        // Prompt the error lable
        [self.errorLabel setText:@"Enter username."];
        self.errorLabel.hidden = NO;
        return;
    }
    
    
}

/// Dismiss first responder for Text Field
- (void)didTapOnView
{
    [self.usernameField resignFirstResponder];
}

@end
