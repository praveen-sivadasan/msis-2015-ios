//
//  EnrolledStudentsViewController.m
//  edConnect
//
//  Created by Praveen Sivadasan on 12/15/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import "EnrolledStudentsViewController.h"
#import "LoggedUser.h"
#import "SessionData.h"
#import "FacultyCourseInfoController.h"
#import "ChartViewController.h"

@interface EnrolledStudentsViewController ()

@end

@implementation EnrolledStudentsViewController

@synthesize approvedStudentCourseList;
@synthesize searchResults;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadActivityIndicator];
    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationController.navigationBar.hidden = YES;
    [self initializePage];
    [[self.view viewWithTag:12] stopAnimating];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
}

-(void) initializePage{
    //LoggedUser *luser =[SessionData getLoggedUser];
    [self fetchAllEnrolledStudents];
    
    [_viewChartButton setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                        [UIFont fontWithName:@"HelveticaNeue" size:12], NSFontAttributeName,
                                        [UIColor whiteColor], NSForegroundColorAttributeName,
                                        nil] 
                              forState:UIControlStateNormal];
//    
//    _viewChartButton settitl
//    
//    _viewChartButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
//
//    
//    [[self viewChartButton] setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:12]];
    
    self.studentView.backgroundColor = [UIColor colorWithRed:242/255.0f green:241/255.0f blue:236/255.0f alpha:1.0f];
    
    _enrolledNavBar.barTintColor = [UIColor colorWithRed:171/255.0f green:4/255.0f blue:30/255.0f alpha:1.0f];
    _enrolledNavBar.tintColor = [UIColor whiteColor];
    _enrolledNavBar.translucent = NO;
    _enrolledNavBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    self.studentView.dataSource=self;
    self.studentView.delegate=self;
    UINavigationController *searchResultsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"ApprvdStudentNavController"];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,
                                                       self.searchController.searchBar.frame.origin.y,
                                                       self.searchController.searchBar.frame.size.width, 44.0);
    self.studentView.tableHeaderView = self.searchController.searchBar;
    //self.studentView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
}

- (void) fetchAllEnrolledStudents{
    PFQuery *query = [PFQuery queryWithClassName:@"StudentCourses"];
    if(_selectedCourse != nil){
        [query whereKey:@"courseId" equalTo:_selectedCourse];
        [query whereKey:@"status" equalTo:@"Approved"];
        approvedStudentCourseList = [query findObjects];
        
        if([approvedStudentCourseList count] > 0){
            for(PFObject *studentCourse in approvedStudentCourseList){
                PFObject * userObj = [studentCourse objectForKey:@"userId"];
                if(![[userObj allKeys] containsObject:@"first_name"]){
                    //Fetch the user details sperately
                    NSString *userId = [userObj valueForKey:@"objectId"];
                    userObj = [self fetchAppUser:userId];
                    [studentCourse setObject:userObj forKey:@"userId"];
                }
            }
        }
    }
}

- (PFObject*) fetchAppUser:(NSString*) id{
    PFQuery *query = [PFQuery queryWithClassName:@"AppUser"];
    [query whereKey:@"objectId" equalTo:id];
    NSArray *allusers = [query findObjects];
    if([allusers count] != 0){
        return [allusers objectAtIndex:0];
    }
    return nil;
}


- (IBAction)updateGrades:(id)sender {
    NSNumberFormatter *nf1 = [[NSNumberFormatter alloc] init];
    
    if([self validateAddGrades:nf1]){
        NSArray *cells = [_studentView visibleCells];
        for (NSInteger j = 0; j < [ _studentView numberOfSections]; ++j)
        {
            for (NSInteger i = 0; i < [_studentView numberOfRowsInSection:j]; ++i)
            {
                PFObject *obj = approvedStudentCourseList[i];
                
                UITableViewCell *cell = cells[i];
                UITextField *textField = (UITextField *)[cell.contentView viewWithTag:2];
                [obj setObject:[nf1 numberFromString:textField.text] forKey:@"grade"];
                
                [obj save];
                
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@""
                                              message:@"Grades updated successfully."
                                              preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                     }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        
    }
}

- (Boolean) validateAddGrades:(NSNumberFormatter*) nf {
    NSArray *cells = [_studentView visibleCells];
    for (NSInteger j = 0; j < [ _studentView numberOfSections]; ++j)
    {
        for (NSInteger i = 0; i < [_studentView numberOfRowsInSection:j]; ++i)
        {
            UITableViewCell *cell = cells[i];
            UITextField *textField = (UITextField *)[cell.contentView viewWithTag:2];
            if([nf numberFromString:textField.text] == nil){
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@""
                                              message:@"Invalid grades."
                                              preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                return false;
            }else if([[nf numberFromString:textField.text] floatValue] > 5.0){
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@""
                                              message:@"Max grade is 5."
                                              preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                return false;
            }
            
        }
    }
    
    
    return true;
}

/* UITableView settings rows and data */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [approvedStudentCourseList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellId=@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell==Nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.backgroundColor = [UIColor colorWithRed:242/255.0f green:241/255.0f blue:236/255.0f alpha:1.0f];
    cell.accessoryType = UITableViewCellAccessoryNone;
    PFObject * obj = [approvedStudentCourseList objectAtIndex:indexPath.row];
    PFObject * userObject = [obj objectForKey:@"userId"];
    
    NSString *full_name = [[userObject objectForKey:@"first_name"] stringByAppendingString:[NSString stringWithFormat: @" %@", [userObject objectForKey:@"last_name"]]];
    cell.textLabel.text = full_name;
    
    /*setting image*/
    NSData *imageFile = nil;
    if([userObject objectForKey:@"image"] != nil)
        imageFile = [[userObject objectForKey:@"image"] getData];
    UIImage *cImage = [[UIImage alloc] initWithData:imageFile];
    if(cImage == nil){
        cImage = [UIImage imageNamed:@"user_default.png"];
    }
    cell.imageView.image = cImage;
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(230, 10, 100, 30)];
    textField.clearsOnBeginEditing = NO;
    textField.textAlignment = NSTextAlignmentRight;
    textField.layer.borderColor=[[UIColor lightGrayColor]CGColor];
    textField.layer.borderWidth=1.0;
    textField.delegate = self;
    textField.tag = 2;
    textField.placeholder = @"Enter grade";
    
    if([obj objectForKey:@"grade"] != nil){
        NSString *capac1 = [NSString stringWithFormat: @"%@",[obj objectForKey:@"grade"]];
        float value = [capac1 floatValue];
        textField.text = [NSString stringWithFormat: @"%.2f",value];
    }
    
    [cell.contentView addSubview:textField];
    
    
    return cell;
}

/* on table cell click */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
        EnrolledStudentsViewController *vc = (EnrolledStudentsViewController *)navController.topViewController;
        // Update searchResulffts
        vc.approvedStudentCourseList = self.searchResults;
        // And reload the tableView with the new data
        [vc.studentView reloadData];
    }
    self.navigationController.navigationBar.hidden = YES;
}


// Update self.searchResults based on searchString, which is the argument in passed to this method
- (void)updateFilteredContentForName:(NSString *)name{
    if (name == nil) {
        // If empty the search results are the same as the original data
        self.searchResults = [self.studentView mutableCopy];
    } else {
        NSMutableArray *searchResults1 = [[NSMutableArray alloc] init];
        for (PFObject *myObj in self.approvedStudentCourseList) {
            PFObject *user = [myObj objectForKey:@"userId"];
            NSString *first_name = [user objectForKey:@"first_name"];
            if ([first_name.lowercaseString containsString:name.lowercaseString]) {
                [searchResults1 addObject:myObj];
            }
        }
        self.searchResults = searchResults1;
    }
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - Navigation

//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//
//    UIViewController *vc1 = [segue destinationViewController];
//    FacultyCourseInfoController *vc2 = (FacultyCourseInfoController *)(vc1);
//    vc2.selectedUserCourseObj = _selectedUserCourseObj;
//    vc2.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;//UIModalTransitionStyleFlipHorizontal;
//
//
//    NSString * storyboardName = @"Main";
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
//    UIViewController * vc;
//    vc = [storyboard instantiateViewControllerWithIdentifier:@"OtherUserCoursesViewController"];
//    //[self presentViewController:vc animated:YES completion:nil];
//
//    if(_selectedUserCourseObj == nil){
//        segue des
//    }
//
//     vc2.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;//UIModalTransitionStyleFlipHorizontal;
//
//}


- (IBAction)backButton:(id)sender {
    
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc;
    vc = [storyboard instantiateViewControllerWithIdentifier:@"FacultyCourseInfoController"];
    
    FacultyCourseInfoController *obj = (FacultyCourseInfoController*)vc;
    obj.selectedUserCourseObj = _selectedUserCourseObj;
    
    if(_selectedUserCourseObj == nil){
        vc = [storyboard instantiateViewControllerWithIdentifier:@"OtherUserCoursesViewController"];
    }
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)showChart:(id)sender {
    
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc;
    vc = [storyboard instantiateViewControllerWithIdentifier:@"ChartViewController"];
    
    ChartViewController *obj = (ChartViewController*)vc;
    obj.selectedUserCourseObj = _selectedUserCourseObj;
    obj.selectedCourse = _selectedCourse;
    
    [self presentViewController:vc animated:YES completion:nil];
}


@end
