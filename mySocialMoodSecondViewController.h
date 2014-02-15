//
//  mySocialMoodSecondViewController.h
//  mySocialMood
//
//  Created by muccio on 18/01/14.
//  Copyright (c) 2014 muccio. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WhirlyGlobeComponent.h"
#import "ConfigViewController.h"
#import "globalSingleton.h"

// Map or globe or startup
typedef enum {MaplyGlobe,MaplyGlobeWithElevation,Maply3DMap,Maply2DMap,MaplyNumTypes} MapType;

@interface mySocialMoodSecondViewController : UIViewController<WhirlyGlobeViewControllerDelegate,MaplyViewControllerDelegate,UIPopoverControllerDelegate>{
    /// This is the base class shared between the MaplyViewController and the WhirlyGlobeViewController
    MaplyBaseViewController *baseViewC;
    /// If we're displaying a globe, this is set
    WhirlyGlobeViewController *globeViewC;
    /// If we're displaying a map, this is set
    MaplyViewController *mapViewC;
    UIPopoverController *popControl;

}

// Fire it up with a particular base layer and map or globe display
- (id)initWithMapType:(MapType)mapType;
-(void)handleErrors:(NSNotification *) notification;
-(void)handleEvents:(NSNotification *) notification;
- (void)editDone;
@end
