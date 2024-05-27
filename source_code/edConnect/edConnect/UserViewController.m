//
//  UserViewController.m
//  edConnect
//
//  Created by Praveen Sivadasan on 12/11/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import "UserViewController.h"
#import "LoggedUser.h"
#import "SessionData.h"
#import "AddUserViewController.h"


@interface UserViewController ()

@end

@implementation UserViewController

@synthesize users;
@synthesize searchResults;
@synthesize showStudents;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadActivityIndicator];
    [self setNeedsStatusBarAppearanceUpdate];
    [self initilizePage];
    [[self.view viewWithTag:12] stopAnimating];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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


-(void) initilizePage{
    
    _userNavBar.barTintColor = [UIColor colorWithRed:171/255.0f green:4/255.0f blue:30/255.0f alpha:1.0f];
    _userNavBar.tintColor = [UIColor whiteColor];
    _userNavBar.translucent = NO;
    _userNavBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    self.userTableView.backgroundColor = [UIColor colorWithRed:242/255.0f green:241/255.0f blue:236/255.0f alpha:1.0f];
    
    LoggedUser *luser =[SessionData getLoggedUser];
    
    self.navigationController.navigationBar.hidden = YES;
    NSString *roleValue = self.showStudents?@"Student":@"Faculty";
    
    PFQuery *query = [PFQuery queryWithClassName:@"AppUser"];
    [query whereKey:@"role" equalTo:roleValue];
    users = [query findObjects];
    
    self.userTableView.dataSource=self;
    self.userTableView.delegate=self;
    
    UINavigationController *searchResultsController = [[self storyboard] instantiateViewControllerWithIdentifier:@"UserViewNavController"];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    self.searchController.searchResultsUpdater = self;
    
    self.searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x,
                                                       self.searchController.searchBar.frame.origin.y,
                                                       self.searchController.searchBar.frame.size.width, 44.0);
    
    self.userTableView.tableHeaderView = self.searchController.searchBar;
    self.userTableView.editing = NO;
    
    if([roleValue isEqualToString:@"Student"]){
        _userNavBar.topItem.title = @"Students";
    }else{
        _userNavBar.topItem.title = @"Faculties";
    }
    
}

/* UITableView settings rows and data */

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [users count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellId=@"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if(cell==Nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
    }
    cell.backgroundColor = [UIColor colorWithRed:242/255.0f green:241/255.0f blue:236/255.0f alpha:1.0f];
    PFObject * obj = [users objectAtIndex:indexPath.row];
    cell.textLabel.text = [obj valueForKey:@"first_name"];
    
    /*setting image*/
    NSData *imageFile = [[obj objectForKey:@"image"] getData];
    UIImage *userImage = [[UIImage alloc] initWithData:imageFile];
    if(userImage == nil){
         userImage = [UIImage imageNamed:@"user_default.png"];
    }
    cell.imageView.image = userImage;
    
    return cell;
}

/* on table cell click */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = cell.textLabel.text;
    
    for(PFObject * obj in users){
        if([obj  valueForKey:@"first_name"] == cellText){
            NSString * storyboardName = @"Main";
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
            UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"AddUserViewController"];
            AddUserViewController *acvc = (AddUserViewController*)vc   ;
            acvc.selectedUser = obj;
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
        UserViewController *vc = (UserViewController *)navController.topViewController;
        // Update searchResults
        vc.users = self.searchResults;
        // And reload the tableView with the new data
        [vc.userTableView reloadData];
    }
    self.navigationController.navigationBar.hidden = YES;
}


// Update self.searchResults based on searchString, which is the argument in passed to this method
- (void)updateFilteredContentForName:(NSString *)name{
    if (name == nil) {
        // If empty the search results are the same as the original data
        self.searchResults = [self.userTableView mutableCopy];
    } else {
        NSMutableArray *searchResults1 = [[NSMutableArray alloc] init];
        for (PFObject *userObj in self.users) {
            NSString *cname = [userObj valueForKey:@"first_name"];
            if ([cname.lowercaseString containsString:name.lowercaseString]) {
                [searchResults1 addObject:userObj];
            }
        }
        self.searchResults = searchResults1;
    }
    self.navigationController.navigationBar.hidden = YES;
}


/* Delete data */
- (IBAction)editTableView:(id)sender {
    // make the table row editable
    //[[self userTableView] setEditing:!self.userTableView.editing animated:YES];
}

-(void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        PFObject *selectedObject = [users objectAtIndex:indexPath.row];
        
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
        NSMutableArray *arrayThatYouCanRemoveObjects = [NSMutableArray arrayWithArray:users];
        [arrayThatYouCanRemoveObjects removeObjectAtIndex:indexPath.row];
        users = [NSArray arrayWithArray: arrayThatYouCanRemoveObjects];
        
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}



@end
