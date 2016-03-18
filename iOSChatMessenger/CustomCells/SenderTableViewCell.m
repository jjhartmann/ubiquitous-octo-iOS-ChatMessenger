//
//  SenderTableViewCell.m
//  iOSChatMessenger
//
//  Created by Jeremy Hartmann on 2016-03-17.
//  Copyright © 2016 Jeremy Hartmann. All rights reserved.
//

#import "SenderTableViewCell.h"

@interface SenderTableViewCell ()
- (CGSize)getMessageSizeContainer:(NSString *)message;

@end

static CGFloat textMarginHorizontal = 15.0f;
static CGFloat textMarginVertical = 7.5f;
static CGFloat messageTextSize = 14.0;


@implementation SenderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
