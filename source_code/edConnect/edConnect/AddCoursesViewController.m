//
//  AddCoursesViewController.m
//  edConnect
//
//  Created by Praveen Sivadasan on 12/5/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import "AddCoursesViewController.h"
#import "SessionData.h"
#import "CoursesViewController.h"

@interface AddCoursesViewController (){
    int direction;
    int shakes;
}
@end

@implementation AddCoursesViewController

@synthesize imagecontroller;
@synthesize courseImage;
@synthesize startDatePicker;
@synthesize termPickerView;

@synthesize courseName;
@synthesize instructorName;
@synthesize capacityNumber;

@synthesize courseWarning;
@synthesize termWarning;
@synthesize instructorWarning;
@synthesize capacityWarning;

NSNumberFormatter *nf;
NSDateFormatter *dateFormatter;
UIImage *selectedImage;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadActivityIndicator];
    [self setNeedsStatusBarAppearanceUpdate];
    LoggedUser *luser =[SessionData getLoggedUser];
    
    [self initializePage:luser];
    if(_selectedCourse != nil){
        PFObject *courseRequestObj = _selectedCourse;
        courseName.text = [courseRequestObj objectForKey:@"name"];
        capacityNumber.text = [NSString stringWithFormat:@"%@",[courseRequestObj objectForKey:@"capacity"]];
        [startDatePicker setDate:[courseRequestObj objectForKey:@"start_date"]];
        
        // Fetch the instructor name if course is approved for a faculty
        PFObject *instructor = [self fetchInstructor];
        if(instructor != nil){
            PFObject *instUserObj = [instructor objectForKey:@"userId"];
            if(![[instUserObj allKeys] containsObject:@"first_name"]){
                //Fetch the user details sperately
                NSString *appUserId = [instUserObj valueForKey:@"objectId"];
                instUserObj = [self fetchAppUser:appUserId];
            }
            NSString *full_name = [[instUserObj objectForKey:@"first_name"] stringByAppendingString:[NSString stringWithFormat: @" %@", [instUserObj objectForKey:@"last_name"]]];
            instructorName.text = full_name;
            
            //            NSLog(@"%@",[instructor objectForKey:@"userId"]);
            //            NSLog(@"%@",[instructor objectForKey:@"courseId"]);
            //            NSLog(@"%@",[instructor objectForKey:@"status"]);
            //
            
            //            PFObject *instructorUser = [instructor objectForKey:@"userId"];
            //            /********************************/
            //            if(instructorUser != nil && [instructorUser objectForKey:@"first_name"] != nil && [instructorUser objectForKey:@"last_name"] != nil ){//TODO weirdd isssue sometimes no user coming
            //                NSString *full_name = [[instructorUser objectForKey:@"first_name"] stringByAppendingString:[NSString stringWithFormat: @" %@", [instructorUser objectForKey:@"last_name"]]];
            //                instructorName.text = full_name;
            //            }
        }
        
        /* processing image back*/
        NSData *imageFile = [[courseRequestObj objectForKey:@"image"] getData];
        UIImage *retreievedImage = [[UIImage alloc] initWithData:imageFile];
        [courseImage setImage:retreievedImage];
        [_submitButton setTitle:@"Update" forState:UIDocumentStateNormal];
        [_pageHeaderField setTitle:@"Course"];
        
        if([luser.user.role isEqualToString:@"Admin"]){
        }else if([luser.user.role isEqualToString:@"Student"]){
            [self notAdminChanges];
            [self studentUserChanges:luser];
        }else if([luser.user.role isEqualToString:@"Faculty"]){
            [self notAdminChanges];
            [self facultyUserChanges:luser];
        }
        
    }else{
        [_submitButton setTitle:@"Add" forState:UIDocumentStateNormal];
        [_pageHeaderField setTitle:@"Course"];
    }
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

- (PFObject*) fetchInstructor{
    
    PFQuery *query = [PFQuery queryWithClassName:@"FacultyCourses"];
    [query whereKey:@"courseId" equalTo:_selectedCourse];
    [query whereKey:@"status" equalTo:@"Approved"];
    
    NSArray *instructors = [query findObjects];
    if([instructors count] != 0){
        return [instructors objectAtIndex:0];
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

- (void) initializePage:(LoggedUser*) luser{
    
    _courseNavBar.barTintColor = [UIColor colorWithRed:171/255.0f green:4/255.0f blue:30/255.0f alpha:1.0f];
    _courseNavBar.tintColor = [UIColor whiteColor];
    _courseNavBar.translucent = NO;
    _courseNavBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    self.view.layer.backgroundColor = [[UIColor colorWithRed:242/255.0f green:241/255.0f blue:236/255.0f alpha:1.0f] CGColor];
    
    
    /* initializaing formatter */
    nf = [[NSNumberFormatter alloc] init];
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm-dd-yyyy"];
    
    /* imageSizeLabel */
    [[self imageSizeLabel] setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    _imageSizeLabel.textAlignment = NSTextAlignmentRight;
    
    
    /* field label styling*/
    [[self courseLabelText] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    [[self termLabelText] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    [[self instructorLabelText] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    [[self capacityLabelText] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    [[self startDateLabelText] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    
    
    /* warning initialization*/
    [[self courseWarning] setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:12]];
    [[self termWarning] setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:12]];
    [[self instructorWarning] setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:12]];
    [[self capacityWarning] setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:12]];
    
    courseWarning.textAlignment = NSTextAlignmentRight;
    termWarning.textAlignment = NSTextAlignmentRight;
    capacityWarning.textAlignment = NSTextAlignmentRight;
    
    courseWarning.textColor = [UIColor redColor];
    termWarning.textColor = [UIColor redColor];
    capacityWarning.textColor = [UIColor redColor];
    
    /* Rotater Picker view data source */
    self.termPickerView.delegate = self;
    self.termPickerView.dataSource = self;
    
    [self instructorName].enabled = NO;
    instructorName.backgroundColor = [UIColor colorWithRed:216/255.0f green:214/255.0f blue:202/255.0f alpha:1.0f];
    
    
    if(![luser.user.role isEqualToString:@"Admin"] || _selectedCourse==nil){
        // not adming or not update page
        [self deleteButton].enabled = NO;
    }
}


-(void) notAdminChanges{
    [_submitButton setTitle:@"Register" forState:UIDocumentStateNormal];
    
    [self courseName].enabled = NO;
    courseName.backgroundColor = [UIColor colorWithRed:216/255.0f green:214/255.0f blue:202/255.0f alpha:1.0f];
    [self capacityNumber].enabled = NO;
    capacityNumber.backgroundColor = [UIColor colorWithRed:216/255.0f green:214/255.0f blue:202/255.0f alpha:1.0f];
    [self termPickerView].userInteractionEnabled = NO;
    [self startDatePicker].userInteractionEnabled = NO;
    
    _uploadButton.hidden = YES;
    _imageSizeLabel.hidden = YES;
    
}


-(void) studentUserChanges:(LoggedUser*)luser{
    
    NSArray * sCourses;
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"StudentCourses"];
    [query1 whereKey:@"userId" equalTo:luser.userObject];
    [query1 whereKey:@"courseId" equalTo:_selectedCourse];
    
    sCourses = [query1 findObjects];
    if([sCourses count] != 0){
        _courseRequest = [sCourses objectAtIndex:0];
        [_submitButton setTitle:[@"Status : " stringByAppendingString:[_courseRequest objectForKey:@"status"]] forState:UIDocumentStateNormal];
        _submitButton.enabled = NO;
        _submitButton.backgroundColor = [UIColor lightGrayColor];
    }
    
}


-(void) facultyUserChanges:(LoggedUser*)luser{
    NSArray * sCourses, *otherFacultyCourses;
    
    //Faculty cant register for a course if some other professor has registered.
    
    PFQuery *query1 = [PFQuery queryWithClassName:@"FacultyCourses"];
    [query1 whereKey:@"userId" equalTo:luser.userObject];
    [query1 whereKey:@"courseId" equalTo:_selectedCourse];
    [query1 whereKey:@"status" notEqualTo:[SessionData getReqRej]];
    
    // to check if some other faculty got this course
    PFQuery *query2 = [PFQuery queryWithClassName:@"FacultyCourses"];
    [query2 whereKey:@"courseId" equalTo:_selectedCourse];
    [query2 whereKey:@"status" notEqualTo:[SessionData getReqRej]];
    
    sCourses = [query1 findObjects];
    otherFacultyCourses = [query2 findObjects];// to prevent registering when other faculty registered to a class
    
    if([sCourses count] != 0){
        _courseRequest = [sCourses objectAtIndex:0];
        [_submitButton setTitle:[@"Status : " stringByAppendingString:[_courseRequest objectForKey:@"status"]] forState:UIDocumentStateNormal];
        _submitButton.enabled = NO;
        _submitButton.backgroundColor = [UIColor lightGrayColor];
    }else if([otherFacultyCourses count] != 0){
        _courseRequest = [otherFacultyCourses objectAtIndex:0];
        [_submitButton setTitle:@"Unavailabe" forState:UIDocumentStateNormal];
        _submitButton.enabled = NO;
        _submitButton.backgroundColor = [UIColor lightGrayColor];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/* Image picker view */
- (IBAction)getCourseImage:(id)sender {
    imagecontroller = [[UIImagePickerController alloc] init];
    imagecontroller.delegate = self;
    [self presentModalViewController:imagecontroller animated:YES];
}

- (IBAction)deleteButtonClicked:(id)sender {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Delete"
                                  message:@"Are you sure you want to delete the course. All related requests will be removed?"
                                  preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yes = [UIAlertAction
                          actionWithTitle:@"Yes"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              PFQuery *query = [PFQuery queryWithClassName:@"StudentCourses"];
                              [query whereKey:@"courseId" equalTo:_selectedCourse];
                              [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                  if (!error) {
                                      for (PFObject *object in objects) {
                                          [object delete];
                                          NSLog(@"Deleted from studentcourses table");
                                      }
                                  } else {
                                      NSLog(@"Error db : Deleted from studentcourses table");
                                  }
                              }];
                              
                              PFQuery *queryFC = [PFQuery queryWithClassName:@"FacultyCourses"];
                              [queryFC whereKey:@"courseId" equalTo:_selectedCourse];
                              [queryFC findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                  if (!error) {
                                      for (PFObject *object in objects) {
                                          [object delete];
                                          NSLog(@"Deleted from facultycourses table");
                                      }
                                  } else {
                                      NSLog(@"Error db : Deleted from facultycourses table");
                                  }
                              }];
                              
                              
                              [_selectedCourse delete];
                              
                              [alert dismissViewControllerAnimated:YES completion:nil];
                              UIAlertController * alert1=   [UIAlertController
                                                             alertControllerWithTitle:@"Delete"
                                                             message:@"Deleted successfully"
                                                             preferredStyle:UIAlertControllerStyleAlert];
                              UIAlertAction* ok1 = [UIAlertAction
                                                    actionWithTitle:@"OK"
                                                    style:UIAlertActionStyleDefault
                                                    handler:^(UIAlertAction * action)
                                                    {
                                                        [alert dismissViewControllerAnimated:YES completion:nil];
                                                        
                                                        /* navigate back*/
                                                        NSString * storyboardName = @"Main";
                                                        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
                                                        UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"CoursesViewController"];
                                                        CoursesViewController *acvc = (CoursesViewController*)vc   ;
                                                        [self presentViewController:vc animated:YES completion:nil];
                                                    }];
                              [alert1 addAction:ok1];
                              [self presentViewController:alert1 animated:YES completion:nil];
                          }];
    UIAlertAction* no = [UIAlertAction
                         actionWithTitle:@"No"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    [alert addAction:yes];
    [alert addAction:no];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    selectedImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    courseImage.image=selectedImage;
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissModalViewControllerAnimated:YES];
}


/* UIPicker view component setup */
// The number of columns of data
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// The number of rows of data
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [[SessionData getTermList] count];
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *termList = [SessionData getTermList];
    return termList[row];
}

- (IBAction)addCourses:(id)sender {
    LoggedUser *luser =[SessionData getLoggedUser];
    
    if([luser.user.role isEqualToString:@"Student"] || [luser.user.role isEqualToString:@"Faculty"]){
        // cretae an entry in facultycourses or studentcourses
        //Registering user to the course
        Boolean flag = true;
        
        if([luser.user.role isEqualToString:@"Student"]){
            flag = [self validateSeats:luser];
        }
        
        if(flag){
            PFObject *myCourseObject ;
            if([luser.user.role isEqualToString:@"Student"]){
                myCourseObject = [PFObject objectWithClassName:@"StudentCourses"];
            }else{
                myCourseObject = [PFObject objectWithClassName:@"FacultyCourses"];
            }
            [myCourseObject setObject:[SessionData getReqPen] forKey:@"status"];
            [myCourseObject setObject:_selectedCourse forKey:@"courseId"];
            NSLog(@"%@",luser.userObject);
            [myCourseObject setObject:luser.userObject forKey:@"userId"];
            
            [myCourseObject save];
            
            [_submitButton setTitle:@"Status : Pending" forState:UIDocumentStateNormal];
            _submitButton.enabled = NO;
            _submitButton.backgroundColor = [UIColor lightGrayColor];
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@"Course"
                                          message:@"Registered successfully"
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
    }else{
        if([self validateAddCourses]){
            NSString *cname = courseName.text;
            
            NSInteger *row = [termPickerView selectedRowInComponent:0];
            NSString *term = [[SessionData getTermList] objectAtIndex:row];
            
            NSString *instructor = instructorName.text;
            NSNumber *capacityNum = [nf numberFromString:capacityNumber.text ];
            NSInteger *capacity = [capacityNum integerValue];
            
            NSDate *startDate = [startDatePicker date];
            
            /* processing image */
            UIImage *cimage = selectedImage;
            if(selectedImage == nil){
                cimage = [UIImage imageNamed:@"book_default.png"];
            }
            NSData *imageData = UIImagePNGRepresentation(cimage);
            NSString *fileName = [cname stringByAppendingString:[dateFormatter stringFromDate:startDate]];
            PFFile *imageFile ;
            if(_selectedCourse != nil){
                imageFile = [_selectedCourse objectForKey:@"image"];
            }else{
                imageFile = [PFFile fileWithName:[fileName stringByAppendingString:@".png"] data:imageData];
            }
            
            
            NSString *message = @"Added successfully.";
            PFObject *course ;
            
            if(_selectedCourse != nil){
                course = _selectedCourse;
            }else{
                course = [PFObject objectWithClassName:@"Courses"];
            }
            [course setObject:cname forKey:@"name"];
            [course setObject:term forKey:@"term"];
            [course setObject:capacityNum forKey:@"capacity"];
            [course setObject:startDate forKey:@"start_date"];
            [course setObject:imageFile forKey:@"image"];
            //            [course saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error){
            //                if(!error) {
            //
            //                    if(_selectedCourse != nil){
            //                        NSLog(@"Updated");
            //                    }else{
            //                        NSLog(@"Added");
            //                    }
            //
            //                }
            //                else {
            //                    NSLog(@"Error db");
            //                }
            //            }];
            [course save];
            if(_selectedCourse != nil){
                message = @"Updated succesfully.";
            }else{
                [self resetData];
            }
            [[self.view viewWithTag:12] stopAnimating];
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:@""
                                          message:message
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
    [[self.view viewWithTag:12] stopAnimating];
    
}

- (Boolean) validateSeats:(LoggedUser*)luser{
    
    NSString *capac1 = [NSString stringWithFormat: @"%@",[_selectedCourse objectForKey:@"capacity"]];
    NSInteger value = [capac1 integerValue];
    
    NSInteger seatsTaken = [[self totalCoursesTaken:luser] count];
    
    NSInteger seatsLeft = value - seatsTaken;
    
    if(seatsLeft > 0 ){
        return true;
    }
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Register course"
                                  message:@"No seats left in this course."
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


-(NSArray*) totalCoursesTaken : (LoggedUser*) luser{
    PFQuery *query = [PFQuery queryWithClassName:@"StudentCourses"];
    [query whereKey:@"userId" equalTo:luser.userObject];
    [query whereKey:@"status" equalTo:@"Approved"];
    return [query findObjects];
}

- (void) resetData{
    courseName.text = @"";
    instructorName.text = @"";
    capacityNumber.text = @"";
    [termPickerView selectRow:0 inComponent:0 animated:YES];
    [startDatePicker setDate:[NSDate date]];
    courseImage.image = nil;
}

- (Boolean) validateAddCourses{
    Boolean flag = true;
    
    if([courseName.text isEqualToString:@""] || [courseName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0){
        courseWarning.text = @"Name required.";
        courseName.layer.borderColor = [[UIColor redColor] CGColor];
        courseName.layer.borderWidth = 2.0f;
        direction = 1;
        shakes = 0;
        [self shake:courseName];
        flag = false;
    }else{
        courseWarning.text = @"";
    }
        
    if([capacityNumber.text isEqualToString:@""] || [capacityNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0){
        capacityWarning.text = @"Capacity required.";
        capacityNumber.layer.borderColor = [[UIColor redColor] CGColor];
        capacityNumber.layer.borderWidth = 2.0f;
        direction = 1;
        shakes = 0;
        [self shake:capacityNumber];
        flag = false;
    }else {
        capacityWarning.text = @"";
    }
    
    if([nf numberFromString:capacityNumber.text] == nil){
        capacityWarning.text = @"Capacity is number.";
        capacityNumber.layer.borderColor = [[UIColor redColor] CGColor];
        capacityNumber.layer.borderWidth = 2.0f;
        direction = 1;
        shakes = 0;
        [self shake:capacityNumber];
        flag = false;
    }else{
        capacityWarning.text = @"";
    }
    
    
    if(selectedImage != nil){
        NSData *imageData = UIImagePNGRepresentation(selectedImage);
        if([imageData length] > 1000000){
            courseImage.layer.borderColor = [[UIColor redColor] CGColor];
            courseImage.layer.borderWidth = 2.0f;
            direction = 1;
            shakes = 0;
            [self shake:courseImage];
            flag = false;
        }
    }
    
    return flag;
}

-(void)shake:(UIView *)theOneYouWannaShake{
    
    [UIView animateWithDuration:0.03 animations:^
     {
         theOneYouWannaShake.transform = CGAffineTransformMakeTranslation(5*direction, 0);
     }
                     completion:^(BOOL finished)
     {
         if(shakes >= 10)
         {
             theOneYouWannaShake.transform = CGAffineTransformIdentity;
             return;
         }
         shakes++;
         direction = direction * -1;
         [self shake:theOneYouWannaShake];
     }];
}

/* #pragma mark - Navigation*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // UIViewController *vc = [segue destinationViewController];
    // vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;//UIModalTransitionStyleFlipHorizontal;
    
}


@end
