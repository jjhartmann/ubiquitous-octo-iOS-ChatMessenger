//
//  LoginViewController.m
//  iOSChatMessenger
//
//  Created by Jeremy Hartmann on 2016-03-16.
//  Copyright © 2016 Jeremy Hartmann. All rights reserved.
//

#import "LoginViewController.h"
#import "MasterViewController.h"

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
    
    // TODO: Call client and send block with weak ref to self. Check that username is unique.
    self.user = user;
    
    
    // Call Split view controller and segue.
    [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    
}

/// Dismiss first responder for Text Field
- (void)didTapOnView
{
    [self.usernameField resignFirstResponder];
}

#pragma mark Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"LoginSegue"])
    {
        // Call Split view controller.
        UINavigationController *navController = segue.destinationViewController;
        MasterViewController *destController = (MasterViewController *) navController.topViewController;
        destController.username = self.user;
    }
    
    
}

@end
