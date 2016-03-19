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

@interface LoginViewController ()
@property BOOL serverStatus;
- (void)createUserCallback:(NSString *)message;
- (void)freezeUI;
- (void)unfreezeUI;
- (void)createUser;
- (void)connectToServer;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    // Create and add gesture recognizer
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapOnView)];
    [self.view addGestureRecognizer:tap];
    
    // UI elemnts
    self.errorLabel.hidden = YES;
    self.activitySpinner.hidden = YES;
    
    // Initial port and ip address
    self.ipAdress = @"192.168.1.71";
    self.portNumber = @"25425";
    
    // Create connection to server
    [self connectToServer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/// Connect to the server
- (void)connectToServer
{
    // Create connection to server
    self.clientStream = [ChatClientSingleton
                         getClientInstanceWithIP:self.ipAdress
                         portNumber:self.portNumber
                         statusCallback:^(BOOL status){
                             if (status)
                             {
                                 self.serverStatus = YES;
                                 self.errorLabel.hidden = YES;
                             }
                             else
                             {
                                 self.serverStatus = NO;
                                 [self.errorLabel setText:@"Error connecting to server"];
                                 self.errorLabel.hidden = NO;
                             }
                         }];
    
    self.clientStream.delegate = self;
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
    
    self.user = user;
    [self freezeUI];
    
    if (self.serverStatus)
        [self createUser];
}

/// Create User account when connected to server
- (void)createUser
{
    // Create user if available
    if(![self.clientStream createUserAccount:self.user]) {
        self.errorLabel.text = @"Error connecting to server. Try again...";
        self.errorLabel.hidden = NO;
        [self unfreezeUI];
    }
}

/// Dismiss first responder for Text Field
- (void)didTapOnView
{
    [self.usernameField resignFirstResponder];
}

/// Create user callback when server responds.
- (void)createUserCallback:(NSString *)message
{
    // Create user if available
    if ([message isEqualToString:@"YES"])
    {
        // Call Split view controller and segue.
        [self performSegueWithIdentifier:@"LoginSegue" sender:self];
    }
    else
    {
        // Indeicate the user name is not available
        [self.errorLabel setText:@"Username is unavailable"];
        self.errorLabel.hidden = NO;
    }
    
    [self unfreezeUI];
}

/// Freeze the UI from user interaction and start activity indicator
- (void)freezeUI
{
    self.usernameField.userInteractionEnabled = NO;
    self.loginBtn.userInteractionEnabled = NO;
    self.activitySpinner.hidden = NO;
    [self.activitySpinner startAnimating];
}

/// Unfreeze UI and stop activity indicator
- (void)unfreezeUI
{
    self.usernameField.userInteractionEnabled = YES;
    self.loginBtn.userInteractionEnabled = YES;
    self.activitySpinner.hidden = YES;
    [self.activitySpinner stopAnimating];
}

#pragma mark -
#pragma mark Chat Delegate Methods
- (void)receiveMessageFromServer:(NSString *)message
{
    NSArray *command = [message componentsSeparatedByString:@":"];
    if ([command[0] isEqualToString:@"addusercb"])
    {
        [self createUserCallback:command[1]];
    }
}

/// Gets called when stream has been opened successfully.
- (void)streamDidOpenFor:(NSString *)streamID
{
    if (self.serverStatus && [streamID isEqualToString:@"oStream"])
    {

    }
}

#pragma mark Settings Delegate Methods
- (void)didChangePortandIP:(NSString *)ipAddress portNumber:(NSString *)portNumber
{
    self.ipAdress = ipAddress;
    self.portNumber = portNumber;
}


#pragma mark Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([segue.identifier isEqualToString:@"LoginSegue"]){
        // Call Split view controller.
        UISplitViewController *splitViewController = (UISplitViewController *)segue.destinationViewController;
        UINavigationController *navigationController = [splitViewController.viewControllers lastObject];
        
        navigationController.topViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem;
        splitViewController.delegate = self;
        
        
        UINavigationController *navigationControllerMaster = [splitViewController.viewControllers firstObject];
        MasterViewController* destController = (MasterViewController *) navigationControllerMaster.topViewController;
        destController.username = self.user;
        
        destController.clientStream = self.clientStream;
        destController.clientStream.delegate = destController;
    }
    else if ([segue.identifier isEqualToString:@"settingsViewSegue"]) {
        // Set up delegate for settings view.
        SettingsViewController *dest = [segue destinationViewController];
        dest.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        [dest.ipAddressField setText:self.ipAdress];
        [dest.portNumberField setText:self.portNumber];
        dest.delegate = self;
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
