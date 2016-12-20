//
//  FacultyCourseInfoController.m
//  edConnect
//
//  Created by Praveen Sivadasan on 12/13/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import "FacultyCourseInfoController.h"
#import "SessionData.h"
#import "EnrolledStudentsViewController.h"

@interface FacultyCourseInfoController ()

@end

@implementation FacultyCourseInfoController

@synthesize selectedUserCourseObj;
@synthesize studentsEnrolledButton;

PFObject *myCourseRequestCourseObj;


- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadActivityIndicator];
    [self setNeedsStatusBarAppearanceUpdate];
    LoggedUser *luser =[SessionData getLoggedUser];
    [self initializePage:luser];
    [[self.view viewWithTag:12] stopAnimating];}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) initializePage:(LoggedUser*) luser{
    
    self.view.layer.backgroundColor = [[UIColor colorWithRed:242/255.0f green:241/255.0f blue:236/255.0f alpha:1.0f] CGColor];
    
    _courseNavBar.barTintColor = [UIColor colorWithRed:171/255.0f green:4/255.0f blue:30/255.0f alpha:1.0f];
    _courseNavBar.tintColor = [UIColor whiteColor];
    _courseNavBar.translucent = NO;
    _courseNavBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    [[self nameLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    [[self totalCapacityLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    [[self seatsAvailableLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    [[self statusLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    [[self instructorLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    
    [self nameTextField].enabled = NO;
    _nameTextField.backgroundColor = [UIColor colorWithRed:216/255.0f green:214/255.0f blue:202/255.0f alpha:1.0f];
    [self capacityTextField].enabled = NO;
    _capacityTextField.backgroundColor = [UIColor colorWithRed:216/255.0f green:214/255.0f blue:202/255.0f alpha:1.0f];
    [self seatsTextField].enabled = NO;
    _seatsTextField.backgroundColor = [UIColor colorWithRed:216/255.0f green:214/255.0f blue:202/255.0f alpha:1.0f];
    [self statusTextField].enabled = NO;
    _statusTextField.backgroundColor = [UIColor colorWithRed:216/255.0f green:214/255.0f blue:202/255.0f alpha:1.0f];
    [self instructorTextField].enabled = NO;
    _instructorTextField.backgroundColor = [UIColor colorWithRed:216/255.0f green:214/255.0f blue:202/255.0f alpha:1.0f];
    
    if([luser.user.role isEqualToString:@"Faculty"]){
        [self instructorLabel].hidden = YES;
        [self instructorTextField].hidden = YES;
        _approveButton.hidden = YES;
    }else{
        
        if(![[selectedUserCourseObj objectForKey:@"status"] isEqualToString:@"Pending"]){
            _approveButton.enabled = NO;
            _approveButton.backgroundColor = [UIColor lightGrayColor];
        }
    }
    
    if([[selectedUserCourseObj objectForKey:@"status"] isEqualToString:@"Approved"] || [luser.user.role isEqualToString:@"Admin"]){
        // show for admins and faculties with approved course
        studentsEnrolledButton.hidden = NO;
    }else{
        studentsEnrolledButton.hidden = YES;
    }
    
    
    [self intializeTextFields:luser];
}

-(void) intializeTextFields:(LoggedUser*)luser{
    
    //populating status
    _statusTextField.text = [selectedUserCourseObj objectForKey:@"status"];
    
    // populating course fields
    PFObject *courseObj = [selectedUserCourseObj objectForKey:@"courseId"];
    if(![[courseObj allKeys] containsObject:@"name"]){
        //Fetch the user details sperately
        NSString *courseId = [courseObj valueForKey:@"objectId"];
        courseObj = [self fetchCourseFromUserCourse:courseId];
    }
    myCourseRequestCourseObj = courseObj;
    _nameTextField.text = [courseObj objectForKey:@"name"];
    // calculating available seats
    NSInteger seatsTaken = [self countSeatsTaken:courseObj];
    //NSString *capac = (NSString*)[courseObj objectForKey:@"capacity"];
    NSString *capac1 = [NSString stringWithFormat: @"%@",[courseObj objectForKey:@"capacity"]];
    //NSString *capacityString = [courseObj objectForKey:@"capacity"];
    _capacityTextField.text = capac1;
    NSInteger capacity = [capac1 integerValue];
    NSInteger avai = capacity - seatsTaken;
    NSString *avaiStr = [NSString stringWithFormat: @"%ld",avai];
    _seatsTextField.text = avaiStr;
    
    
    // populating user fields
    PFObject *userObj = [selectedUserCourseObj objectForKey:@"userId"];
    if(![[userObj allKeys] containsObject:@"first_name"]){
        if([luser.user.role isEqualToString:@"Admin"]){
            //fetch user details from selectedUserCourseObj
            //user data needed only in case of Admin user. To show value in instructor
            NSString *appUserId = [userObj valueForKey:@"objectId"];
            userObj = [self fetchAppUserFromUserCourse:appUserId];
        }
    }
    if([luser.user.role isEqualToString:@"Admin"]){
        // populate instructor fields
        NSString *full_name = [[userObj objectForKey:@"first_name" ] stringByAppendingString:[NSString stringWithFormat: @" %@", [userObj objectForKey:@"last_name"] ]];
        _instructorTextField.text = full_name;
    }
    
}

-(NSInteger) countSeatsTaken:(PFObject*) course{
    PFQuery *query = [PFQuery queryWithClassName:@"StudentCourses"];
    [query whereKey:@"courseId" equalTo:course];
    [query whereKey:@"status" equalTo:@"Approved"];
    NSArray *allStudentCourses = [query findObjects];
    return [allStudentCourses count];
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

- (IBAction)studentsEnrolledClicked:(id)sender {
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"EnrolledStudentsViewController"];
    ((EnrolledStudentsViewController*)vc).selectedCourse = myCourseRequestCourseObj;
    ((EnrolledStudentsViewController*)vc).selectedUserCourseObj = selectedUserCourseObj;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction)approveRequest:(id)sender {
    [selectedUserCourseObj setObject:@"Approved" forKey:@"status"];
    [selectedUserCourseObj save];
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Course Approval"
                                  message:@"Updated status successfully."
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
    
    
    // populating user fields
    PFObject *userObj = [selectedUserCourseObj objectForKey:@"userId"];
    if(![[userObj allKeys] containsObject:@"first_name"]){
        //user data needed only in case of Admin user. To show value in instructor
        NSString *appUserId = [userObj valueForKey:@"objectId"];
        userObj = [self fetchAppUserFromUserCourse:appUserId];
    }
    // sending approved email
    [self sendEmail:[userObj objectForKey:@"email"]];
    
    
    [self initializePage:[SessionData getLoggedUser]];
}


-(void) sendEmail:(NSString*) toemail{
    NSString * subject = @"Course request approved";
    NSString * body = @"Dear User, Your request for course xyz has been approved. Kindly log in to see details.";
    NSArray *recipients = [NSArray arrayWithObjects:toemail,nil];
    MFMailComposeViewController * composer = [[MFMailComposeViewController alloc] init];
    
    composer.mailComposeDelegate = self;
    [composer setSubject:subject];
    [composer setMessageBody:body isHTML:NO];
    [composer setToRecipients:recipients];
    
    MFMailComposeResultSent;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}


@end
