//
//  LoginViewController.h
//  iOSChatMessenger
//
//  Created by Jeremy Hartmann on 2016-03-16.
//  Copyright © 2016 Jeremy Hartmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatClientSingleton.h"

@interface LoginViewController : UIViewController  <UISplitViewControllerDelegate, ChatClientDelegate>
@property (strong, nonatomic) NSString *user;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel;

- (IBAction)loginBtnPressed:(id)sender;

- (void)didTapOnView;
@end
