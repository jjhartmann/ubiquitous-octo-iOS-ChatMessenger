//
//  LoginViewController.h
//  iOSChatMessenger
//
//  Created by Jeremy Hartmann on 2016-03-16.
//  Copyright © 2016 Jeremy Hartmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatClientSingleton.h"
#import "SettingsViewController.h"

@interface LoginViewController : UIViewController  <UISplitViewControllerDelegate, ChatClientDelegate, SettingsViewDelegate>
@property (strong, nonatomic) NSString *user;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activitySpinner;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) ChatClientSingleton *clientStream;
@property (strong, nonatomic) NSString *ipAdress;
@property (strong, nonatomic) NSString *portNumber;

- (IBAction)loginBtnPressed:(id)sender;
- (void)didTapOnView;
@end
