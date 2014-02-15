//
//  mySocialMoodAppDelegate.h
//  mySocialMood
//
//  Created by muccio on 18/01/14.
//  Copyright (c) 2014 muccio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "globalSingleton.h"

@interface mySocialMoodAppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate>{
    CLLocationManager *locationManager;
    globalSingleton* globals;
    NSDate* last_update;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSDate* last_update;
@end
