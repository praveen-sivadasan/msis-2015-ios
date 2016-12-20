//
//  MyCoursesViewController.m
//  edConnect
//
//  Created by Praveen Sivadasan on 12/12/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import "StudentCoursesViewController.h"
#import "LoggedUser.h"
#import "SessionData.h"
#import "StudentCourseInfoController.h"


@interface StudentCoursesViewController ()

@end

@implementation StudentCoursesViewController

@synthesize studentCourseList;
@synthesize searchResults;

@synthesize totalCourseLabel;
@synthesize totalGradeLabel;
@synthesize courseValue;
@synthesize gradeValue;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadActivityIndicator];
    [self initilizePage];
    [[self.view viewWithTag:12] stopAnimating];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:animated];
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

-(void) initilizePage{
    LoggedUser *luser =[SessionData getLoggedUser];
    
    [[self totalGradeLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    [[self totalCourseLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    
    //initializing total grade
    NSArray* totalCourses = [self totalCoursesTaken:luser];
    CGFloat sum = 0;
    for(PFObject *obj in totalCourses){
        NSString *gradeString = [obj objectForKey:@"grade"];
        CGFloat grade = [gradeString floatValue];
        sum+=grade;
    }
    if([totalCourses count] != 0){
        CGFloat totalGrade = sum/[totalCourses count];
        self.gradeValue.text = [NSString stringWithFormat: @"%.2f",totalGrade];
    }else{
        self.gradeValue.text = @"0";
    }
    
    //initializing tot course
    self.courseValue.text = [NSString stringWithFormat: @"%ld",[totalCourses count]];
    
    
    self.navigationController.navigationBar.hidden = YES;
    [self poppulateCourseTableView:luser];
    self.mycourseTableView.dataSource=self;
    self.mycourseTableView.delegate=self;
    UINavigationController *searchResultsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"StudentCourseNavController"];
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    self.searchController.searchResultsUpdater = self;
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,
                                                       self.searchController.searchBar.frame.origin.y,
                                                       self.searchController.searchBar.frame.size.width, 44.0);
    self.mycourseTableView.tableHeaderView = self.searchController.searchBar;
    self.mycourseTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}


-(void) poppulateCourseTableView : (LoggedUser*) luser{
    PFQuery *query = [PFQuery queryWithClassName:@"StudentCourses"];
    [query whereKey:@"userId" equalTo:luser.userObject];
    [query includeKey:@"courseId"];
    [query orderByAscending:@"status"];
    studentCourseList = [query findObjects];
}

-(NSArray*) totalCoursesTaken : (LoggedUser*) luser{
    PFQuery *query = [PFQuery queryWithClassName:@"StudentCourses"];
    [query whereKey:@"userId" equalTo:luser.userObject];
    [query whereKey:@"status" equalTo:@"Approved"];
    return [query findObjects];
}


/* UITableView settings rows and data */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [studentCourseList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellId=@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell==Nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    PFObject * obj = [studentCourseList objectAtIndex:indexPath.row];
    PFObject * courseObj = [obj objectForKey:@"courseId"];
    
    cell.textLabel.text = [courseObj objectForKey:@"name"];
    
    /*setting image*/
    NSData *imageFile = nil;
    if([courseObj objectForKey:@"image"] != nil)
        imageFile = [[courseObj objectForKey:@"image"] getData];
    UIImage *cImage = [[UIImage alloc] initWithData:imageFile];
    if(cImage == nil){
        cImage = [UIImage imageNamed:@"user_default.png"];
    }
    cell.imageView.image = cImage;
    
    cell.detailTextLabel.text = [obj objectForKey:@"status"];
    cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    
    return cell;
}

/* on table cell click */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PFObject * obj = studentCourseList[indexPath.row];
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"StudentCourseInfoController"];
    ((StudentCourseInfoController*)vc).studentCourseObj = obj;
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
        StudentCoursesViewController *vc = (StudentCoursesViewController *)navController.topViewController;
        // Update searchResults
        vc.studentCourseList = self.searchResults;
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
        for (PFObject *myObj in self.studentCourseList) {
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *vc = [segue destinationViewController];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;//UIModalTransitionStyleFlipHorizontal;
}


@end
