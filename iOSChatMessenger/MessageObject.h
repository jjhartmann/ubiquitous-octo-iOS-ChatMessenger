//
//  MessageObject.h
//  iOSChatMessenger
//
//  Created by Jeremy Hartmann on 2016-03-18.
//  Copyright © 2016 Jeremy Hartmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface MessageObject : NSObject
@property (strong, nonatomic) NSString *messageBody;
@property (strong, nonatomic) NSString *messageTitle;
@property (strong, nonatomic) NSString *usernameSender;
@property (strong, nonatomic) NSString *usernameReceiver;
@property (strong, nonatomic) UIImage *profileImage;
@property BOOL isSender;
@property BOOL hasURL;
@property (strong, nonatomic) NSString *extractedURL;

@end
