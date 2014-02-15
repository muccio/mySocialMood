//
//  newUserDialog.h
//  mySocialMood
//
//  Created by muccio on 30/01/14.
//  Copyright (c) 2014 muccio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "globalSingleton.h"

@interface newUserDialog : UIViewController
- (IBAction)dismissDialog:(id)sender;
- (IBAction)registerNewUser:(id)sender;

@property (weak, nonatomic) IBOutlet UITextField *username_edit;
@property (weak, nonatomic) IBOutlet UITextField *password_edit;
@property (weak, nonatomic) IBOutlet UITextField *email_edit;
@end
