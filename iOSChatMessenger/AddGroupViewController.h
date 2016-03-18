//
//  AddGroupViewController.h
//  iOSChatMessenger
//
//  Created by Jeremy Hartmann on 2016-03-18.
//  Copyright © 2016 Jeremy Hartmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddGroupDelegate;

@interface AddGroupViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *groupTextField;

@end


@protocol AddGroupDelegate <NSObject>
- (void)chatGroupStringCallback:(NSString *)groupString;
@end