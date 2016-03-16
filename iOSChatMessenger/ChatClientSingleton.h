//
//  ChatClientSingleton.h
//  iOSChatMessenger
//
//  Created by Jeremy Hartmann on 2016-03-16.
//  Copyright © 2016 Jeremy Hartmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ChatClientDelegate;

@interface ChatClientSingleton : NSObject
// Static Methods
+ (id) getClientInstance;

// Instance Vars
@property (strong, nonatomic) NSInputStream *iStream;
@property (strong, nonatomic) NSOutputStream *oStream;
@property (weak, nonatomic) id <ChatClientDelegate> delegate;

// Instance Methods
- (id) init;
- (BOOL)createUserAccount:(NSString *)username;
@end


@protocol ChatClientDelegate <NSObject>

- (void)messageRevievedFromServer:(NSString *)message;

@end