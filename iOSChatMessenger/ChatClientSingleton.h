//
//  ChatClientSingleton.h
//  iOSChatMessenger
//
//  Created by Jeremy Hartmann on 2016-03-16.
//  Copyright © 2016 Jeremy Hartmann. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatClientSingleton : NSObject
// Static Methods
+ (id) getClientInstanceWithUser:(NSString *)username;

// Instance Methods
- (id) initWithUsername:(NSString *)username;
@end
