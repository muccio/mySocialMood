//
//  globalSingleton.h
//  mySocialMood
//
//  Created by muccio on 20/01/14.
//  Copyright (c) 2014 muccio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LRResty/LRResty.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "Reachability.h"
#import <MapKit/MapKit.h>
#import "NSObject+stringHelper.h"


@interface globalSingleton : NSObject{
    NSString *main_site_url;
    NSString *getfriends_rest_url;
    NSString *getfollowers_rest_url;
    NSString *searchpeople_rest_url;
    NSString *setmood_rest_url;
    NSString *getmood_rest_url;
    NSString *login_rest_url;
    NSString *register_rest_url;
    NSString *addfriend_rest_url;
    NSString *get_locations_rest_url;
    NSString *check_notifications_rest_url;
    NSString *get_notifications_rest_url;
    NSString *send_instant_message_rest_url;
    NSString *set_position_rest_url;
    NSString *get_user_position_rest_url;
    NSString *set_user_position_sharing_type_url;
    NSString *get_user_position_sharing_type_url;
    NSString *reset_notifications_count_url;
    NSString *remove_friend_url;
    NSString *remove_follower_url;
    double my_latitude;
    double my_longitude;
    NSString* username;
    NSString* password;
    NSString* my_message;
    NSString* instant_message;
    NSString* destination_user_for_message;
    NSMutableArray *amici;
    NSMutableArray *followers;
    NSMutableArray *search_results;
    NSMutableArray *world_locations;
    NSMutableArray *notifications;
    int my_status;
    int sharing_type;
    BOOL pending_call;
    BOOL logged_in;
    BOOL handling_notification;
    BOOL autologin;
    BOOL trackPosition;
    BOOL debug_log;
    double connection_timeout;
    int fetches;
    NSString* device_id;
    CLLocationCoordinate2D friendCoordinates;
}
@property (nonatomic, retain) NSMutableArray *amici;
@property (nonatomic, retain) NSMutableArray *followers;
@property (nonatomic, retain) NSMutableArray *search_results;
@property (nonatomic, retain) NSMutableArray *world_locations;
@property (nonatomic, retain) NSMutableArray *notifications;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString* password;
@property (nonatomic, retain) NSString *my_message;
@property (nonatomic, retain) NSString *main_site_url;
@property (nonatomic, retain) NSString *set_position_rest_url;
@property (nonatomic, retain) NSString *setmood_rest_url;
@property (nonatomic, retain) NSString *getmood_rest_url;
@property (nonatomic, retain) NSString *login_rest_url;
@property (nonatomic, retain) NSString *getfriends_rest_url;
@property (nonatomic, retain) NSString *getfollowers_rest_url;
@property (nonatomic, retain) NSString *searchpeople_rest_url;
@property (nonatomic, retain) NSString *register_rest_url;
@property (nonatomic, retain) NSString *addfriend_rest_url;
@property (nonatomic, retain) NSString *get_locations_rest_url;
@property (nonatomic, retain) NSString *check_notifications_rest_url;
@property (nonatomic, retain) NSString *get_notifications_rest_url;
@property (nonatomic, retain) NSString *send_instant_message_rest_url;
@property (nonatomic, retain) NSString *get_user_position_rest_url;
@property (nonatomic, retain) NSString *set_user_position_sharing_type_url;
@property (nonatomic, retain) NSString *get_user_position_sharing_type_url;
@property (nonatomic, retain) NSString *reset_notifications_count_url;
@property (nonatomic, retain) NSString *remove_friend_url;
@property (nonatomic, retain) NSString *remove_follower_url;
@property (nonatomic, retain) NSString* device_id;
@property (nonatomic, retain) NSString* instant_message;
@property (nonatomic, retain) NSString* destination_user_for_message;
@property (nonatomic, readwrite) CLLocationCoordinate2D friendCoordinates;
@property (nonatomic, readwrite) double my_latitude;
@property (nonatomic, readwrite) double my_longitude;
@property (nonatomic, readwrite) int my_status;
@property (nonatomic, readwrite) int sharing_type;
@property (nonatomic, readwrite) int fetches;
@property (nonatomic, readwrite) BOOL logged_in;
@property (nonatomic, readwrite) BOOL handling_notification;
@property (nonatomic, readwrite) BOOL autologin;
@property (nonatomic, readwrite) BOOL debug_log;
@property (nonatomic, readwrite) BOOL trackPosition;
+ (id)sharedManager;
-(void)checkTimeoutForResty;
-(void)handleTimeoutForResty;
-(void)getFriends;
-(void)getFollowers;
-(void)setStatus:(int)status message:(NSString*)message;
-(void)getStatus;
-(void)login:(NSString*) usr password:(NSString*)psw;
-(void)registerNewUser:(NSString*) usr withPassword:(NSString*)pass andMail:(NSString*)mail;
-(void)searchPeople:(NSString*)name;
-(void)addFriend:(NSString*) _friend;

-(void)removeFriend:(NSString*) _friend;
-(void)removeFollower:(NSString*) _follower;
-(void)resetNotificationsCount;

-(void)getLocations:(NSString*) date;
-(void)check_notifications;
-(void)get_notifications;
-(void)testFetch;
-(void)sendMessageToUser:(NSString*)dest_username;
- (IBAction)postToTwitter:(UIViewController*)_view;
- (IBAction)postToFacebook:(UIViewController*)_view;
-(void)readOptions;
-(void)updateOptions:(NSString*)key value:(NSObject*)valore;
-(void)writeToLog:(NSString*)text;
-(void)updateLocationToServer;
-(void)getUserPosition:(NSString*)user;
-(void)getUserPositionSharingType;
-(void)setUserPositionSharingType:(int)share;
-(NSString*)chatFileGetPath;
-(void)writeToChatLog:(NSString*)text;
-(void)clearChatLog;
-(void)refreshChatLog;
@end
