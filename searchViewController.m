//
//  searchViewController.m
//  mySocialMood
//
//  Created by muccio on 30/01/14.
//  Copyright (c) 2014 muccio. All rights reserved.
//

#import "searchViewController.h"

@interface searchViewController ()

@end

@implementation searchViewController
@synthesize searchBar;

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
    if([calling_function isEqualToString:@"searchPeople"]){
        NSLog(@"search error");
    }
    if([calling_function isEqualToString:@"addfriendERR"]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR" message:@"Cannot add as friend" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
    [self.refreshControl endRefreshing];
}
-(void)handleEvents:(NSNotification *) notification{
    NSDictionary *userInfo = notification.userInfo;
    NSString *operation = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"operation"]];
    globalSingleton* globals = [globalSingleton sharedManager];
    
    if([operation isEqualToString:@"search_Loaded"]){
        
        search_results = [[NSMutableArray alloc] init];
        [search_results addObjectsFromArray:[globals search_results]];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        
    }
    
    if([operation isEqualToString:@"addfriendOK"]){
        [globals getFriends];
        [globals getFollowers];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Friend added" message:@"New friend added" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
        [alert show];
    }
}

-(void)updateTable{
    globalSingleton* globals = [globalSingleton sharedManager];
    [globals searchPeople:self.searchBar.text];
    [self.refreshControl endRefreshing];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleErrors:)
                                                 name:@"handleErrors"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleEvents:)
                                                 name:@"handleEvents"
                                               object:nil];
    globalSingleton* globals = [globalSingleton sharedManager];
    search_results = [globals search_results];
    
    UISearchBar *tempSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0)];
    self.searchBar = tempSearchBar;
    self.searchBar.delegate = self;
    [self.searchBar sizeToFit];
    self.tableView.tableHeaderView = self.searchBar;

    UIRefreshControl *refreshControl = [[UIRefreshControl alloc]
                                        init];
    refreshControl.tintColor = [UIColor magentaColor];
    [refreshControl addTarget:self action:@selector(updateTable) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [search_results count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cella_";
    UITableViewCell *cell;
    
    cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell... setting the text of our cell's label
    cell.textLabel.text = [[search_results objectAtIndex:indexPath.row] objectAtIndex:0];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"mood: %@ - %@", [[search_results objectAtIndex:indexPath.row] objectAtIndex:1],[[search_results objectAtIndex:indexPath.row] objectAtIndex:4]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selected: %d",indexPath.row);
    NSMutableArray* selected_result = [search_results objectAtIndex:indexPath.row];
    NSLog(@"%@",[selected_result objectAtIndex:0]);
    globalSingleton* globals = [globalSingleton sharedManager];
    [globals addFriend:[selected_result objectAtIndex:0]];
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.view endEditing:YES];
    globalSingleton* globals = [globalSingleton sharedManager];
    [globals searchPeople:self.searchBar.text];
    NSLog(@"searching...");
    [self.refreshControl beginRefreshing];
}
- (IBAction)closeButton:(id)sender {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [self.view endEditing:YES];
}
@end
