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

@interface ChatClientSingleton ()
@property NSInteger iBufferCapacity;
@property NSInteger oBufferCapacity;
@property (strong, readwrite, nonatomic) NSMutableData *iBuffer;
@property (strong, readwrite, nonatomic) NSMutableData *oBuffer;
- (void)processInput;
- (void)parseBuffer;


@end

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
        // Set capacity of buffers
        self.iBufferCapacity = 16*1024;
        self.oBufferCapacity = 16*1024;
        self.iBuffer = [NSMutableData dataWithCapacity:self.iBufferCapacity];
        self.oBuffer = [NSMutableData dataWithCapacity:self.oBufferCapacity];
        
        // Set up client server connection
        CFReadStreamRef readStream;
        CFWriteStreamRef writeStream;
        
        // Create connection to IP address 192.168.1.71
        CFStreamCreatePairWithSocketToHost(CFAllocatorGetDefault(), (CFStringRef) @"192.168.1.71", 12345, &readStream, &writeStream);
        self.iStream = (__bridge_transfer NSInputStream *)readStream;
        self.oStream = (__bridge_transfer NSOutputStream * )writeStream;
        
        [self.iStream setDelegate:self];
        [self.oStream setDelegate:self];
        
        [self.iStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [self.oStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        
        [self.iStream open];
        [self.oStream open];
    }
    
    return self;
}

/// Create the user accound on server. Returns YES is success
- (BOOL)createUserAccount:(NSString *)username
{
    // Send an iam:<username> request to the server.
    NSString *message = [[NSString alloc] initWithFormat:@"iam:%@", username];
    NSData *oData = [[NSData alloc] initWithData:[message dataUsingEncoding:NSUTF8StringEncoding]];
    [self.oStream write:[oData bytes] maxLength:[oData length]];
    
    return YES;
}

/// Parse the buffer after revieing message from server
- (void)parseBuffer
{
    
}

/// Process the input and extract data from stream
- (void)processInput
{
    NSInteger bytesRead;
    NSInteger bufLen = [self.iBuffer length];
    
    
    if (bufLen >= self.iBufferCapacity)
    {
        // The buffer is full
        // TODO: Error handling
        NSLog(@"Input Buffer Full");
        return;
    }
    
    // Set buffer to capacity
    [self.iBuffer setLength:self.iBufferCapacity];
    
    // Retrieve bytes up to capacity minus what is already there.
    bytesRead = [self.iStream read:[self.iBuffer mutableBytes] + bufLen maxLength:self.iBufferCapacity - bufLen];
    
    // Make sure bytes have been read into buffer
    if (bytesRead <= 0)
    {
        // Bytes have not been read
        // TODO: error handling
        NSLog(@"no Bytes read in buffer. bytesRead: %i", bytesRead);
        return;
    }
    
    // Call method to parse buffer
    [self.iBuffer setLength:bufLen + bytesRead];
    [self parseBuffer];
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
