//
//  StudentCourseInfoController.m
//  edConnect
//
//  Created by Praveen Sivadasan on 12/13/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import "StudentCourseInfoController.h"
#import "SessionData.h"

@interface StudentCourseInfoController ()

@end

@implementation StudentCourseInfoController

@synthesize studentCourseObj;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadActivityIndicator];
    LoggedUser *luser =[SessionData getLoggedUser];
    [self initializePage:luser];
    [[self.view viewWithTag:12] stopAnimating];
}

-(void) initializePage:(LoggedUser*) luser{
    
    [self nameTextField].enabled = NO;
    [self nameTextField].backgroundColor = [UIColor colorWithRed:216/255.0f green:214/255.0f blue:202/255.0f alpha:1.0f];
    [self totalCapacityTextField].enabled = NO;
    [self totalCapacityTextField].backgroundColor = [UIColor colorWithRed:216/255.0f green:214/255.0f blue:202/255.0f alpha:1.0f];
    [self seatsAvaiTextField].enabled = NO;
    [self seatsAvaiTextField].backgroundColor = [UIColor colorWithRed:216/255.0f green:214/255.0f blue:202/255.0f alpha:1.0f];
    [self instructorTextField].enabled = NO;
    [self instructorTextField].backgroundColor = [UIColor colorWithRed:216/255.0f green:214/255.0f blue:202/255.0f alpha:1.0f];
    [self statusTextField].enabled = NO;
    [self statusTextField].backgroundColor = [UIColor colorWithRed:216/255.0f green:214/255.0f blue:202/255.0f alpha:1.0f];
    [self gradesTextField].enabled = NO;
    [self gradesTextField].backgroundColor = [UIColor colorWithRed:216/255.0f green:214/255.0f blue:202/255.0f alpha:1.0f];
    
    if(studentCourseObj != nil){
        PFObject *course = [studentCourseObj objectForKey:@"courseId"];
        _nameTextField.text = [course objectForKey:@"name"];
        _totalCapacityTextField.text = [NSString stringWithFormat:@"%@",[course objectForKey:@"capacity"]];
        
        //fetching instructor name for course
        PFObject *facultyCourseObj = [self fetchFacultyCourse];
        PFObject *facultyUserObj;
        if(facultyCourseObj != nil){
            facultyUserObj = [facultyCourseObj objectForKey:@"userId"];
            if(![[facultyUserObj allKeys] containsObject:@"first_name"]){
                //Fetch the user details sperately
                NSString *appUserId = [facultyUserObj valueForKey:@"objectId"];
                facultyUserObj = [self fetchAppUser:appUserId];
            }
            NSString *full_name = [[facultyUserObj objectForKey:@"first_name"] stringByAppendingString:[NSString stringWithFormat: @" %@", [facultyUserObj objectForKey:@"last_name"]]];
            _instructorTextField.text = full_name;
        }
        
        // calculating available seats
        NSInteger seatsTaken = [self countSeatsTaken:course];
        NSString *capacityString = [course objectForKey:@"capacity"];
        NSInteger capacity = [capacityString integerValue];
        NSInteger avai = capacity - seatsTaken;
        NSString *avaiStr = [NSString stringWithFormat: @"%ld",avai];
        _seatsAvaiTextField.text = avaiStr;
        
        _statusTextField.text = [studentCourseObj objectForKey:@"status"];
        if([studentCourseObj objectForKey:@"grade"] != nil)
            _gradesTextField.text = [NSString stringWithFormat:@"%@",[studentCourseObj objectForKey:@"grade"]];
    }
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

-(PFObject*) fetchFacultyCourse{
    PFQuery *query = [PFQuery queryWithClassName:@"FacultyCourses"];
    [query whereKey:@"courseId" equalTo:[studentCourseObj objectForKey:@"courseId"]];
    [query whereKey:@"status" equalTo:@"Approved"];
    NSArray *facultyCourses = [query findObjects];
    if([facultyCourses count] != 0){
        return facultyCourses[0];
    }
    return nil;
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

-(NSInteger) countSeatsTaken:(PFObject*) course{
    PFQuery *query = [PFQuery queryWithClassName:@"StudentCourses"];
    [query whereKey:@"courseId" equalTo:course];
    [query whereKey:@"status" equalTo:@"Approved"];
    NSArray *allStudentCourses = [query findObjects];
    return [allStudentCourses count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}

@end
