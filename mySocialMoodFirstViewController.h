//
//  mySocialMoodFirstViewController.h
//  mySocialMood
//
//  Created by muccio on 18/01/14.
//  Copyright (c) 2014 muccio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LRResty/LRResty.h>
#import <MessageUI/MessageUI.h>
#import "globalSingleton.h"
#import "messageViewController.h"

@interface mySocialMoodFirstViewController : UIViewController<UITabBarControllerDelegate,UITextFieldDelegate,MFMailComposeViewControllerDelegate>{
    UIActivityIndicatorView *indicator;
}
@property (weak, nonatomic) IBOutlet UITextView *textScroller;
- (IBAction)onTestButton:(id)sender;
@property (weak, nonatomic) IBOutlet UISegmentedControl *moodSegmentControl;
@property (weak, nonatomic) IBOutlet UITextField *usernameEdit;
@property (weak, nonatomic) IBOutlet UITextField *passwordEdit;
@property (weak, nonatomic) IBOutlet UITextField *statusEdit;
- (IBAction)updateMood:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
- (IBAction)postToFacebook:(id)sender;
- (IBAction)postToTwitter:(id)sender;
- (IBAction)sendErrorLog:(id)sender;
- (IBAction)moodTypeEditEnd:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@end
