//
//  AddGroupViewController.m
//  iOSChatMessenger
//
//  Created by Jeremy Hartmann on 2016-03-18.
//  Copyright © 2016 Jeremy Hartmann. All rights reserved.
//

#import "AddGroupViewController.h"

@interface AddGroupViewController ()

@end

@implementation AddGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.groupTextField.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    // Show keyboard and make text field first responder.
    [self.groupTextField becomeFirstResponder];
}

#pragma mark Text Field
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([self.delegate respondsToSelector:@selector(chatGroupStringCallback:)])
    {
        [self.groupTextField resignFirstResponder];
        [self dismissViewControllerAnimated:YES completion:^{
            [self.delegate chatGroupStringCallback:self.groupTextField.text];
        }];
    }
    
    return YES;
}


#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end


