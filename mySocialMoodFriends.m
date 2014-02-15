//
//  mySocialMoodFriends.m
//  mySocialMood
//
//  Created by muccio on 21/01/14.
//  Copyright (c) 2014 muccio. All rights reserved.
//

#import "mySocialMoodFriends.h"

@interface mySocialMoodFriends ()

@end

@implementation mySocialMoodFriends

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)handleErrors:(NSNotification *) notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *calling_function = [NSString stringWithFormat:@"ERROR: %@",[userInfo objectForKey:@"caller"]];
    if([calling_function isEqualToString:@"getFriends"]){
        NSLog(@"refresh error");
    }
    [self.refreshControl endRefreshing];
}
-(void)handleEvents:(NSNotification *) notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *operation = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"operation"]];
    
    if([operation isEqualToString:@"friends Loaded"]){
        [self.tableView reloadData];
        
        [self.refreshControl endRefreshing];
    }
    if([operation isEqualToString:@"followers Loaded"]){
        [self.tableView reloadData];
        
        [self.refreshControl endRefreshing];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //items = [[NSMutableArray alloc] initWithObjects:@"Item No. 1", @"Item No. 2", @"Item No. 3", @"Item No. 4", @"Item No. 5", @"Item No. 6", nil];
    NSLog(@"Friends - viewDidLoad");
    globalSingleton* globals = [globalSingleton sharedManager];
    items = [globals amici];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    refreshControl.tintColor = [UIColor magentaColor];
    [refreshControl addTarget:self action:@selector(updateTable) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleErrors:)
                                                 name:@"handleErrors"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleEvents:)
                                                 name:@"handleEvents"
                                               object:nil];

}

-(void)updateTable{
    globalSingleton* globals = [globalSingleton sharedManager];
    [globals getFriends];
    [globals getFollowers];
    
    [globals getUserPositionSharingType];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    if (section==0)
    {
        return [items count];
    }
    else{
        return [[[globalSingleton sharedManager] followers] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell...
    static NSString *CellIdentifier = @"cella_";
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.section==0) {
        cell.textLabel.text = [[items objectAtIndex:indexPath.row] objectAtIndex:0];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"mood: %@ - %@", [[items objectAtIndex:indexPath.row] objectAtIndex:1],[[items objectAtIndex:indexPath.row] objectAtIndex:4]];
        cell.accessoryType = UITableViewCellAccessoryDetailButton;
        
    }
    if (indexPath.section==1)  {
        cell.textLabel.text = [[[[globalSingleton sharedManager] followers]  objectAtIndex:indexPath.row] objectAtIndex:0];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"mood: %@ - %@", [[[[globalSingleton sharedManager] followers]  objectAtIndex:indexPath.row] objectAtIndex:1],[[[[globalSingleton sharedManager] followers]  objectAtIndex:indexPath.row] objectAtIndex:4]];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    
    return cell;
    
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        if(indexPath.section==0){
            NSString* friend_name = [[items objectAtIndex:indexPath.row] objectAtIndex:0];
            [items removeObjectAtIndex:indexPath.row];
            [[globalSingleton sharedManager] removeFriend:friend_name];
        }
        if(indexPath.section==1){
            NSString* follower_name = [[[[globalSingleton sharedManager] followers] objectAtIndex:indexPath.row] objectAtIndex:0];
            [[[globalSingleton sharedManager] followers] removeObjectAtIndex:indexPath.row];
            [[globalSingleton sharedManager] removeFollower:follower_name];
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{/*
    //[self performSegueWithIdentifier:@"GroupToGroupMembers" sender:self];
    NSLog(@"accessoryButtonTappedForRowWithIndexPath");
    selected_detail = indexPath.row;
    NSLog(@"accessoryButtonTappedForRowWithIndexPath %d",selected_detail);*/
}

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"**** prepareForSegue: %@", segue.identifier);
    //
    if ([segue.identifier isEqualToString:@"push_map"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        selected_detail = indexPath.row;
        friendDetails *detailVC = (friendDetails*)segue.destinationViewController;
        detailVC.friendName = items[selected_detail][0];
        
        [detailVC setFriendCoords:[items[selected_detail][2] floatValue] andLong:[items[selected_detail][3] floatValue]];
        [detailVC setFriendUpdate:[[items objectAtIndex:indexPath.row] objectAtIndex:4]];
        [detailVC setFriendMood:[items[selected_detail][1] intValue]];
        [detailVC setFriendMessage:items[selected_detail][5] ];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return @"Following";
    if(section == 1)
        return @"Followers";
    return @"undefined";
}



@end
