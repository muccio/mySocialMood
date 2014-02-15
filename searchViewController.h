//
//  searchViewController.h
//  mySocialMood
//
//  Created by muccio on 30/01/14.
//  Copyright (c) 2014 muccio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "globalSingleton.h"

@interface searchViewController : UITableViewController<UISearchBarDelegate>{
    NSMutableArray *search_results;
    int selected_detail;

}
- (IBAction)closeButton:(id)sender;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@end
