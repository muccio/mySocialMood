//
//  mySocialMoodFriends.h
//  mySocialMood
//
//  Created by muccio on 21/01/14.
//  Copyright (c) 2014 muccio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "globalSingleton.h"
#import "friendDetails.h"

@interface mySocialMoodFriends : UITableViewController{
    NSMutableArray *items;
    int selected_detail;
}

@end
