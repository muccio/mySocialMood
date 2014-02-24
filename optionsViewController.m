//
//  optionsViewController.m
//  mySocialMood
//
//  Created by muccio on 06/02/14.
//  Copyright (c) 2014 muccio. All rights reserved.
//

#import "optionsViewController.h"

@interface optionsViewController ()

@end

@implementation optionsViewController

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
    self.auto_login_toggle.on = globals.autologin;
    self.tracking_toggle.on = globals.trackPosition;
    [self.sharing_type_setting setSelectedSegmentIndex:[globals sharing_type]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeAutologinToggle:(id)sender {
    globalSingleton* globals = [globalSingleton sharedManager];
    [globals updateOptions:@"autologin" value:[NSNumber numberWithBool:self.auto_login_toggle.on]];
}

- (IBAction)changeTrackingToggle:(id)sender {
    globalSingleton* globals = [globalSingleton sharedManager];
    [globals updateOptions:@"tracking" value:[NSNumber numberWithBool:self.tracking_toggle.on]];
    globals.trackPosition = self.tracking_toggle.on;
}
- (IBAction)change_shareing_type_setting:(id)sender {
    [[globalSingleton sharedManager] setUserPositionSharingType:self.sharing_type_setting.selectedSegmentIndex];
}
@end
