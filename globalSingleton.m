//
//  globalSingleton.m
//  mySocialMood
//
//  Created by muccio on 20/01/14.
//  Copyright (c) 2014 muccio. All rights reserved.
//

#import "globalSingleton.h"

@implementation globalSingleton
@synthesize main_site_url;
@synthesize setmood_rest_url;
@synthesize getmood_rest_url;
@synthesize login_rest_url;
@synthesize getfriends_rest_url;
@synthesize getfollowers_rest_url;
@synthesize register_rest_url;
@synthesize searchpeople_rest_url;
@synthesize addfriend_rest_url;
@synthesize get_locations_rest_url;
@synthesize check_notifications_rest_url;
@synthesize get_user_position_rest_url;
@synthesize set_position_rest_url;
@synthesize get_user_position_sharing_type_url;
@synthesize set_user_position_sharing_type_url;
@synthesize reset_notifications_count_url;
@synthesize remove_friend_url;
@synthesize remove_follower_url;
@synthesize destination_user_for_message;
@synthesize message_original_user;
@synthesize my_latitude;
@synthesize my_longitude;
@synthesize my_status;
@synthesize sharing_type;
@synthesize username;
@synthesize password;
@synthesize amici;
@synthesize followers;
@synthesize search_results;
@synthesize fetches;
@synthesize logged_in;
@synthesize world_locations;
@synthesize my_message;
@synthesize instant_message;
@synthesize handling_notification;
@synthesize notifications;
@synthesize get_notifications_rest_url;
@synthesize send_instant_message_rest_url;
@synthesize device_id;
@synthesize autologin;
@synthesize debug_log;
@synthesize trackPosition;
@synthesize friendCoordinates;
@synthesize received_message;

#pragma mark Singleton Methods

+ (id)sharedManager {
    static globalSingleton *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

-(void)initUrls{
    setmood_rest_url = [NSString stringWithFormat:@"%@%@",main_site_url,@"?method=setmood&format=json&user=%@&mood=%d&message=%@&lat=%f&long=%f"];
    getmood_rest_url = [NSString stringWithFormat:@"%@%@",main_site_url,@"?method=getmood&format=json&user=%@"];
    getfriends_rest_url = [NSString stringWithFormat:@"%@%@",main_site_url,@"?method=getfriends&format=json&user=%@"];
    getfollowers_rest_url = [NSString stringWithFormat:@"%@%@",main_site_url,@"?method=getfollowers_data&format=json&user=%@"];
    login_rest_url = [NSString stringWithFormat:@"%@%@",main_site_url,@"?method=login&format=json&user=%@&psw=%@&device_id=%@"];
    register_rest_url = [NSString stringWithFormat:@"%@%@",main_site_url,@"?format=json&method=new_user&user=%@&password=%@&email=%@"];
    searchpeople_rest_url = [NSString stringWithFormat:@"%@%@",main_site_url,@"?method=search_people&format=json&query=%@"];
    addfriend_rest_url = [NSString stringWithFormat:@"%@%@",main_site_url,@"?method=add_friend&format=json&user=%@&friend=%@"];
    get_locations_rest_url = [NSString stringWithFormat:@"%@%@",main_site_url,@"?method=get_locations&format=json&last_update=%@"];
    check_notifications_rest_url = [NSString stringWithFormat:@"%@%@",main_site_url,@"?method=check_notifications&format=json&user=%@"];
    get_notifications_rest_url = [NSString stringWithFormat:@"%@%@",main_site_url,@"?method=get_notifications&format=json&user=%@"];
    send_instant_message_rest_url = [NSString stringWithFormat:@"%@%@",main_site_url,@"?method=send_message&format=json&sender=%@&user=%@&message=%@"];
    set_position_rest_url = [NSString stringWithFormat:@"%@%@",main_site_url,@"?method=setposition&format=json&user=%@&lat=%f&long=%f"];
    get_user_position_rest_url = [NSString stringWithFormat:@"%@%@",main_site_url,@"?method=getposition&format=json&user=%@"];
    
    get_user_position_sharing_type_url = [NSString stringWithFormat:@"%@%@",main_site_url,@"?method=get_position_sharing_type&format=json&user=%@"];
    set_user_position_sharing_type_url = [NSString stringWithFormat:@"%@%@",main_site_url,@"?method=set_position_sharing_type&format=json&user=%@&share=%d"];
    reset_notifications_count_url = [NSString stringWithFormat:@"%@%@",main_site_url,@"?method=reset_notifications_count&format=json&user=%@"];
    remove_friend_url =[NSString stringWithFormat:@"%@%@",main_site_url,@"?method=remove_friend&format=json&user=%@&friend=%@"];
    remove_follower_url =[NSString stringWithFormat:@"%@%@",main_site_url,@"?method=remove_follower&format=json&user=%@&follower=%@"];
}

- (id)init {
    if (self = [super init]) {
        pending_call = FALSE;
        connection_timeout = 15.0;
        main_site_url = @"";
        
        
        
        /*
        @"http://www.mariosalvucci.com/rest/?method=setmood&format=json&user=%@&mood=%d&message=%@&lat=%f&long=%f";
        @"http://www.mariosalvucci.com/rest/?method=getmood&format=json&user=%@";
        @"http://www.mariosalvucci.com/rest/?method=getfriends&format=json&user=%@";
        @"http://www.mariosalvucci.com/rest/?method=login&format=json&user=%@&psw=%@&device_id=%@";
        @"http://www.mariosalvucci.com/rest/?format=json&method=new_user&user=%@&password=%@&email=%@";
        @"http://www.mariosalvucci.com/rest/?method=search_people&format=json&query=%@";
        @"http://www.mariosalvucci.com/rest/?method=add_friend&format=json&user=%@&friend=%@";
        @"http://www.mariosalvucci.com/rest/?method=get_locations&format=json&last_update=%@";
        @"http://www.mariosalvucci.com/rest/?method=check_notifications&format=json&user=%@";
        @"http://www.mariosalvucci.com/rest/?method=get_notifications&format=json&user=%@";
        @"http://www.mariosalvucci.com/rest/?method=send_message&format=json&user=%@&message=%@";
        */
        my_latitude = 0.0;
        my_longitude = 0.0;
        fetches = 0;
        my_status = -1;
        username = @"";
        destination_user_for_message = @"";
        amici = [[NSMutableArray alloc] init];
        followers = [[NSMutableArray alloc] init];
        world_locations = [[NSMutableArray alloc] init];
        search_results = [[NSMutableArray alloc] init];
        notifications = [[NSMutableArray alloc] init];
        logged_in= FALSE;
        handling_notification=FALSE;
        debug_log = TRUE;
        trackPosition = FALSE;
    }
    return self;
}

-(void)sendError:(NSString*)parameter{
    NSDictionary *calling_function = [NSDictionary dictionaryWithObject:parameter forKey:@"caller"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"handleErrors" object:self userInfo:calling_function];
}

-(void)sendOk:(NSString*)parameter{
    NSDictionary *operation = [NSDictionary dictionaryWithObject:parameter forKey:@"operation"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"handleEvents" object:self userInfo:operation];
}
-(void)handleTimeoutForResty{
    if(pending_call){
        NSLog(@"TIMEOUT");
        [[LRResty client] cancelAllRequests];
        [self sendError:@" resty TIMEOUT"];
        //check network
        
        
        Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
        NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
        if (networkStatus == NotReachable) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Network Error"
                                                                message:@"No Internet Connection" delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
            [alertView show];


        } else {
            
            NSLog(@"There IS internet connection");
            
            
        }        
    

        
        
        
    }
}
-(void)checkTimeoutForResty{
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
    pending_call = TRUE;
    [self performSelector:@selector(handleTimeoutForResty) withObject:nil afterDelay:connection_timeout];
    
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}
-(void)searchPeople:(NSString*)name{
    NSString* rest_request= [[NSString stringWithFormat:searchpeople_rest_url,name] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [self checkTimeoutForResty];
    [[LRResty client] get:rest_request withBlock:^(LRRestyResponse *r) {
        NSLog(@"search people: %@", [r asString]);
        
        NSError *error;
        NSMutableDictionary *response = [NSJSONSerialization
                                         JSONObjectWithData:[r responseData]
                                         options:NSJSONReadingMutableContainers
                                         error:&error];
        if( error )
        {
            NSLog(@"%@", [error localizedDescription]);
            [self sendError:@"searchPeople"];
        }
        else {
            pending_call = FALSE;
            NSMutableDictionary *dati = response[@"data"];
            
            [search_results removeAllObjects];
            for ( NSDictionary *valore in dati )
            {
                NSLog(@"----");
                NSLog(@"user: %@", valore[@"username"] );
                NSLog(@"mood: %@", valore[@"mood"] );
                NSLog(@"lat: %@", valore[@"lat"] );
                NSLog(@"long: %@", valore[@"long"] );
                NSLog(@"upd: %@", valore[@"upd"] );
                NSArray* amico = [[NSArray alloc] initWithObjects:valore[@"username"],valore[@"mood"],valore[@"lat"] ,valore[@"long"],valore[@"upd"] ,nil];
                [search_results addObject:amico];
            }
            NSLog(@"risultato ricerca: %d",[search_results count]);
            
            [self sendOk:@"search_Loaded"];
        }
        
    }];
}
-(void)getFriends{
    NSString* rest_request= [[NSString stringWithFormat:getfriends_rest_url,username] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [self checkTimeoutForResty];
    [[LRResty client] get:rest_request withBlock:^(LRRestyResponse *r) {
        NSLog(@"get friends: %@", [r asString]);
        
        NSError *error;
        NSMutableDictionary *response = [NSJSONSerialization
                                         JSONObjectWithData:[r responseData]
                                         options:NSJSONReadingMutableContainers
                                         error:&error];
        if( error )
        {
            NSLog(@"%@", [error localizedDescription]);
            [self sendError:@"getFriends"];
        }
        else {
            pending_call = FALSE;
            NSMutableDictionary *dati = response[@"data"];
            [amici removeAllObjects];
            for ( NSDictionary *valore in dati )
            {
                NSLog(@"----");
                NSLog(@"user: %@", valore[@"username"] );
                NSLog(@"mood: %@", valore[@"mood"] );
                NSLog(@"lat: %@", valore[@"lat"] );
                NSLog(@"long: %@", valore[@"long"] );
                NSLog(@"upd: %@", valore[@"upd"] );
                NSLog(@"message: %@", valore[@"message"] );
                NSArray* amico = [[NSArray alloc] initWithObjects:valore[@"username"],valore[@"mood"],valore[@"lat"] ,valore[@"long"],valore[@"upd"] , valore[@"message"],nil];
                [amici addObject:amico];
            }
            NSLog(@"amici: %d",[amici count]);
            [self sendOk:@"friends Loaded"];
        }
        
    }];
}

-(void)getFollowers{
    NSString* rest_request= [[NSString stringWithFormat:getfollowers_rest_url,username] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [self checkTimeoutForResty];
    [[LRResty client] get:rest_request withBlock:^(LRRestyResponse *r) {
        NSLog(@"get followers: %@", [r asString]);
        
        NSError *error;
        NSMutableDictionary *response = [NSJSONSerialization
                                         JSONObjectWithData:[r responseData]
                                         options:NSJSONReadingMutableContainers
                                         error:&error];
        if( error )
        {
            NSLog(@"%@", [error localizedDescription]);
            [self sendError:@"getFollowers"];
        }
        else {
            pending_call = FALSE;
            NSMutableDictionary *dati = response[@"data"];
            [followers removeAllObjects];
            for ( NSDictionary *valore in dati )
            {
                NSLog(@"----");
                NSLog(@"user: %@", valore[@"username"] );
                NSLog(@"mood: %@", valore[@"mood"] );
                NSLog(@"lat: %@", valore[@"lat"] );
                NSLog(@"long: %@", valore[@"long"] );
                NSLog(@"upd: %@", valore[@"upd"] );
                NSLog(@"message: %@", valore[@"message"] );
                NSArray* follower = [[NSArray alloc] initWithObjects:valore[@"username"],valore[@"mood"],valore[@"lat"] ,valore[@"long"],valore[@"upd"] , valore[@"message"],nil];
                [followers addObject:follower];
            }
            NSLog(@"follower: %d",[followers count]);
            [self sendOk:@"followers Loaded"];
        }
        
    }];
}

-(void)removeFollower:(NSString*) _follower{
    NSString* rest_request= [[NSString stringWithFormat: remove_follower_url,username,_follower] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [self checkTimeoutForResty];
    
    
    [[LRResty client] get:rest_request withBlock:^(LRRestyResponse *r) {
        NSLog(@"%@", [r asString]);
        NSLog(@"removeFollower=%@", [r asString]);
        NSError *error;
        NSMutableDictionary *response = [NSJSONSerialization
                                         JSONObjectWithData:[r responseData]
                                         options:NSJSONReadingMutableContainers
                                         error:&error];
        if( error )
        {
            NSLog(@"%@", [error localizedDescription]);
            [self sendError:@"removeFollowerERROR"];
        }
        else{
            pending_call = FALSE;
            NSMutableDictionary *dati = response[@"data"];
            NSLog(@"REST REQUEST - setStatus %@",(NSString*)dati);
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"moodSetOk" object:self];
            [self sendOk:@"removeFollowerOK"];
        }
        
    }];
}

-(void)removeFriend:(NSString*) _friend{
    NSString* rest_request= [[NSString stringWithFormat: remove_friend_url,username,_friend] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [self checkTimeoutForResty];
    
    
    [[LRResty client] get:rest_request withBlock:^(LRRestyResponse *r) {
        NSLog(@"%@", [r asString]);
        NSLog(@"removeFriend=%@", [r asString]);
        NSError *error;
        NSMutableDictionary *response = [NSJSONSerialization
                                         JSONObjectWithData:[r responseData]
                                         options:NSJSONReadingMutableContainers
                                         error:&error];
        if( error )
        {
            NSLog(@"%@", [error localizedDescription]);
            [self sendError:@"removeFriendERROR"];
        }
        else{
            pending_call = FALSE;
            NSMutableDictionary *dati = response[@"data"];
            NSLog(@"REST REQUEST - setStatus %@",(NSString*)dati);
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"moodSetOk" object:self];
            [self sendOk:@"removeFriendOK"];
        }
        
    }];
}

-(void)setStatus:(int)status message:(NSString*)message{
    int selected_mood = status;
    
    
    NSString* rest_request= [[NSString stringWithFormat: setmood_rest_url,username,selected_mood,[message urlEncodeUsingEncoding:NSUTF8StringEncoding],my_latitude,my_longitude] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [self checkTimeoutForResty];
    
    
    [[LRResty client] get:rest_request withBlock:^(LRRestyResponse *r) {
        NSLog(@"%@", [r asString]);
        NSLog(@"get Status=%@", [r asString]);
        NSError *error;
        NSMutableDictionary *response = [NSJSONSerialization
                                         JSONObjectWithData:[r responseData]
                                         options:NSJSONReadingMutableContainers
                                         error:&error];
        if( error )
        {
            NSLog(@"%@", [error localizedDescription]);
            [self sendError:@"setStatus"];
        }
        else{
            pending_call = FALSE;
            NSMutableDictionary *dati = response[@"data"];
            NSLog(@"REST REQUEST - setStatus %@",(NSString*)dati);
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"moodSetOk" object:self];
            [self sendOk:@"moodSetOk"];
        }
        
    }];
}

-(void)getStatus{
    
    NSString* rest_request= [NSString stringWithFormat: getmood_rest_url,username];
    
    [self checkTimeoutForResty];
    
    [[LRResty client] get:rest_request withBlock:^(LRRestyResponse *r) {
        NSLog(@"get Status=%@", [r asString]);
        NSError *error;
        NSMutableDictionary *response = [NSJSONSerialization
                                         JSONObjectWithData:[r responseData]
                                         options:NSJSONReadingMutableContainers
                                         error:&error];
        if( error )
        {
            NSLog(@"%@", [error localizedDescription]);
            [self sendError:@"getStatus"];
        }
        else {
            pending_call = FALSE;
            NSMutableDictionary *dati = response[@"data"];
            //my_status = [(NSString*)dati intValue];
            my_status = [dati[@"mood"] intValue];
            my_message = dati[@"message"];
            
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"getMoodOk" object:self];
            [self sendOk:@"getMoodOk"];
        }
    }];
}

-(void)login:(NSString*) usr password:(NSString*)psw{
    username = usr;
    password=psw;
    NSString* rest_request= [NSString stringWithFormat: login_rest_url,username,psw,device_id];
    
    
    [self checkTimeoutForResty];
    
    [[LRResty client] get:rest_request withBlock:^(LRRestyResponse *r) {
        NSLog(@"%@", [r asString]);
        NSError *error;
        NSMutableDictionary *response = [NSJSONSerialization
                                         JSONObjectWithData:[r responseData]
                                         options:NSJSONReadingMutableContainers
                                         error:&error];
        if( error )
        {
            NSLog(@"LOGIN REQUEST ERROR:%@", [error localizedDescription]);
            [self sendError:@"login"];
        }
        else {
            pending_call = FALSE;
            NSMutableDictionary *dati = response[@"data"];
            if([(NSString*)dati isEqualToString:@"loginOK"]){
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"loginOK" object:self];
                [self sendOk:@"loginOK"];
                logged_in = TRUE;
            }
            else{
                [self sendError:@"login"];
            }
        }
    }];
}

-(void)addFriend:(NSString*)_friend{
    NSString* rest_request= [NSString stringWithFormat: addfriend_rest_url,username,_friend];
    
    
    [self checkTimeoutForResty];
    
    [[LRResty client] get:rest_request withBlock:^(LRRestyResponse *r) {
        NSLog(@"%@", [r asString]);
        NSError *error;
        NSMutableDictionary *response = [NSJSONSerialization
                                         JSONObjectWithData:[r responseData]
                                         options:NSJSONReadingMutableContainers
                                         error:&error];
        if( error )
        {
            NSLog(@"LOGIN REQUEST ERROR:%@", [error localizedDescription]);
            [self sendError:@"addfriendERR"];
        }
        else {
            pending_call = FALSE;
            NSMutableDictionary *dati = response[@"data"];
            if([(NSString*)dati isEqualToString:@"addfriendOK"]){
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"loginOK" object:self];
                [self sendOk:@"addfriendOK"];
            }
            else{
                [self sendError:@"addfriendERR"];
            }
        }
    }];
}

-(void)registerNewUser:(NSString*) usr withPassword:(NSString*)pass andMail:(NSString*)mail{
    NSString* rest_request= [NSString stringWithFormat: register_rest_url,usr,pass,mail];
    
    
    [self checkTimeoutForResty];
    
    [[LRResty client] get:rest_request withBlock:^(LRRestyResponse *r) {
        NSLog(@"%@", [r asString]);
        NSError *error;
        NSMutableDictionary *response = [NSJSONSerialization
                                         JSONObjectWithData:[r responseData]
                                         options:NSJSONReadingMutableContainers
                                         error:&error];
        if( error )
        {
            NSLog(@"REGISTER REQUEST ERROR:%@", [error localizedDescription]);
            [self sendError:@"register"];
        }
        else {
            pending_call = FALSE;
            NSMutableDictionary *dati = response[@"data"];
            if([(NSString*)dati isEqualToString:@"registrationOK"]){
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"loginOK" object:self];
                [self sendOk:@"registrationOK"];
            }
            else{
                [self sendError:@"registrationERROR"];
            }
        }
    }];
    
    
}
-(void)testFetch{
    fetches++;
    NSLog(@"globals fetch %d...",fetches);
}

-(void)getLocations:(NSString*) date{
    NSString* rest_request= [[NSString stringWithFormat:get_locations_rest_url,date] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [self checkTimeoutForResty];
    [[LRResty client] get:rest_request withBlock:^(LRRestyResponse *r) {
        NSLog(@"get locations: %@", [r asString]);
        
        NSError *error;
        NSMutableDictionary *response = [NSJSONSerialization
                                         JSONObjectWithData:[r responseData]
                                         options:NSJSONReadingMutableContainers
                                         error:&error];
        if( error )
        {
            NSLog(@"%@", [error localizedDescription]);
            [self sendError:@"getLocations"];
        }
        else {
            pending_call = FALSE;
            NSMutableDictionary *dati = response[@"data"];
            [world_locations removeAllObjects];
            for ( NSDictionary *valore in dati )
            {
                NSLog(@"----");
                NSLog(@"loc: %@", valore[@"loc"] );
                NSLog(@"mood: %@", valore[@"mood"] );
                NSLog(@"lat: %@", valore[@"lat"] );
                NSLog(@"long: %@", valore[@"long"] );
                NSLog(@"stats: %@", valore[@"stats"] );

                NSArray* location = [[NSArray alloc] initWithObjects:valore[@"loc"],valore[@"mood"],valore[@"lat"] ,valore[@"long"] ,valore[@"stats"] ,nil];
                [world_locations addObject:location];
            }
            NSLog(@"world_locations: %d",[world_locations count]);
            [self sendOk:@"locations Loaded"];
        }
        
    }];
}

-(void)get_notifications{
    NSString* rest_request= [[NSString stringWithFormat:get_notifications_rest_url,username] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [self checkTimeoutForResty];
    [[LRResty client] get:rest_request withBlock:^(LRRestyResponse *r) {
        NSLog(@"get notifications: %@", [r asString]);
        
        NSError *error;
        NSMutableDictionary *response = [NSJSONSerialization
                                         JSONObjectWithData:[r responseData]
                                         options:NSJSONReadingMutableContainers
                                         error:&error];
        if( error )
        {
            NSLog(@"%@", [error localizedDescription]);
            [self sendError:@"getNotifications"];
        }
        else {
            pending_call = FALSE;
            NSMutableDictionary *dati = response[@"data"];
            [notifications removeAllObjects];
            for ( NSDictionary *valore in dati )
            {
                NSLog(@"----");
                NSLog(@"data: %@", valore[@"data"] );
                NSLog(@"to: %@", valore[@"to"] );
                NSLog(@"from: %@", valore[@"from"] );
                NSLog(@"message: %@", valore[@"message"] );
                
                NSArray* notification = [[NSArray alloc] initWithObjects:valore[@"data"],valore[@"to"],valore[@"from"] ,valore[@"message"] ,nil];
                [notifications addObject:notification];
            }
            NSLog(@"notifications: %d",[notifications count]);
            [self sendOk:@"notifications Loaded"];
        }
        
    }];


}
-(void)check_notifications{
    if (logged_in&&!handling_notification&&!pending_call) {
        handling_notification=TRUE;
        NSString* rest_request= [[NSString stringWithFormat:check_notifications_rest_url,username] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        [self checkTimeoutForResty];
        [[LRResty client] get:rest_request withBlock:^(LRRestyResponse *r) {
            NSLog(@"check notifications: %@", [r asString]);
            
            NSError *error;
            NSMutableDictionary *response = [NSJSONSerialization
                                             JSONObjectWithData:[r responseData]
                                             options:NSJSONReadingMutableContainers
                                             error:&error];
            if( error )
            {
                NSLog(@"%@", [error localizedDescription]);
                [self sendError:@"check_notifications"];
            }
            else {
                pending_call = FALSE;
                NSMutableDictionary *dati = response[@"data"];
                NSString* aux =dati[@"notifications"];
                int notifiche=[aux intValue];
                if(notifiche>0){
                    NSLog(@"push notification local");
                    [self get_notifications];
                    [self sendOk:@"notification_present"];
                }
                else
                    [self sendOk:@"no_notifications"];
            }
            
        }];
    }
    NSLog(@"check_notifications");
}

-(void)sendMessageToUser:(NSString*)dest_username{
    destination_user_for_message = dest_username;
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Messaggio" message:@"Inserisci testo ed invia" delegate:self cancelButtonTitle:@"Send" otherButtonTitles:@"Cancel", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    //NSLog(@"%d - Entered: %@",buttonIndex ,[[alertView textFieldAtIndex:0] text]);
    if(buttonIndex==0){
        NSLog(@"%@ %@",destination_user_for_message,[[alertView textFieldAtIndex:0] text]);
        NSString* rest_request= [[NSString stringWithFormat: send_instant_message_rest_url,username,destination_user_for_message,[[[alertView textFieldAtIndex:0] text] urlEncodeUsingEncoding:NSUTF8StringEncoding]] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        [self checkTimeoutForResty];
        
        [[LRResty client] get:rest_request withBlock:^(LRRestyResponse *r) {
            NSLog(@"%@", [r asString]);
            NSError *error;
            NSMutableDictionary *response = [NSJSONSerialization
                                             JSONObjectWithData:[r responseData]
                                             options:NSJSONReadingMutableContainers
                                             error:&error];
            if( error )
            {
                NSLog(@"SEND INSTANT MESSAGE ERROR:%@", [error localizedDescription]);
                [self sendError:@"instantmessageERR"];
            }
            else {
                pending_call = FALSE;
                NSMutableDictionary *dati = response[@"data"];
                if([(NSString*)dati isEqualToString:@"messageSent"]){
                    //[[NSNotificationCenter defaultCenter] postNotificationName:@"loginOK" object:self];
                    [self sendOk:@"instantMessageOK"];
                }
                else{
                    [self sendError:@"instantMessageERR"];
                }
            }
        }];
    }
}

-(void)sendMessage:(NSString*)message toUser:(NSString*)dest_username{
    destination_user_for_message = dest_username;
    NSLog(@"%@ %@",destination_user_for_message,message);
    NSString* rest_request= [[NSString stringWithFormat: send_instant_message_rest_url,username,destination_user_for_message,[message urlEncodeUsingEncoding:NSUTF8StringEncoding]] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSLog(@"%@",rest_request);
    [self checkTimeoutForResty];
    
    [[LRResty client] get:rest_request withBlock:^(LRRestyResponse *r) {
        NSLog(@"%@", [r asString]);
        NSError *error;
        NSMutableDictionary *response = [NSJSONSerialization
                                         JSONObjectWithData:[r responseData]
                                         options:NSJSONReadingMutableContainers
                                         error:&error];
        if( error )
        {
            NSLog(@"SEND INSTANT MESSAGE ERROR:%@", [error localizedDescription]);
            [self sendError:@"instantmessageERR"];
        }
        else {
            pending_call = FALSE;
            NSMutableDictionary *dati = response[@"data"];
            if([(NSString*)dati isEqualToString:@"messageSent"]){
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"loginOK" object:self];
                [self sendOk:@"instantMessageOK"];
            }
            else{
                [self sendError:@"instantMessageERR"];
            }
        }
    }];
}
-(void)updateLocationToServer{
    
    NSString* rest_request= [[NSString stringWithFormat: set_position_rest_url,username,my_latitude,my_longitude] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [self checkTimeoutForResty];
    
    
    [[LRResty client] get:rest_request withBlock:^(LRRestyResponse *r) {

        NSError *error;
        NSMutableDictionary *response = [NSJSONSerialization
                                         JSONObjectWithData:[r responseData]
                                         options:NSJSONReadingMutableContainers
                                         error:&error];
        if( error )
        {
            NSLog(@"%@", [error localizedDescription]);
            [self sendError:@"setPosition"];
        }
        else{
            pending_call = FALSE;
            NSMutableDictionary *dati = response[@"data"];
            NSLog(@"REST REQUEST - setPosition %@",(NSString*)dati);
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"moodSetOk" object:self];
            [self sendOk:@"positionSetOk"];
        }
        
    }];
}

-(void)getUserPosition:(NSString*)user{
    NSString* rest_request= [NSString stringWithFormat: get_user_position_rest_url,user];
    
    [self checkTimeoutForResty];
    
    [[LRResty client] get:rest_request withBlock:^(LRRestyResponse *r) {
        NSLog(@"get user Position=%@", [r asString]);
        NSError *error;
        NSMutableDictionary *response = [NSJSONSerialization
                                         JSONObjectWithData:[r responseData]
                                         options:NSJSONReadingMutableContainers
                                         error:&error];
        if( error )
        {
            NSLog(@"%@", [error localizedDescription]);
            [self sendError:@"getUserPosition"];
        }
        else {
            pending_call = FALSE;
            NSMutableDictionary *dati = response[@"data"];
            for ( NSDictionary *valore in dati ){
                
                double lat = [valore[@"latitude"] floatValue];
                double lon = [valore[@"longitude"] floatValue];
                
                friendCoordinates.latitude = lat;
                friendCoordinates.longitude = lon;
            }
            [self sendOk:@"getUserPositionOK"];
        }
    }];
}


-(void)getUserPositionSharingType{
    NSString* rest_request= [NSString stringWithFormat: get_user_position_sharing_type_url,username];
    
    [self checkTimeoutForResty];
    
    [[LRResty client] get:rest_request withBlock:^(LRRestyResponse *r) {
        NSLog(@"get user position sharing type=%@", [r asString]);
        NSError *error;
        NSMutableDictionary *response = [NSJSONSerialization
                                         JSONObjectWithData:[r responseData]
                                         options:NSJSONReadingMutableContainers
                                         error:&error];
        if( error )
        {
            NSLog(@"%@", [error localizedDescription]);
            [self sendError:@"getUserPosSharing"];
        }
        else {
            pending_call = FALSE;
            NSMutableDictionary *dati = response[@"data"];
            sharing_type = [dati[@"type"] intValue];
            [self sendOk:@"getUserPosSharingOK"];
        }
    }];
    
}
-(void)setUserPositionSharingType:(int)share{
    NSString* rest_request= [[NSString stringWithFormat: set_user_position_sharing_type_url,username,share] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [self checkTimeoutForResty];
    
    
    [[LRResty client] get:rest_request withBlock:^(LRRestyResponse *r) {
        NSLog(@"%@", [r asString]);
        NSLog(@"set sharingType=%@", [r asString]);
        NSError *error;
        NSMutableDictionary *response = [NSJSONSerialization
                                         JSONObjectWithData:[r responseData]
                                         options:NSJSONReadingMutableContainers
                                         error:&error];
        if( error )
        {
            NSLog(@"%@", [error localizedDescription]);
            [self sendError:@"sharingTypeSetERROR"];
        }
        else{
            pending_call = FALSE;
            NSMutableDictionary *dati = response[@"data"];
            NSLog(@"REST REQUEST - setStatus %@",(NSString*)dati);
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"moodSetOk" object:self];
            [self sendOk:@"sharingTypeSetOK"];
        }
        
    }];
}

-(void)resetNotificationsCount{
    NSString* rest_request= [[NSString stringWithFormat: reset_notifications_count_url,username] stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [self checkTimeoutForResty];
    
    
    [[LRResty client] get:rest_request withBlock:^(LRRestyResponse *r) {
        NSLog(@"%@", [r asString]);
        NSLog(@"reset notifications count=%@", [r asString]);
        NSError *error;
        NSMutableDictionary *response = [NSJSONSerialization
                                         JSONObjectWithData:[r responseData]
                                         options:NSJSONReadingMutableContainers
                                         error:&error];
        if( error )
        {
            NSLog(@"%@", [error localizedDescription]);
            [self sendError:@"resetNotificationsCountERROR"];
        }
        else{
            pending_call = FALSE;
            NSMutableDictionary *dati = response[@"data"];
            NSLog(@"REST REQUEST - setStatus %@",(NSString*)dati);
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"moodSetOk" object:self];
            [self sendOk:@"resetNotificationsCountOK"];
        }
        
    }];
}

- (IBAction)postToTwitter:(UIViewController*)_view{
     if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
     {
         NSString* message = [NSString stringWithFormat:@"%d-%@",my_status,my_message];
         SLComposeViewController *tweetSheet = [SLComposeViewController
         composeViewControllerForServiceType:SLServiceTypeTwitter];
         [tweetSheet setInitialText:message];
         [_view presentViewController:tweetSheet animated:YES completion:nil];
     }
 }

 - (IBAction)postToFacebook:(UIViewController*)_view{
     NSString* message = [NSString stringWithFormat:@"%d-%@",my_status,my_message];
     SLComposeViewController *mySLComposerSheet;
     if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) //check if Facebook Account is linked
     {
         mySLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
         mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook]; //Tell him with what social plattform to use it, e.g. facebook or twitter
         [mySLComposerSheet setInitialText:message]; //the message you want to post
         //[mySLComposerSheet addImage:yourimage]; //an image you could post
         
         [_view presentViewController:mySLComposerSheet animated:YES completion:nil];
     }
     [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
         NSString *output;
         switch (result) {
             case SLComposeViewControllerResultCancelled:
                 output = @"Action Cancelled";
                 break;
             case SLComposeViewControllerResultDone:
                 output = @"Post Successfull";
                 break;
             default:
                 break;
         } //check if everything worked properly. Give out a message on the state.
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
         [alert show];
     }];
     /*if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
     NSString* message = [NSString stringWithFormat:@"%d-%@",my_status,my_message];
     SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
     
     [controller setInitialText:message];
     [controller addURL:[NSURL URLWithString:@"testing"]];
     [controller addImage:[UIImage imageNamed:@"socialsharing-facebook-image.jpg"]];
     
     [_view presentViewController:controller animated:YES completion:Nil];
     
     }*/
 }

-(NSString*)optionsFileGetPath{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"data.plist"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"options" ofType:@"plist"]; //5
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
    }
    return path;
}
-(void)readOptions{
    NSString* path = [self optionsFileGetPath];
    NSMutableDictionary *savedStock = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    main_site_url = (NSString*)[savedStock objectForKey:@"server_address"];
    trackPosition  = [[savedStock objectForKey:@"tracking"] boolValue];
    [self initUrls];
    autologin = [[savedStock objectForKey:@"autologin"] boolValue];
    if(autologin){
        username = (NSString*)[savedStock objectForKey:@"username"];
        password = (NSString*)[savedStock objectForKey:@"password"];
    }
}

-(void)updateOptions:(NSString*)key value:(NSObject*)valore{
    NSString* path = [self optionsFileGetPath];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    
    [data setObject:valore forKey:key];
    [data writeToFile: path atomically:YES];
    
    [data setObject:username forKey:@"username"];
    [data writeToFile: path atomically:YES];
    
    [data setObject:password forKey:@"password"];
    [data writeToFile: path atomically:YES];
}

-(NSString*)logFileGetPath{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"log.txt"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"log" ofType:@"txt"]; //5
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
    }
    return path;
}
-(void)writeToLog:(NSString*)text{
    if(!debug_log)return;
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZ";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSString *logPath = [self logFileGetPath];
    NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:logPath];
    [fileHandler seekToEndOfFile];
    [fileHandler writeData:[[NSString stringWithFormat:@"%@ - %@\n\r",[dateFormatter stringFromDate:now],text] dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandler closeFile];
}
-(NSString*)chatFileGetPath{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"chat.html"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"chat" ofType:@"html"]; //5
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
    }
    return path;
}
-(NSString*)chatCssGetPath{
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); //1
    NSString *documentsDirectory = [paths objectAtIndex:0]; //2
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"chat_style.css"]; //3
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath: path]) //4
    {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:@"chat_style" ofType:@"css"]; //5
        [fileManager copyItemAtPath:bundle toPath: path error:&error]; //6
    }
    return path;
}
-(void)clearChatLog{
    [[NSFileManager defaultManager] createFileAtPath:[self chatFileGetPath] contents:[NSData data] attributes:nil];
}
-(void)writeToChatLog:(NSString*)text{
    if(!debug_log)return;
    
    //NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZZZ";
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    
    NSString *logPath = [self chatFileGetPath];
    NSFileHandle *fileHandler = [NSFileHandle fileHandleForUpdatingAtPath:logPath];
    [fileHandler seekToEndOfFile];
    [fileHandler writeData:[[NSString stringWithFormat:@"%@\n\r",text] dataUsingEncoding:NSUTF8StringEncoding]];
    [fileHandler closeFile];
}
-(void)refreshChatLog{
    NSString *cssPath = [self chatCssGetPath];
    NSString* css = [NSString stringWithContentsOfFile:cssPath
                                              encoding:NSUTF8StringEncoding
                                                 error:NULL];
    NSString* header = [NSString stringWithFormat:@"<HTML><HEAD><meta charset='utf-8'><style>%@</style></HEAD><BODY onLoad='x = 0; y = document.height;window.scroll(x,y);'><div class='container'>",css];
    [self writeToChatLog:header];
    for (NSMutableArray*loc in notifications) {
        [self writeToChatLog:@"<div class='bubble'>"];
        NSString* chat_entry = [NSString stringWithFormat:@"<b>%@to: %@</b>from: %@ %@",[loc objectAtIndex:0],[loc objectAtIndex:1],[loc objectAtIndex:2],[loc objectAtIndex:3]];
        [self writeToChatLog:chat_entry];
        [self writeToChatLog:@"</div>"];
    }
    [self writeToChatLog:@"</div></BODY></HTML>"];
}

@end
