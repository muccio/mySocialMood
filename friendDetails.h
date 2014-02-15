//
//  friendDetails.h
//  mySocialMood
//
//  Created by muccio on 22/01/14.
//  Copyright (c) 2014 muccio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "globalSingleton.h"

@interface friendDetails : UIViewController<MKMapViewDelegate>{
    double friends_lat;
    double friends_long;
    NSString* update_string;
    int mood;
    NSString* status_message;
    NSTimer* friend_position_updater;
}

@property (weak, nonatomic) IBOutlet MKMapView *mappa;
@property (nonatomic ,strong) NSString* userName;
@property (nonatomic ,strong) NSString* friendName;
@property (nonatomic ,strong) NSTimer* friend_position_updater;
-(void)setFriendCoords:(double)_lat andLong:(double)_long;
-(void)setFriendUpdate:(NSString*)upd_string;
-(void)setFriendMessage:(NSString*)status_message;
-(void)setFriendMood:(int)mood_;
-(void)setMarkers;
- (IBAction)sendInstantMessage:(id)sender;
- (IBAction)followCompassButton:(id)sender;
- (IBAction)mapTypeSelect:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end
