//
//  ReceiverTableViewCell.h
//  iOSChatMessenger
//
//  Created by Jeremy Hartmann on 2016-03-17.
//  Copyright © 2016 Jeremy Hartmann. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReceiverTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageBubble;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UILabel *username;

@end
