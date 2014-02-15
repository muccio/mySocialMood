//
//  chatViewController.h
//  mySocialMood
//
//  Created by muccio on 11/02/14.
//  Copyright (c) 2014 muccio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "globalSingleton.h"

@interface chatViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *chatLog;
-(void)refreshChatFromFile;
@end
