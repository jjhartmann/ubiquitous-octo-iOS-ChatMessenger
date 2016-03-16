//
//  LoginViewController.m
//  iOSChatMessenger
//
//  Created by Jeremy Hartmann on 2016-03-16.
//  Copyright © 2016 Jeremy Hartmann. All rights reserved.
//

#import "LoginViewController.h"
#import "MasterViewController.h"
#import "DetailViewController.h"
#import "ChatClientSingleton.h"

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
    ChatClientSingleton *client = [ChatClientSingleton getClientInstance];
    
    // Create user if available
    if ([client createUserAccount:self.user])
    {
        // Call Split view controller and segue.
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    }
    else
    {
        // Indeicate the user name is not available
        [self.errorLabel setText:@"Username is unavailable"];
        self.errorLabel.hidden = NO;
        return;
    }
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
        UISplitViewController *splitViewController = (UISplitViewController *)segue.destinationViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        
        navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
        splitViewController.delegate = self;
        
        
        UINavigationController *navigationControllerMaster = [splitViewController.viewControllers firstObject];
        MasterViewController* destController = (MasterViewController *) navigationControllerMaster.topViewController;
        destController.username = self.user;
    }
    
    
}

#pragma mark - Split view
- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
        return YES;
    } else {
        return NO;
    }
}

@end
