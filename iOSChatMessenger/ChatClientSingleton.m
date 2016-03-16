//
//  ChatClientSingleton.m
//  iOSChatMessenger
//
//  Created by Jeremy Hartmann on 2016-03-16.
//  Copyright © 2016 Jeremy Hartmann. All rights reserved.
//

#import "ChatClientSingleton.h"

@implementation ChatClientSingleton
// Static instance
static ChatClientSingleton *instance = nil;

+ (id)getClientInstanceWithUser:(NSString *)username
{
    if (!instance)
    {
        instance = [[ChatClientSingleton alloc] initWithUsername:username];
    }
    
    return instance;
}

// Instance Methods
- (id)initWithUsername:(NSString *)username
{
    self = [super init];
    if (self)
    {
        
    }
    
    return self;
}

@end
