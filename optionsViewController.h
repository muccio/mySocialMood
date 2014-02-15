//
//  optionsViewController.h
//  mySocialMood
//
//  Created by muccio on 06/02/14.
//  Copyright (c) 2014 muccio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "globalSingleton.h"

@interface optionsViewController : UIViewController

- (IBAction)changeAutologinToggle:(id)sender;
- (IBAction)changeTrackingToggle:(id)sender;
@property (weak, nonatomic) IBOutlet UISwitch *auto_login_toggle;
@property (weak, nonatomic) IBOutlet UISwitch *tracking_toggle;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sharing_type_setting;
- (IBAction)change_shareing_type_setting:(id)sender;
@end
