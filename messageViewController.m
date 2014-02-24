//
//  messageViewController.m
//  mySocialMood
//
//  Created by muccio on 19/02/14.
//  Copyright (c) 2014 muccio. All rights reserved.
//

#import "messageViewController.h"

@interface messageViewController ()

@end

@implementation messageViewController
@synthesize messageText;
@synthesize reply_button;
@synthesize dialog_type;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    globalSingleton* globals = [globalSingleton sharedManager];
    NSString* testo = [NSString stringWithFormat:@"From: %@ - %@",globals.message_original_user,globals.received_message];
    [messageText setAutocorrectionType:UITextAutocorrectionTypeYes];
    [messageText setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
    [messageText setText:testo];
    messageText.editable=NO;
    
    switch (dialog_type) {
        case 1:
            messageText.editable=YES;
            [messageText setText:@""];
            [reply_button setTitle:@"send" forState:UIControlStateNormal];
            self.editing=YES;
            [messageText becomeFirstResponder];
            break;
        case 0:
        default:
            break;
    }
    NSLog(@"%d",dialog_type);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)replyToMessage:(id)sender {
    if([reply_button.titleLabel.text isEqualToString:@"reply"]){
        messageText.editable=YES;
        [messageText setText:@""];
        [reply_button setTitle:@"send" forState:UIControlStateNormal];
        self.editing=YES;
        [messageText becomeFirstResponder];
    }
    if([reply_button.titleLabel.text isEqualToString:@"send"]){
        messageText.editable=NO;
        
        [[globalSingleton sharedManager] sendMessage:messageText.text toUser:[[globalSingleton sharedManager] message_original_user]];
        [messageText setText:@""];
        self.editing = NO;
        [self closeView:sender];
    }
}

- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:Nil];
    NSDictionary *operation = [NSDictionary dictionaryWithObject:@"dismissFormSheet" forKey:@"operation"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"handleEvents" object:self userInfo:operation];
}

-(void)set_messageText:(NSString*)messaggio{
//    self.messageText.text = messaggio;
    [messageText setText:messaggio];
}
-(void)viewDidDisappear:(BOOL)animated{
    NSLog(@"DISAPPEAR!");
}
@end
