//
//  ChatClientSingleton.h
//  iOSChatMessenger
//
//  Created by Jeremy Hartmann on 2016-03-16.
//  Copyright © 2016 Jeremy Hartmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChatClientDelegate;

@interface ChatClientSingleton : NSObject <NSStreamDelegate>
// Static Methods
+ (id) getClientInstance;
+ (id) getClientInstanceWithIP:(NSString *)ipAddress portNumber:(NSString *)portNumber;
// Instance Vars
@property (strong, nonatomic) NSInputStream *iStream;
@property (strong, nonatomic) NSOutputStream *oStream;
@property (weak, nonatomic) id <ChatClientDelegate> delegate;

// Instance Methods
- (id) init;
- (id) initWithIPandPort:(NSString *)ipAddress portNumber:(NSString *)portNumber;
- (BOOL)createUserAccount:(NSString *)username;
- (void)sendStringCommand:(NSString *)command;
@end


@protocol ChatClientDelegate <NSObject>
@optional
- (void)receiveMessageFromServer:(NSString *)message;
@end