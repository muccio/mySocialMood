//
//  mySocialMoodAppDelegate.m
//  mySocialMood
//
//  Created by muccio on 18/01/14.
//  Copyright (c) 2014 muccio. All rights reserved.
//

#import "mySocialMoodAppDelegate.h"


@implementation mySocialMoodAppDelegate
@synthesize last_update;

-(void)LaunchTimer{
    [globals check_notifications];
}



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
   
    globals = [globalSingleton sharedManager];
    
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
   
    [globals readOptions];
    [globals writeToLog:@"didFinishLaunchingWithOptions"];
    
    last_update =  [NSDate dateWithTimeIntervalSinceNow: -(60.0f*60.0f*24.0f)];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [globals writeToLog:@"applicationWillResignActive"];
    if(!globals.trackPosition){
        [locationManager stopUpdatingLocation];
        [locationManager stopMonitoringSignificantLocationChanges];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   
    if(!globals.trackPosition){
        [locationManager stopUpdatingLocation];
        [locationManager stopMonitoringSignificantLocationChanges];
    }

    [globals writeToLog:@"applicationDidEnterBackground"];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [globals writeToLog:@"applicationWillEnterForeground"];
    /*
    if(!globals.trackPosition)
        [locationManager startUpdatingLocation];
    */
    globalSingleton* globals_ = [globalSingleton sharedManager];
    if([globals_ logged_in]){
        [globals_ getFriends];
        [globals_ getFollowers];
        [globals_ getUserPositionSharingType];
        [globals_ getLocations:@"1234"];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"restart");
    application.applicationIconBadgeNumber = 0;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [globals resetNotificationsCount];
    [globals writeToLog:@"applicationDidBecomeActive"];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [globals writeToLog:@"applicationWillTerminate"];
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *location = [locations lastObject];
    

    if(location.coordinate.latitude!=0.0 && location.coordinate.longitude!=0.0){
        globals.my_latitude = location.coordinate.latitude;
        globals.my_longitude = location.coordinate.longitude;
        if(globals.logged_in){
                if(globals.trackPosition){
                NSLog(@"GPS UPDATE new %f-%f",location.coordinate.latitude,location.coordinate.longitude);
                NSTimeInterval secondsBetween = [[NSDate date] timeIntervalSinceDate:last_update];
                if(secondsBetween>10)
                {
                    [globals updateLocationToServer];
                    last_update = [NSDate date];
                    NSString* debug = [NSString stringWithFormat:@"Send new position to server %f-%f",globals.my_latitude,globals.my_longitude];
                    [[globalSingleton sharedManager] writeToLog:debug];
                    NSLog(@"%@",debug);
                }
            }
        }
    }
}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    NSLog(@"fetch");
    [globals writeToLog:@"performFetchWithCompletionHandler"];
    globalSingleton* globals_ = [globalSingleton sharedManager];
    if([globals_ logged_in]){
        [globals_ getFriends];
        [globals_ getFollowers];
        [globals_ getLocations:@"1234"];
    }
    
    
    completionHandler(UIBackgroundFetchResultNewData);
    
}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    printf("\n GPS FAILED");
}

-(BOOL)application:(UIApplication *)application shouldSaveApplicationState:(NSCoder *)coder{
    return YES;
}
-(BOOL)application:(UIApplication *)application shouldRestoreApplicationState:(NSCoder *)coder{
    return YES;
}

-(void)startAutologin{
    if(globals.autologin){
        NSDictionary *operation = [NSDictionary dictionaryWithObject:@"autologinStart" forKey:@"operation"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"handleEvents" object:self userInfo:operation];
    }
}
- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);//<a56713a5 d85aa496 2d8987ba 53c229cb 481e4a8b 4e0b2b17 f882da4a cca8ee40>
    [globals writeToLog:@"didRegisterForRemoteNotificationsWithDeviceToken"];
    [globals writeToLog:(NSString*)deviceToken];
    NSString* id_reformat = [NSString stringWithFormat:@"%@",deviceToken];
    id_reformat = [id_reformat stringByReplacingOccurrencesOfString:@"<" withString:@""];
    id_reformat = [id_reformat stringByReplacingOccurrencesOfString:@" " withString:@""];
    id_reformat = [id_reformat stringByReplacingOccurrencesOfString:@">" withString:@""];
    globals.device_id = id_reformat;
    [self startAutologin];
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error{
	NSLog(@"Failed to get token, error: %@", error);
    globals.device_id = @"0000000000000000000000000000000000000000000000000000000000000000";
    [globals writeToLog:[NSString stringWithFormat:@"Failed to get token, error: %@", error]];
    [self startAutologin];
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Code for Handle the Json here.
    //if ([globals logged_in])
    {
        NSLog(@"REMOTE NOTIFICATION RECEIVED");
        [globals writeToLog:@"REMOTE NOTIFICATION RECEIVED"];
        UIAlertView *alertView;
        if([[userInfo objectForKey:@"aps"] objectForKey:@"alert"]==nil){
        }
        else{
            alertView = [[UIAlertView alloc] initWithTitle:@"mySocialMood"
                                                   message:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
            
            if ([globals logged_in]){
                [globals getFriends];
                [globals getFollowers];
                [globals getLocations:@"1234"];
            }
        }
        //[globals writeToChatLog:[[userInfo objectForKey:@"aps"] objectForKey:@"alert"]];
        [alertView show];
        if ([globals logged_in]){
            [globals get_notifications];
            UITabBarController *navigationController = (UITabBarController *)self.window.rootViewController;
            [navigationController setSelectedIndex:3];
        }
    }
}
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    NSLog(@"LOCAL NOTIFICATION RECEIVED");
    [globals writeToLog:@"LOCAL NOTIFICATION RECEIVED"];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alarm"
                                                        message:notification.alertBody delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}

@end
