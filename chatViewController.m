//
//  chatViewController.m
//  mySocialMood
//
//  Created by muccio on 11/02/14.
//  Copyright (c) 2014 muccio. All rights reserved.
//

#import "chatViewController.h"

@interface chatViewController ()

@end

@implementation chatViewController
@synthesize chatLog;

-(void)handleErrors:(NSNotification *) notification{
}
-(void)handleEvents:(NSNotification *) notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *operation = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"operation"]];
    
    
    if([operation isEqualToString:@"notifications Loaded"]){
        //riscrivi file
        [[globalSingleton sharedManager] clearChatLog];
        //[[globalSingleton sharedManager] writeToChatLog:@"CHAT LOG"];
        [[globalSingleton sharedManager] refreshChatLog];
        
        //aggiorna textbox
        [self refreshChatFromFile];
    }
    
}
-(void)refreshChatFromFile{
    NSString *myText = [NSString stringWithContentsOfFile:[[globalSingleton sharedManager] chatFileGetPath] encoding:NSUTF8StringEncoding error:nil];
    
    NSData *htmlData = [myText dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create the HTML string
    NSDictionary *importParams = @{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType};
    NSError *error = nil;
    chatLog.attributedText = [[NSAttributedString alloc] initWithData:htmlData options:importParams documentAttributes:NULL error:&error];
    /*
     NSURL *htmlString = [NSURL URLWithString:[[[globalSingleton sharedManager] chatFileGetPath] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
     
     NSAttributedString *stringWithHTMLAttributes = [[NSAttributedString alloc]   initWithFileURL:htmlString options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType} documentAttributes:nil error:nil];
     
     chatLog.attributedText = stringWithHTMLAttributes;
     */
    
    //chatLog.text  = myText;
    
    
    chatLog.selectedRange = NSMakeRange(chatLog.text.length - 1, 0);
    [chatLog scrollRangeToVisible:[chatLog selectedRange]];
    
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
   
    return self;
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
    
}

-(void)viewDidAppear:(BOOL)animated{
    if (self) {
        // Custom initialization
        
        [self refreshChatFromFile];
        
        [[globalSingleton sharedManager] get_notifications];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
