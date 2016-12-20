//
//  CoursesViewController.m
//  edConnect
//
//  Created by Praveen Sivadasan on 12/5/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import "CoursesViewController.h"
#import "AddCoursesViewController.h"
#import "LoggedUser.h"
#import "SessionData.h"

@interface CoursesViewController ()

@end

@implementation CoursesViewController

@synthesize courses;
@synthesize searchResults;
NSArray *masterCoursesAvailable;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadActivityIndicator];
    [self setNeedsStatusBarAppearanceUpdate];

    self.activityIndicator.hidden = YES; // ACtivity indicator disabled for now
    self.activityIndicator.center = self.view.center;
    [self.activityIndicator startAnimating];
    [self initilizePage];
    [self.activityIndicator stopAnimating];
    self.activityIndicator.hidden = YES;
    
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

-(void) initilizePage{
    
    LoggedUser *luser =[SessionData getLoggedUser];
    
    _courseNavBar.barTintColor = [UIColor colorWithRed:171/255.0f green:4/255.0f blue:30/255.0f alpha:1.0f];
    _courseNavBar.tintColor = [UIColor whiteColor];
    _courseNavBar.translucent = NO;
    _courseNavBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    self.courseTableView.backgroundColor = [UIColor colorWithRed:242/255.0f green:241/255.0f blue:236/255.0f alpha:1.0f];
    
    self.navigationController.navigationBar.hidden = YES;
    
    PFQuery *query = [PFQuery queryWithClassName:@"Courses"];
    [query selectKeys:@[@"name",@"instructor",@"term",@"capacity",@"start_date",@"image"]];
    courses = [query findObjects];
    masterCoursesAvailable = courses;
    
    self.courseTableView.dataSource=self;
    self.courseTableView.delegate=self;
    
    UINavigationController *searchResultsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"CourseViewNavController"];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    self.searchController.searchResultsUpdater = self;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,
                                                       self.searchController.searchBar.frame.origin.y,
                                                       self.searchController.searchBar.frame.size.width, 44.0);
    
    self.courseTableView.tableHeaderView = self.searchController.searchBar;
    
    /* Conditional hiding of add course button */
    if([luser.user.role.lowercaseString isEqualToString:@"Student".lowercaseString] || [luser.user.role.lowercaseString isEqualToString:@"Faculty".lowercaseString] ){
        self.addCourseButton.enabled = NO;
    }
    
    self.courseTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/* UITableView settings rows and data */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [courses count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellId=@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell==Nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    cell.backgroundColor = [UIColor colorWithRed:242/255.0f green:241/255.0f blue:236/255.0f alpha:1.0f];

    PFObject * obj = [courses objectAtIndex:indexPath.row];
    cell.textLabel.text = [obj  valueForKey:@"name"];

    /*setting image*/
    NSData *imageFile = [[obj objectForKey:@"image"] getData];
    UIImage *cImage = [[UIImage alloc] initWithData:imageFile];
    if(cImage == nil){
        cImage = [UIImage imageNamed:@"user_default.png"];
    }
    cell.imageView.image = cImage;
    
    return cell;
}

/* on table cell click */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = cell.textLabel.text;
    
    for(PFObject * obj in courses){
        if([obj  valueForKey:@"name"] == cellText){
            self.activityIndicator.hidden = YES;
            [self.activityIndicator startAnimating];
            
            NSString * storyboardName = @"Main";
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
            UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"AddCoursesViewController"];
            AddCoursesViewController *acvc = (AddCoursesViewController*)vc   ;
            acvc.selectedCourse = obj;
            [self.activityIndicator stopAnimating];
        
            [self presentViewController:vc animated:YES completion:nil];
        }
    }
}

// Called when the search bar becomes first responder
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    // Set searchString equal to what's typed into the searchbar
    NSString *searchString = self.searchController.searchBar.text;
    [self updateFilteredContentForName:searchString];
    // If searchResultsController
    if (self.searchController.searchResultsController) {
        UINavigationController *navController = (UINavigationController *)self.searchController.searchResultsController;
        navController.navigationBar.hidden = YES;
        // Present SearchResultsTableViewController as the topViewController
        CoursesViewController *vc = (CoursesViewController *)navController.topViewController;
        // Update searchResults
        vc.courses = searchResults;
        // And reload the tableView with the new data
        [vc.courseTableView reloadData];
    }
    self.navigationController.navigationBar.hidden = YES;
}


// Update self.searchResults based on searchString, which is the argument in passed to this method
- (void)updateFilteredContentForName:(NSString *)name{
    if (name == nil) {
        // If empty the search results are the same as the original data
        self.searchResults = [self.courseTableView mutableCopy];
    } else {
        NSMutableArray *searchResults1 = [[NSMutableArray alloc] init];
        for (PFObject *course in masterCoursesAvailable) {
            NSString *cname = [course valueForKey:@"name"];
            if ([cname.lowercaseString containsString:name.lowercaseString]) {
                [searchResults1 addObject:course];
            }
        }
        searchResults = searchResults1;
    }
    self.navigationController.navigationBar.hidden = YES;
}


/* Delete data */
- (IBAction)editTableView:(id)sender {
    // make the table row editable
    [[self courseTableView] setEditing:!self.courseTableView.editing animated:YES];
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        PFObject *selectedObject = [courses objectAtIndex:indexPath.row];
        
        PFQuery *query = [PFQuery queryWithClassName:@"Courses"];
        [query whereKey:@"objectId" equalTo:[selectedObject valueForKey:@"objectId"]];
        [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                for (PFObject *object in objects) {
                    [object deleteInBackground];
                    NSLog(@"Deleted");
                }
            } else {
                NSLog(@"Error db");
            }
        }];
        
        /* updating courses list*/
        NSMutableArray *arrayThatYouCanRemoveObjects = [NSMutableArray arrayWithArray:courses];
        [arrayThatYouCanRemoveObjects removeObjectAtIndex:indexPath.row];
        courses = [NSArray arrayWithArray: arrayThatYouCanRemoveObjects];
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@"Delete"
                                      message:@"Deleted successfully"
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


/*
 #pragma mark - Navigation*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UIViewController *vc = [segue destinationViewController];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;//UIModalTransitionStyleFlipHorizontal;
    
}


@end
