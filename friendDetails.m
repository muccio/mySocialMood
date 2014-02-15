//
//  friendDetails.m
//  mySocialMood
//
//  Created by muccio on 22/01/14.
//  Copyright (c) 2014 muccio. All rights reserved.
//

#import "friendDetails.h"

@interface friendDetails ()

@end

@implementation friendDetails
@synthesize friendName;
@synthesize userName;
@synthesize friend_position_updater;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        
    }
    return self;
}
-(void)handleErrors:(NSNotification *) notification{
}
-(void)handleEvents:(NSNotification *) notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *operation = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"operation"]];
    
    
    if([operation isEqualToString:@"getUserPositionOK"]){
        if ([[globalSingleton sharedManager] friendCoordinates].latitude!=friends_lat||[[globalSingleton sharedManager] friendCoordinates].longitude!=friends_long) {
            friends_lat = [[globalSingleton sharedManager] friendCoordinates].latitude;
            friends_long = [[globalSingleton sharedManager] friendCoordinates].longitude;
            NSDate *now = [NSDate date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"hh:mm:ss";
            [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
            update_string = [dateFormatter stringFromDate:now];
            [self setMarkers];
            NSLog(@"user moved ...");
        }
        else{
            NSLog(@"no position change");
        }
    }
    
}


-(void)requestFriendPosition{
    [[globalSingleton sharedManager] getUserPosition:friendName];
}

-(void)viewDidDisappear:(BOOL)animated{
    [friend_position_updater invalidate];
    NSLog(@"invalidate updater");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.mappa.delegate = self;
    
    self.mappa.showsUserLocation = YES;
    
    
    //friendName = [[NSString alloc]init];
    globalSingleton* globals = [globalSingleton sharedManager];
    userName = [globals username];
    
    self.statusLabel.text=status_message;
    [self setMarkers];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleErrors:)
                                                 name:@"handleErrors"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleEvents:)
                                                 name:@"handleEvents"
                                               object:nil];
    
    //[self requestFriendPosition];
    friend_position_updater = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(requestFriendPosition) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation NS_AVAILABLE(10_9, 4_0){
    if (userLocation.location.horizontalAccuracy >= 0) {
        CLLocationCoordinate2D Coord;
        Coord.latitude = friends_lat;
        Coord.longitude = friends_long;
        
        CLLocation* loc1 = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees)friends_lat longitude:(CLLocationDegrees)friends_long];
        CLLocation* loc2 = [[CLLocation alloc] initWithLatitude:(CLLocationDegrees)userLocation.location.coordinate.latitude longitude:(CLLocationDegrees)userLocation.location.coordinate.longitude];
        CLLocationDistance dist = 3.0*[loc1 distanceFromLocation:loc2];
        
        NSLog(@"******** distanza : %f",dist);
        NSLog(@"******** loc1 : %f-%f",loc1.coordinate.latitude,loc1.coordinate.longitude);
        NSLog(@"******** loc2 : %f-%f",loc2.coordinate.latitude,loc2.coordinate.longitude);
        
        CLLocationCoordinate2D center_between;
        center_between.latitude = friends_lat;// - userLocation.location.coordinate.latitude;
        center_between.longitude = friends_long;// - userLocation.location.coordinate.longitude;
        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance (center_between,dist,dist);
        
        //maxLat = -75, minLat = 75, maxLon = -175, minLon = 175
        if(region.span.latitudeDelta>180)region.span.latitudeDelta=180;
        if(region.span.longitudeDelta>360)region.span.longitudeDelta=360;
        
        MKCoordinateRegion adjustedRegion = [self.mappa regionThatFits:region];
        NSLog(@"******** adjustedRegion: %f,%f  %f-%f",adjustedRegion.center.latitude,adjustedRegion.center.longitude,adjustedRegion.span.latitudeDelta,adjustedRegion.span.longitudeDelta);
        if(userLocation.location.coordinate.latitude!=0.0 && userLocation.location.coordinate.longitude!=0.0)
            [self.mappa setRegion:adjustedRegion animated:NO];
        else
            NSLog(@"location 0 - 0");
    }
}
-(void)setMarkers{
    //NSLog(@"setMarkers");
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    CLLocationCoordinate2D Coord;
    Coord.latitude = friends_lat;
    Coord.longitude = friends_long;

    [annotation setCoordinate:Coord];
    [annotation setTitle:friendName]; //You can set the subtitle too
    [annotation setSubtitle:[NSString stringWithFormat:@"%@ - %d",update_string,mood]];
    [self.mappa addAnnotation:annotation];
    [self.mappa selectAnnotation:annotation animated:YES];
}

- (IBAction)sendInstantMessage:(id)sender {
    [[globalSingleton sharedManager] sendMessageToUser:friendName];
}

- (IBAction)followCompassButton:(id)sender {
    if(self.mappa.userTrackingMode==MKUserTrackingModeFollowWithHeading){
        [self.mappa setUserTrackingMode:MKUserTrackingModeFollow];
    }
    else{
        [self.mappa setUserTrackingMode:MKUserTrackingModeFollowWithHeading];
    }
}

- (IBAction)mapTypeSelect:(id)sender {
    UISegmentedControl* control = (UISegmentedControl*)sender;
    int selected_index = control.selectedSegmentIndex;
    switch(selected_index){
        case 1:
            self.mappa.mapType = MKMapTypeSatellite;
            break;
        case 2:
            self.mappa.mapType = MKMapTypeHybrid;
            break;
        default:
        case 0:
            self.mappa.mapType = MKMapTypeStandard;
            break;
    }
}


-(void)setFriendCoords:(double)_lat andLong:(double)_long{
    
    friends_lat = _lat;
    friends_long = _long;
    //NSLog(@"******** friends coords %f - %f",friends_lat,friends_long);
}
-(void)setFriendUpdate:(NSString*)upd_string{
    update_string = upd_string;
}
-(void)setFriendMood:(int)mood_{
    mood = mood_;
}

-(void)setFriendMessage:(NSString*)_message{
    status_message = _message;
    self.statusLabel.text=status_message;
}
@end
