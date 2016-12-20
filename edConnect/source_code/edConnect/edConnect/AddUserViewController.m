//
//  AddUserViewController.m
//  edConnect
//
//  Created by Praveen Sivadasan on 12/11/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import "AddUserViewController.h"
#import "SessionData.h"
#import "UserViewController.h"

@interface AddUserViewController ()

@end

@implementation AddUserViewController

@synthesize imagecontroller;
@synthesize userImageView;
UIImage *selectedUserImage;
NSNumberFormatter *nfUser;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadActivityIndicator];
    [self setNeedsStatusBarAppearanceUpdate];
    [self initializePage];
        
    LoggedUser *luser =[SessionData getLoggedUser];
    
    if(_selectedUser != nil){
        PFObject *obj = _selectedUser;
        _fnameTextField.text = [obj objectForKey:@"first_name"];
        _lnameTextField.text = [obj objectForKey:@"last_name"];
        _phoneTextField.text = [NSString stringWithFormat:@"%@",[obj objectForKey:@"phone"]];
        _roleTextField.text = [obj objectForKey:@"role"];
        _emailTextField.text = [obj objectForKey:@"email"];
        
        /* can only be edited from database*/
        _roleTextField.enabled = NO;
        _roleTextField.backgroundColor = [UIColor colorWithRed:216/255.0f green:214/255.0f blue:202/255.0f alpha:1.0f];
        _emailTextField.enabled = NO;

        /* processing image back*/
        NSData *imageFile = [[obj objectForKey:@"image"] getData];
        if(imageFile!=nil){
            UIImage *retreievedImage = [[UIImage alloc] initWithData:imageFile];
            [userImageView setImage:retreievedImage];
        }else{
            UIImage *retreievedImage = [UIImage imageNamed:@"user_default.png"];
            selectedUserImage = retreievedImage;
            [userImageView setImage:retreievedImage];
        }
        
        if(![luser.user.email isEqualToString:[obj objectForKey:@"email"]] && ![luser.user.role isEqualToString:@"Admin"]){
            _fnameTextField.enabled = NO;
            _lnameTextField.enabled = NO;
            _phoneTextField.enabled = NO;
            _updateButton.enabled = NO;
            self.updateButton.backgroundColor = [UIColor lightGrayColor];

            _imageSizeLabel.hidden = YES;
            _uploadButton.hidden = YES;
         
        }
        
    }
    
    [[self.view viewWithTag:12] stopAnimating];
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


- (void) initializePage{
    
    _profileNavBar.barTintColor = [UIColor colorWithRed:171/255.0f green:4/255.0f blue:30/255.0f alpha:1.0f];
    _profileNavBar.tintColor = [UIColor whiteColor];
    _profileNavBar.translucent = NO;
    _profileNavBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    self.view.layer.backgroundColor = [[UIColor colorWithRed:242/255.0f green:241/255.0f blue:236/255.0f alpha:1.0f] CGColor];
    
    nfUser = [[NSNumberFormatter alloc] init];
    
    /* imageSizeLabel */
    [[self imageSizeLabel] setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    _imageSizeLabel.textAlignment = NSTextAlignmentRight;
    
    [[self fnameWarningLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:12]];
    [[self lnameWarningLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:12]];
    [[self phoneWarningLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:12]];
    
    [[self fnameLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    [[self lnameLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    [[self phoneLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    [[self roleLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    [[self emailLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];

    
    self.fnameWarningLabel.textAlignment = NSTextAlignmentRight;
    self.lnameWarningLabel.textAlignment = NSTextAlignmentRight;
    self.phoneWarningLabel.textAlignment = NSTextAlignmentRight;
    
    self.fnameWarningLabel.textColor = [UIColor redColor];
    self.lnameWarningLabel.textColor = [UIColor redColor];
    self.phoneWarningLabel.textColor = [UIColor redColor];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/* Image picker view */
- (IBAction)getCourseImage:(id)sender {
    imagecontroller = [[UIImagePickerController alloc] init];
    imagecontroller.delegate = self;
    [self presentModalViewController:imagecontroller animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    selectedUserImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    userImageView.image=selectedUserImage;
    [self dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)updateButtonClicked:(id)sender {
    if([self validateUser]){
        NSNumberFormatter * nf = [[NSNumberFormatter alloc] init];
        
        /* processing image */
        PFFile *imageFile;
        UIImage *cimage = selectedUserImage;
        NSData *imageData = UIImagePNGRepresentation(cimage);
        if(selectedUserImage != nil)
            imageFile = [PFFile fileWithName:[_fnameTextField.text stringByAppendingString:@".png"] data:imageData];
        
        PFObject *userObj = _selectedUser;
        [userObj setObject:_fnameTextField.text forKey:@"first_name"];
        [userObj setObject:_lnameTextField.text forKey:@"last_name"];
        [userObj setObject:[nfUser numberFromString:_phoneTextField.text ] forKey:@"phone"];
        if(selectedUserImage != nil)
            [userObj setObject:imageFile forKey:@"image"];
        [userObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error){
            
            if(!error) {
                LoggedUser * luser = [SessionData getLoggedUser];
                
                if([luser.email isEqualToString:[_selectedUser objectForKey:@"email"]]){
                    NSArray * users;
                    PFQuery *query = [PFQuery queryWithClassName:@"AppUser"];
                    [query whereKey:@"email" equalTo:luser.email];
                    //[query selectKeys:@[@"objectId",@"email",@"role"]];
                    users = [query findObjects];
                    
                    if([users count] != 0){
                        PFObject *obj = [users objectAtIndex:0];
                        luser.user.email = [obj objectForKey:@"email"];
                        luser.user.userId = [obj valueForKey:@"objectId"];
                        luser.user.role =[obj objectForKey:@"role"];
                        luser.user.first_name = luser.givenName;
                        luser.user.last_name = luser.familyName;
                        luser.user.phone = [obj objectForKey:@"phone"];
                        
                        /* processing image back*/
                        NSData *imageFile = [[obj objectForKey:@"image"] getData];
                        UIImage *retreievedImage = [[UIImage alloc] initWithData:imageFile];
                        luser.user.userImage = retreievedImage;
                    }
                    
                }
                
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@""
                                              message:@"Updated successfully."
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
                
            }else{
                NSLog(@"Error db");
            }
        }];
    }
}

- (Boolean) validateUser{
    Boolean flag = true;
    
    if([_fnameTextField.text isEqualToString:@""] || [_fnameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0){
        self.fnameWarningLabel.text = @"First name required.";
        flag =  FALSE;
    }else{
        self.fnameWarningLabel.text = @"";
    }
        
    if([_lnameTextField.text isEqualToString:@""] || [_lnameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0){
        self.lnameWarningLabel.text = @"Last name required.";
        flag =  FALSE;
    }else{
        self.lnameWarningLabel.text = @"";
    }
    
    if([_phoneTextField.text isEqualToString:@""] || [_phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0){
        self.phoneWarningLabel.text = @"Phone required.";
        flag =  FALSE;
    }else if([nfUser numberFromString:_phoneTextField.text] == nil){
        self.phoneWarningLabel.text = @"Phone is number.";
        flag =  FALSE;
    }else if(_phoneTextField.text.length != 10 ){
        self.phoneWarningLabel.text = @"Phone contains 10 digits.";
        flag =  FALSE;
    }else if(_phoneTextField.text.length == 10 ){
        NSInteger value = [_phoneTextField.text integerValue];
        NSString *val = [NSString stringWithFormat:@"%ld",(long)value];
        if( val.length != 10 ){
            self.phoneWarningLabel.text = @"Phone contains 10 digits.";
            flag =  FALSE;
        }else{
            self.phoneWarningLabel.text = @"";
        }
    }else{
        self.phoneWarningLabel.text = @"";
    }
    
    return flag;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    UINavigationController *nav = [segue destinationViewController];
    UserViewController *vc = (UserViewController *)([nav viewControllers][0]);
    
    if([[_selectedUser objectForKey:@"role"] isEqualToString:@"Student"]){
        vc.showStudents = true ;
    }else if([[_selectedUser objectForKey:@"role"] isEqualToString:@"Faculty"]){
        vc.showStudents = false ;
    }
}

@end
