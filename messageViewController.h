//
//  messageViewController.h
//  mySocialMood
//
//  Created by muccio on 19/02/14.
//  Copyright (c) 2014 muccio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "globalSingleton.h"

@interface messageViewController : UIViewController{
    int dialog_type;
}

//@property (weak, nonatomic) IBOutlet UILabel *messageText;
@property (weak, nonatomic) IBOutlet UITextView *messageText;

- (IBAction)replyToMessage:(id)sender;
- (IBAction)closeView:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *reply_button;
@property (readwrite,nonatomic) int dialog_type;
-(void)set_messageText:(NSString*)messaggio;
@end
