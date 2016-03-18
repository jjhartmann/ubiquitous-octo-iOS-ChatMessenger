//
//  SettingsViewController.h
//  iOSChatMessenger
//
//  Created by Jeremy Hartmann on 2016-03-18.
//  Copyright © 2016 Jeremy Hartmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SettingsViewDelegate;

@interface SettingsViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *ipAddressField;
@property (weak, nonatomic) IBOutlet UITextField *portNumberField;
@property (weak, nonatomic) id <SettingsViewDelegate> delegate;

@end


@protocol SettingsViewDelegate <NSObject>
- (void)didChangePortandIP:(NSString *)ipAddress portNumber:(NSString *)portNumber;
@end