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
- (BOOL)configureSocketStreams:(NSString *)ipAddress portNumber:(NSInteger)port statusCallback:(StreamStatus) statusBlock;
- (void)processInput;
- (void)parseBuffer;
- (BOOL)sendData:(NSData *)data;
- (CFStreamStatus)configReadWriteStream;
- (void)closeCurrentStreams;


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

/// Static instance to set up client with port and IP settings
+ (id)getClientInstanceWithIP:(NSString *)ipAddress portNumber:(NSString *)portNumber statusCallback:(StreamStatus) statusBlock
{
    if (!instance)
    {
        instance = [[ChatClientSingleton alloc] initWithIPandPort:ipAddress portNumber:portNumber statusCallback:statusBlock];
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
        // Create connection to IP address 192.168.1.71
        if (![self configureSocketStreams:@"192.168.1.71" portNumber:12543 statusCallback:nil])
        {
            return nil;
        }
    }
    
    return self;
}

- (id)initWithIPandPort:(NSString *)ipAddress portNumber:(NSString *)portNumber statusCallback:(StreamStatus) statusBlock
{
    NSInteger port = [portNumber integerValue];
    
    self = [super init];
    if (self)
    {
        if (![self configureSocketStreams:ipAddress portNumber:port statusCallback:statusBlock])
        {
            return nil;
        }
    }
    
    return self;
}

/// Setup and configure socket streams
- (BOOL)configureSocketStreams:(NSString *)ipAddress portNumber:(NSInteger)port statusCallback:(StreamStatus) statusBlock
{
    // Set capacity of buffers
    self.iBufferCapacity = 16*1024;
    self.oBufferCapacity = 16*1024;
    self.iBuffer = [NSMutableData dataWithCapacity:self.iBufferCapacity];
    self.oBuffer = [NSMutableData dataWithCapacity:self.oBufferCapacity];
    self.ipAddress = ipAddress;
    self.portNumber = port;

    CFStreamStatus status = [self configReadWriteStream];
    
    // Check for errors, and notify delegate
    if (status < 1)
    {
        NSLog(@"Error occurced when creating the readWrite streams. \n\tStatus: %li", status);
        statusBlock(NO);
        return NO;
    }
    
    statusBlock(YES);
    return YES;
}

/// Initialize the read stream;
- (CFStreamStatus)configReadWriteStream
{
    // Set up client server connection
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    
    // Create connection to IP address 192.168.1.71
    CFStreamCreatePairWithSocketToHost(CFAllocatorGetDefault(), (__bridge CFStringRef) self.ipAddress, self.portNumber, &readStream, &writeStream);
    
    CFReadStreamSetProperty(readStream,
                            kCFStreamPropertyShouldCloseNativeSocket,
                            kCFBooleanTrue);
    CFWriteStreamSetProperty(writeStream,
                             kCFStreamPropertyShouldCloseNativeSocket,
                             kCFBooleanTrue);
    
    self.iStream = (__bridge_transfer NSInputStream *)readStream;
    self.oStream = (__bridge_transfer NSOutputStream * )writeStream;
    
    [self.iStream setDelegate:self];
    [self.oStream setDelegate:self];
    
    [self.iStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.oStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    [self.iStream open];
    [self.oStream open];
    
    CFStreamStatus readStatus = CFReadStreamGetStatus(readStream);
    CFStreamStatus writeStatus = CFWriteStreamGetStatus(writeStream);
    
    return (readStatus < writeStatus) ? readStatus : writeStatus;
}


/// Create the user accound on server. Returns YES is success
- (BOOL)createUserAccount:(NSString *)username
{
    // Send an iam:<username> request to the server.
    NSString *message = [[NSString alloc] initWithFormat:@"iam:%@", username];
    NSData *oData = [[NSData alloc] initWithData:[message dataUsingEncoding:NSUTF8StringEncoding]];

    return [self sendData:oData];
}

/// Send string command to the server
- (void)sendStringCommand:(NSString *)command
{
    NSData *oData = [[NSData alloc] initWithData:[command dataUsingEncoding:NSUTF8StringEncoding]];
    [self sendData:oData];
}

#pragma mark private methods
/// Reset the instannce method
- (void)reset
{
    instance = nil;
    // Set delgates to nil
    [self.iStream setDelegate:nil];
    [self.oStream setDelegate:nil];
    
    // Remove the streams from the run loop
    [self.iStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.oStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    // Close the stream
    [self.iStream close];
    [self.oStream close];
}

/// Close the current streams
- (void)closeCurrentStreams
{
    // Set delgates to nil
    [self.iStream setDelegate:nil];
    [self.oStream setDelegate:nil];
    
    // Remove the streams from the run loop
    [self.iStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [self.oStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    // Close the stream
    [self.iStream close];
    [self.oStream close];
}


/// Send data over socket stream
- (BOOL)sendData:(NSData *)data
{
    NSStreamStatus status = [self.oStream streamStatus];
    NSError *error = [self.oStream streamError];
    
    if (error)
    {
        NSLog(@"ERROR: Stream is corrupt with error: %@", error);
        return NO;
    }
    
    if (status < NSStreamStatusOpen)
    {
        NSLog(@"Stream is not currently open. Status: %lu", (unsigned long)status);
        [self closeCurrentStreams];
        [self configReadWriteStream];
        return NO;
    }
    
    [self.oStream write:[data bytes] maxLength:[data length]];
    return YES;
}


/// Parse the buffer after revieing message from server
- (void)parseBuffer
{
    NSInteger offset = 0;
    const uint8_t *bytes = [self.iBuffer bytes];
    
    // Convert Data into UTF8 char set
    NSString *inputString = [[NSString alloc] initWithBytes:&bytes[offset] length:[self.iBuffer length] encoding:NSUTF8StringEncoding];
    
    // Remove CR LF
    NSString *commandString;
    NSScanner *scanner = [[NSScanner alloc] initWithString:inputString];
    BOOL res = [scanner scanCharactersFromSet:[[NSCharacterSet controlCharacterSet] invertedSet] intoString:&commandString];
    
    // Call delegate to handle command
    if (res && [self.delegate respondsToSelector:@selector(receiveMessageFromServer:)])
    {
        [self.delegate receiveMessageFromServer:commandString];
    }
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
    
    if (bytesRead > 0)
    {
        // Reset the ibuffer
        [self.iBuffer replaceBytesInRange:NSMakeRange(0, bytesRead) withBytes:NULL length:0];
    }
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
            
            if (self.oStream == aStream)
            {
                // Call delegate to initiate send.
                if ([self.delegate respondsToSelector:@selector(streamDidOpenFor:)])
                {
                    [self.delegate streamDidOpenFor:@"oStream"];
                }
            }
            
            break;
        }
        case NSStreamEventHasBytesAvailable: // Read from stream
        {
            NSLog(@"StreamHandle: NSStreamEventHasBytesAvailable");
            [self processInput];
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
