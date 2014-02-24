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
//@synthesize chatLog;
@synthesize bubbleTable;

-(void)handleErrors:(NSNotification *) notification{
}
-(void)handleEvents:(NSNotification *) notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *operation = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"operation"]];
    
    
    if([operation isEqualToString:@"notifications Loaded"]){
        //riscrivi file
        [[globalSingleton sharedManager] clearChatLog];
        [[globalSingleton sharedManager] refreshChatLog];
        
        [self init_bubble];
        
        //aggiorna textbox
        //[self refreshChatFromFile];
    }
    
}
/*
-(void)refreshChatFromFile{

    NSString *localFilePath = [[globalSingleton sharedManager] chatFileGetPath] ;
    NSURLRequest *localRequest = [NSURLRequest requestWithURL:
                                  [NSURL fileURLWithPath:localFilePath]] ;
    
    [self.chatHistoryWebView loadRequest:localRequest] ;
    self.chatHistoryWebView.delegate = self;
}*/
/*
- (void)webViewDidFinishLoad:(UIWebView *)theWebView
{
    CGSize contentSize = theWebView.scrollView.contentSize;

    
    NSInteger height = contentSize.height;
    NSString* javascript = [NSString stringWithFormat:@"window.scrollBy(0, %d);", height];
    [theWebView stringByEvaluatingJavaScriptFromString:javascript];
    
    [theWebView.scrollView setZoomScale:2.5f animated:YES];
}
*/
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
   
    return self;
}

-(void)init_bubble{
    /*
    NSBubbleData *heyBubble = [NSBubbleData dataWithText:@"Hey, halloween is soon" date:[NSDate dateWithTimeIntervalSinceNow:-300] type:BubbleTypeSomeoneElse];
    heyBubble.avatar = [UIImage imageNamed:@"avatar1.png"];
    
    NSBubbleData *replyBubble = [NSBubbleData dataWithText:@"Wow.. Really cool picture out there. iPhone 5 has really nice camera, yeah?" date:[NSDate dateWithTimeIntervalSinceNow:-5] type:BubbleTypeMine];
    replyBubble.avatar = nil;
    */
    
    
    bubbleData = [[NSMutableArray alloc] initWithObjects:nil];
    
    for (NSMutableArray*loc in [[globalSingleton sharedManager] notifications]) {
        //NSString* chat_entry = [NSString stringWithFormat:@"<b>%@to: %@</b>from: %@ %@",[loc objectAtIndex:0],[loc objectAtIndex:1],[loc objectAtIndex:2],[loc objectAtIndex:3]];
        NSString* data = [loc objectAtIndex:0];
        NSString* to = [loc objectAtIndex:1];
        NSString* from = [loc objectAtIndex:2];
        NSString* message = [loc objectAtIndex:3];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        // this is imporant - we set our input date format to match our input string
        // if format doesn't match you'll get nil from your string, so be careful
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *dateFromString = [[NSDate alloc] init];
        dateFromString = [dateFormatter dateFromString:data];
        NSBubbleData *bubble;
        if([from isEqualToString:[[globalSingleton sharedManager] username]]){
            bubble = [NSBubbleData dataWithText:message date:dateFromString type:BubbleTypeMine];
        }
        else{
            bubble = [NSBubbleData dataWithText:message date:dateFromString type:BubbleTypeSomeoneElse];

        }
        
        [bubbleData addObject:bubble];
    }
    
    bubbleTable.bubbleDataSource = self;
    
    
    bubbleTable.snapInterval = 120;
    
    
    bubbleTable.showAvatars = NO;
    
    
    //bubbleTable.typingBubble = NSBubbleTypingTypeSomebody;
    
    [bubbleTable reloadData];
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
    //self.chatLog.editable = NO;
    
}

-(void)viewDidAppear:(BOOL)animated{
    if (self) {
        // Custom initialization
        
        //[self refreshChatFromFile];
        
        [[globalSingleton sharedManager] get_notifications];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIBubbleTableViewDataSource implementation

- (NSInteger)rowsForBubbleTable:(UIBubbleTableView *)tableView
{
    return [bubbleData count];
}

- (NSBubbleData *)bubbleTableView:(UIBubbleTableView *)tableView dataForRow:(NSInteger)row
{
    return [bubbleData objectAtIndex:row];
}


@end
