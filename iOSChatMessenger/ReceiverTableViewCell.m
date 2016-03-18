//
//  ReceiverTableViewCell.m
//  iOSChatMessenger
//
//  Created by Jeremy Hartmann on 2016-03-17.
//  Copyright © 2016 Jeremy Hartmann. All rights reserved.
//

#import "ReceiverTableViewCell.h"

@interface ReceiverTableViewCell ()
- (CGSize)getMessageSizeContainer:(NSString *)message;

@end

static CGFloat textMarginHorizontal = 15.0f;
static CGFloat textMarginVertical = 7.5f;
static CGFloat messageTextSize = 14.0;

@implementation ReceiverTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (CGSize)getMessageSizeContainer:(NSString *)message
{
    return [message sizeWithFont:[UIFont systemFontOfSize:messageTextSize] constrainedToSize:CGSizeMake(self.superview.frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
}

- (void)updateLayout:(BOOL)sendStatus
{
    // Get size of text and date
    CGSize messageSize = [self getMessageSizeContainer:self.messageLabel.text];
    CGSize dateSize = [self.timestampLabel.text sizeWithFont:self.timestampLabel.font forWidth:self.superview.frame.size.width lineBreakMode:NSLineBreakByClipping];
    
    
    // Create frames
    CGRect timeLabelRect = CGRectMake(textMarginHorizontal, 0.0f, dateSize.width, dateSize.height);
    
    CGRect balloonImgRect = CGRectMake(0.0f, timeLabelRect.size.height, messageSize.width + 2*textMarginHorizontal, messageSize.height + 2*textMarginVertical);
    
    CGRect messageLabelRect = CGRectMake(textMarginHorizontal, balloonImgRect.origin.y + textMarginVertical, messageSize.width, messageSize.height);
    
    // Set frames
    self.backgroundImageBubble.frame = balloonImgRect;
    self.timestampLabel.frame = timeLabelRect;
    self.messageLabel.frame = messageLabelRect;
}
@end
