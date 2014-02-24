//
//  newUserDialog.m
//  mySocialMood
//
//  Created by muccio on 30/01/14.
//  Copyright (c) 2014 muccio. All rights reserved.
//

#import "newUserDialog.h"

@interface newUserDialog ()

@end

@implementation newUserDialog

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)handleErrors:(NSNotification *) notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *calling_function = [NSString stringWithFormat:@"ERROR: %@",[userInfo objectForKey:@"caller"]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"REGISTRATION ERROR" message:calling_function delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    
}
-(void)handleEvents:(NSNotification *) notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *operation = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"operation"]];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"REGISTRATION OK" message:operation delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [alert show];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleErrors:)
                                                 name:@"handleErrors"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleEvents:)
                                                 name:@"handleEvents"
                                               object:nil];
    self.email_edit.keyboardType = UIKeyboardTypeEmailAddress;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)dismissDialog:(id)sender {
     [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self.view endEditing:YES];
}

- (IBAction)registerNewUser:(id)sender {
    if(self.username_edit.text.length==0||self.password_edit.text.length==0||self.email_edit.text.length==0){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"please fill all the blanks" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
        return;
    }
    globalSingleton* globals = [globalSingleton sharedManager];
    [globals registerNewUser:self.username_edit.text withPassword:self.password_edit.text andMail:self.email_edit.text];
    [self.view endEditing:YES];
}
@end
