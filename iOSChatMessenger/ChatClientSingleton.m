//
//  ChatClientSingleton.m
//  iOSChatMessenger
//
//  Created by Jeremy Hartmann on 2016-03-16.
//  Copyright © 2016 Jeremy Hartmann. All rights reserved.
//

#import "ChatClientSingleton.h"
#include <CoreFoundation/CoreFoundation.h>
#include <sys/socket.h>
#include <netinet/in.h>


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
        CFReadStreamRef readStream;
        CFWriteStreamRef writeStream;
        
        // Create connection to IP address 192.168.1.71
        CFStreamCreatePairWithSocketToHost(CFAllocatorGetDefault(), (CFStringRef) @"192.168.1.71", 12345, &readStream, &writeStream);
        self.iStream = (__bridge_transfer NSInputStream *)readStream;
        self.oStream = (__bridge_transfer NSOutputStream * )writeStream;
        
    }
    
    return self;
}

/// Create the user accound on server. Returns YES is success
- (BOOL)createUserAccount:(NSString *)username
{
    // Send an iam:<username> request to the server.
    
    
    return NO;
}


#pragma mark - 
#pragma mark NSStream Delegete
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    // Check stream with self.
    assert(aStream == self.iStream || aStream == self.oStream);
    
    // Demultiplex the messages.
    switch (eventCode) {
        case NSStreamEventOpenCompleted:
        {
            NSLog(@"StreamHandle: NSStreamEventOpenCompleted");
            break;
        }
        case NSStreamEventHasBytesAvailable: // Read from stream
        {
            NSLog(@"StreamHandle: NSStreamEventHasBytesAvailable");
            break;
        }
        case NSStreamEventHasSpaceAvailable: // Write to stream
        {
            NSLog(@"StreamHandle: NSStreamEventHasSpaceAvailable");
            break;
        }
        case NSStreamEventEndEncountered: // End of stream
        {
            NSLog(@"StreamHandle: NSStreamEventEndEncountered");
            break;
        }
        case NSStreamEventErrorOccurred: // Error in Stream
        {
            NSLog(@"StreamHandle: NSStreamEventErrorOccurred");
            break;
        }
        default:
            break;
    }
}
@end
