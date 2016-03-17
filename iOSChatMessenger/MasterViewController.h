//
//  MasterViewController.h
//  iOSChatMessenger
//
//  Created by Jeremy Hartmann on 2016-03-16.
//  Copyright © 2016 Jeremy Hartmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatClientSingleton.h"

@class DetailViewController;

@interface MasterViewController : UITableViewController <ChatClientDelegate>
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) DetailViewController *detailViewController;
@property (weak, nonatomic) ChatClientSingleton *clientStream;

@end

