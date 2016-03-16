//
//  ChatClientSingleton.m
//  iOSChatMessenger
//
//  Created by Jeremy Hartmann on 2016-03-16.
//  Copyright © 2016 Jeremy Hartmann. All rights reserved.
//

#import "ChatClientSingleton.h"

@implementation ChatClientSingleton
#pragma mark Static Instance
/// Static instance
static ChatClientSingleton *instance = nil;

+ (id)getClientInstance
{
    if (!instance)
    {
        instance = [[ChatClientSingleton alloc] init];
    }
    
    return instance;
}

#pragma mark - 
#pragma mark Instance Methods for Client
/// Initialize and create server connection
- (id)init
{
    self = [super init];
    if (self)
    {
        // Set up client server connection
    }
    
    return self;
}

/// Create the user accound on server. Returns YES is success
- (BOOL)createUserAccount:(NSString *)username
{
    // Send an iam:<username> request to the server.
    
    
    
}
@end
