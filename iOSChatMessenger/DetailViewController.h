//
//  DetailViewController.h
//  iOSChatMessenger
//
//  Created by Jeremy Hartmann on 2016-03-16.
//  Copyright © 2016 Jeremy Hartmann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatClientSingleton.h"

@interface DetailViewController : UIViewController <UITextFieldDelegate , ChatClientDelegate, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (strong, nonatomic) NSString *groupID;
@property (weak, nonatomic) ChatClientSingleton *clientStream;
@property (weak, nonatomic) IBOutlet UIWebView *previewWebView;
@property (weak, nonatomic) IBOutlet UIVisualEffectView *previewBlurWV;

@end

