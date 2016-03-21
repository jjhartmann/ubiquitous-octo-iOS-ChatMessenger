//
//  SettingsViewController.m
//  iOSChatMessenger
//
//  Created by Jeremy Hartmann on 2016-03-18.
//  Copyright © 2016 Jeremy Hartmann. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Set Text field in ip and port
    self.ipAddressField.text = self.ipAddressText;
    self.portNumberField.text = self.portNumberText;
    
    self.ipAddressField.delegate = self;
    self.portNumberField.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.ipAddressField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.ipAddressField)
    {
        [self.ipAddressField resignFirstResponder];
        [self.portNumberField becomeFirstResponder];
    }
    else
    {
        [self.portNumberField resignFirstResponder];
        [self dismissViewControllerAnimated:YES completion:^{
            // Call delegate class.
            if ([self.delegate respondsToSelector:@selector(didChangePortandIP:portNumber:)])
            {
                [self.delegate didChangePortandIP:self.ipAddressField.text portNumber:self.portNumberField.text];
            }
        }];
    }
    
    return YES;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
