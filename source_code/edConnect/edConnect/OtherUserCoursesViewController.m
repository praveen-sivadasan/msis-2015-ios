//
//  OtherUserCoursesViewController.m
//  edConnect
//
//  Created by Praveen Sivadasan on 12/13/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import "OtherUserCoursesViewController.h"
#import "LoggedUser.h"
#import "SessionData.h"
#import "FacultyCourseInfoController.h"

@interface OtherUserCoursesViewController ()

@end

@implementation OtherUserCoursesViewController

@synthesize userCourseList;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadActivityIndicator];
    [self initilizePage];
    [self setNeedsStatusBarAppearanceUpdate];
    [[self.view viewWithTag:12] stopAnimating];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) initilizePage{
    LoggedUser *luser =[SessionData getLoggedUser];
    self.navigationController.navigationBar.hidden = YES;
    
    [self poppulateCourseTableView:luser];
    self.mycourseTableView.dataSource=self;
    self.mycourseTableView.delegate=self;
    
    UINavigationController *searchResultsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"OtherUserCourseNavController"];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,
                                                       self.searchController.searchBar.frame.origin.y,
                                                       self.searchController.searchBar.frame.size.width, 44.0);
    self.mycourseTableView.tableHeaderView = self.searchController.searchBar;
    self.mycourseTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    if([luser.user.role isEqualToString:@"Admin"]){
        _otherUserNavBar.topItem.title = @"Requests";
    }
    
    self.mycourseTableView.backgroundColor = [UIColor colorWithRed:242/255.0f green:241/255.0f blue:236/255.0f alpha:1.0f];
    
    self.view.layer.backgroundColor = [[UIColor colorWithRed:242/255.0f green:241/255.0f blue:236/255.0f alpha:1.0f] CGColor];
    
    _otherUserNavBar.barTintColor = [UIColor colorWithRed:171/255.0f green:4/255.0f blue:30/255.0f alpha:1.0f];
    _otherUserNavBar.tintColor = [UIColor whiteColor];
    _otherUserNavBar.translucent = NO;
    _otherUserNavBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    
}


-(void) loadActivityIndicator{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    CGSize spinSize = spinner.frame.size;
    spinner.frame = CGRectMake(320, 0,spinSize.width, spinSize.height);
    spinner.tag = 12;
    spinner.color = [UIColor whiteColor];
    [self.view addSubview:spinner];
    [spinner startAnimating];
}


-(void) poppulateCourseTableView : (LoggedUser*) luser{
    if([luser.user.role isEqualToString:@"Admin"]){
        NSArray *myReqs;
        PFQuery *query1 = [PFQuery queryWithClassName:@"StudentCourses"];
        NSArray *myReq1 = [query1 findObjects];
        
        PFQuery *query2 = [PFQuery queryWithClassName:@"FacultyCourses"];
        NSArray *myReq2 = [query2 findObjects];
        myReqs = [myReq1 arrayByAddingObjectsFromArray:myReq2];
        
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"updatedAt" ascending:YES];
        userCourseList =[myReqs sortedArrayUsingDescriptors:@[sort]];
    }else if([luser.user.role isEqualToString:@"Faculty"]){
        PFQuery *query = [PFQuery queryWithClassName:@"FacultyCourses"];
        [query whereKey:@"userId" equalTo:luser.userObject];
        [query includeKey:@"courseId"];
        [query orderByAscending:@"status"];
        userCourseList = [query findObjects];
    }
}

/* UITableView settings rows and data */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [userCourseList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LoggedUser *luser =[SessionData getLoggedUser];
    static NSString *cellId=@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell==Nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    cell.backgroundColor = [UIColor colorWithRed:242/255.0f green:241/255.0f blue:236/255.0f alpha:1.0f];
    
    PFObject * obj = [userCourseList objectAtIndex:indexPath.row];
    PFObject * courseObj = [obj objectForKey:@"courseId"];
    PFObject * userObj = [obj objectForKey:@"userId"];
    
    if(![[courseObj allKeys] containsObject:@"name"]){
        //Fetch the user details sperately
        NSString *courseId = [courseObj valueForKey:@"objectId"];
        courseObj = [self fetchCourseFromUserCourse:courseId];
    }
    if(![[userObj allKeys] containsObject:@"first_name"]){
        //Fetch the user details sperately
        NSString *appUserId = [userObj valueForKey:@"objectId"];
        userObj = [self fetchAppUserFromUserCourse:appUserId];
    }
    NSString *full_name = [[userObj objectForKey:@"first_name"] stringByAppendingString:[NSString stringWithFormat: @" %@", [userObj objectForKey:@"last_name"]]];
    
    NSString *full_name_withRole = [full_name stringByAppendingString:[NSString stringWithFormat: @" ( %@ )", [userObj objectForKey:@"role"]]];
    
    NSString *status = [obj objectForKey:@"status"];
    
    /* Cell values */
    cell.textLabel.text = [[courseObj objectForKey:@"name"] stringByAppendingString:[NSString stringWithFormat: @" ( %@ )",[status substringToIndex:1]]];
    ;
    cell.detailTextLabel.text =full_name_withRole;
    cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    
    
    /*setting image*/
    NSData *imageFile = nil;
    if([courseObj objectForKey:@"image"] != nil)
        imageFile = [[courseObj objectForKey:@"image"] getData];
    UIImage *cImage = [[UIImage alloc] initWithData:imageFile];
    if(cImage == nil){
        cImage = [UIImage imageNamed:@"book_default.png"];
    }
    cell.imageView.image = cImage;
    
    return cell;
}

- (PFObject*) fetchAppUserFromUserCourse:(NSString*) id{
    PFQuery *query = [PFQuery queryWithClassName:@"AppUser"];
    [query whereKey:@"objectId" equalTo:id];
    NSArray *allusers = [query findObjects];
    if([allusers count] != 0){
        return [allusers objectAtIndex:0];
    }
    return nil;
}

- (PFObject*) fetchCourseFromUserCourse:(NSString*) id{
    PFQuery *query = [PFQuery queryWithClassName:@"Courses"];
    [query whereKey:@"objectId" equalTo:id];
    NSArray *allcourses = [query findObjects];
    if([allcourses count] != 0){
        return [allcourses objectAtIndex:0];
    }
    return nil;
}

/* on table cell click */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject * obj = userCourseList[indexPath.row];
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc;
    vc = [storyboard instantiateViewControllerWithIdentifier:@"FacultyCourseInfoController"];
    ((FacultyCourseInfoController*)vc).selectedUserCourseObj = obj;
    [self presentViewController:vc animated:YES completion:nil];
}

// Called when the search bar becomes first responder
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    NSString *searchString = self.searchController.searchBar.text;
    [self updateFilteredContentForName:searchString];
    // If searchResultsController
    if (self.searchController.searchResultsController) {
        UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
        navController.navigationBar.hidden = YES;
        // Present SearchResultsTableViewController as the topViewController
        OtherUserCoursesViewController *vc = (OtherUserCoursesViewController *)navController.topViewController;
        // Update searchResults
        vc.userCourseList = self.searchResults;
        // And reload the tableView with the new data
        [vc.mycourseTableView reloadData];
    }
    self.navigationController.navigationBar.hidden = YES;
}


// Update self.searchResults based on searchString, which is the argument in passed to this method
- (void)updateFilteredContentForName:(NSString *)name{
    if (name == nil) {
        // If empty the search results are the same as the original data
        self.searchResults = [self.mycourseTableView mutableCopy];
    } else {
        NSMutableArray *searchResults1 = [[NSMutableArray alloc] init];
        for (PFObject *myObj in self.userCourseList) {
            PFObject *course = [myObj valueForKey:@"courseId"];
            NSString *cname = [course valueForKey:@"name"];
            if ([cname.lowercaseString containsString:name.lowercaseString]) {
                [searchResults1 addObject:myObj];
            }
        }
        self.searchResults = searchResults1;
    }
    self.navigationController.navigationBar.hidden = YES;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *vc = [segue destinationViewController];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;//UIModalTransitionStyleFlipHorizontal;
}


@end
