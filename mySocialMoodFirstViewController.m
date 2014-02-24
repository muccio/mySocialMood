//
//  mySocialMoodFirstViewController.m
//  mySocialMood
//
//  Created by muccio on 18/01/14.
//  Copyright (c) 2014 muccio. All rights reserved.
//

#import "mySocialMoodFirstViewController.h"

@interface mySocialMoodFirstViewController ()

@end

@implementation mySocialMoodFirstViewController
-(void)addLineToScroller:(NSString*)line{
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"hh:mm:ss";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [self.textScroller setText:[NSString stringWithFormat:@"%@\n%@-%@",[self.textScroller text],[dateFormatter stringFromDate:now],line]];
    self.textScroller.selectedRange = NSMakeRange(self.textScroller.text.length - 1, 0);
    [self.textScroller scrollRangeToVisible:[self.textScroller selectedRange]];
    //
    [[globalSingleton sharedManager] writeToLog:line];
}

-(void)handleErrors:(NSNotification *) notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *calling_function = [NSString stringWithFormat:@"ERROR: %@",[userInfo objectForKey:@"caller"]];
    [indicator stopAnimating];
    [self addLineToScroller:calling_function];
}
-(void)handleEvents:(NSNotification *) notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *operation = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"operation"]];
    /*if([operation isEqualToString:@"positionSetOk"]){
        return;
    }*/
    [self addLineToScroller:[NSString stringWithFormat:@"EVENT: %@",operation]];
    
    if([operation isEqualToString:@"moodSetOk"]){
        [self addLineToScroller:@"mood updated"];
        [indicator stopAnimating];
    }
    if([operation isEqualToString:@"getMoodOk"]){
        [self addLineToScroller:@"get Mood OK"];
        globalSingleton* globals = [globalSingleton sharedManager];
        
        [self.moodSegmentControl setSelectedSegmentIndex:[globals my_status]];
        [self.moodSegmentControl setUserInteractionEnabled:YES];
        [self.statusEdit setText:[globals my_message]];
        [self.usernameEdit setUserInteractionEnabled:NO];
        [self.passwordEdit setUserInteractionEnabled:NO];
        //[self.statusEdit setUserInteractionEnabled:YES];
        [self.twitterButton setUserInteractionEnabled:YES];
        [self.facebookButton setUserInteractionEnabled:YES];
        [globals getFriends];
        [globals getFollowers];
        
        [globals getUserPositionSharingType];
        
    }
    if([operation isEqualToString:@"loginOK"]){
        [self addLineToScroller:@"login OK"];
        globalSingleton* globals = [globalSingleton sharedManager];
        [globals getStatus];
    }
    if([operation isEqualToString:@"friends Loaded"]){
        [self addLineToScroller:@"friends loaded"];
        [self.tabBarController.tabBar setHidden:NO];
        [self.loginButton setUserInteractionEnabled:NO];
        [self.loginButton setTitle:@"logged" forState:UIControlStateNormal];
        [indicator stopAnimating];
    }
    if([operation isEqualToString:@"autologinStart"]){
        [self.usernameEdit setText:[[globalSingleton sharedManager] username]];
        [self.passwordEdit setText:[[globalSingleton sharedManager] password]];
        [[globalSingleton sharedManager] login:[[globalSingleton sharedManager] username] password:[[globalSingleton sharedManager] password]];
        [self.view endEditing:YES];
        [indicator startAnimating];
        
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleErrors:)
                                                 name:@"handleErrors"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleEvents:)
                                                 name:@"handleEvents"
                                               object:nil];
    
    
    self.tabBarController.delegate = self;
    globalSingleton* globals = [globalSingleton sharedManager];
    if([globals logged_in]==FALSE)
        [self.tabBarController.tabBar setHidden:YES];
    
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
    indicator.center = self.view.center;
    [self.view addSubview:indicator];
    [indicator bringSubviewToFront:self.view];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
    
    self.statusEdit.delegate = self;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTestButton:(id)sender {
    NSLog(@"test press");
    
    globalSingleton* globals = [globalSingleton sharedManager];
    [globals login:[self.usernameEdit text] password:[self.passwordEdit text]];
    
    
    [self.view endEditing:YES];
    [indicator startAnimating];
}

- (IBAction)updateMood:(id)sender {
    [self.view endEditing:YES];
    [self.statusEdit setUserInteractionEnabled:NO];
    globalSingleton* globals = [globalSingleton sharedManager];
    [indicator startAnimating];
    [globals setStatus:[self.moodSegmentControl selectedSegmentIndex] message:[self.statusEdit text]];
    
}

- (IBAction)postToFacebook:(id)sender {
    globalSingleton* globals = [globalSingleton sharedManager];
    [globals postToFacebook:self];
}

- (IBAction)postToTwitter:(id)sender {
    globalSingleton* globals = [globalSingleton sharedManager];
    [globals postToTwitter:self];
    
    /*
   messageViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"message_controller"];
    [self presentViewController:vc animated:YES completion:nil];
    */
}

- (IBAction)sendErrorLog:(id)sender {
    NSString *emailTitle = @"app log";
    // Email Content
    NSString *messageBody = @"debug log";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"mariosalvucci@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Determine the file name and extension
    NSString* file = @"log.txt";
    NSArray *filepart = [file componentsSeparatedByString:@"."];
    NSString *filename = [filepart objectAtIndex:0];
    NSString *extension = [filepart objectAtIndex:1];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"log.txt"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    

    // Determine the MIME type
    NSString *mimeType;
    if ([extension isEqualToString:@"jpg"]) {
        mimeType = @"image/jpeg";
    } else if ([extension isEqualToString:@"png"]) {
        mimeType = @"image/png";
    } else if ([extension isEqualToString:@"doc"]) {
        mimeType = @"application/msword";
    } else if ([extension isEqualToString:@"ppt"]) {
        mimeType = @"application/vnd.ms-powerpoint";
    } else if ([extension isEqualToString:@"html"]) {
        mimeType = @"text/html";
    } else if ([extension isEqualToString:@"pdf"]) {
        mimeType = @"application/pdf";
    } else if ([extension isEqualToString:@"txt"]) {
        mimeType = @"text/plain";
    }
    
    // Add attachment
    [mc addAttachmentData:fileData mimeType:mimeType fileName:filename];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];

}

- (IBAction)moodTypeEditEnd:(id)sender {
    [self.statusEdit setUserInteractionEnabled:YES];
    [self.statusEdit becomeFirstResponder];
}
- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"%@",textField.text);
    [self.view endEditing:YES];
    [self updateMood:nil];
    return YES;
}
@end
