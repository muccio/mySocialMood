//
//  chatViewController.h
//  mySocialMood
//
//  Created by muccio on 11/02/14.
//  Copyright (c) 2014 muccio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "globalSingleton.h"
#import "UIBubbleTableView.h"
#import "UIBubbleTableViewDataSource.h"
#import "NSBubbleData.h"


@interface chatViewController : UIViewController<UIWebViewDelegate,UIBubbleTableViewDataSource>{
    NSMutableArray *bubbleData;
}
@property (weak, nonatomic) IBOutlet UIBubbleTableView *bubbleTable;
//@property (weak, nonatomic) IBOutlet UITextView *chatLog;
//@property (weak, nonatomic) IBOutlet UIWebView *chatHistoryWebView;
//-(void)refreshChatFromFile;
@end
