//
//  SignUpController.m
//  edConnect
//
//  Created by Praveen Sivadasan on 12/11/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import "SignUpController.h"
#import "SessionData.h"

NSMutableArray *signUpRoles;

@interface SignUpController ()

@end

@implementation SignUpController

@synthesize fullNameLabel;
@synthesize  emailLabel;
@synthesize rolePickerView;
@synthesize phoneLabelTextField;

NSNumberFormatter *nf1;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadActivityIndicator];
    [self setNeedsStatusBarAppearanceUpdate];
    
    LoggedUser * luser = [SessionData getLoggedUser];
    signUpRoles = [[NSMutableArray alloc] init];
    
    nf1 = [[NSNumberFormatter alloc] init];
    
    [[self nameLabelText] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    [[self emailLabelText] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    [[self roleLabelText] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    
    [[self phoneWarning] setFont:[UIFont fontWithName:@"HelveticaNeue-Italic" size:12]];
    _phoneWarning.textAlignment = NSTextAlignmentRight;
    _phoneWarning.textColor = [UIColor redColor];
    
    self.view.layer.backgroundColor = [[UIColor colorWithRed:242/255.0f green:241/255.0f blue:236/255.0f alpha:1.0f] CGColor];

    
    _signUpNavBar.barTintColor = [UIColor colorWithRed:171/255.0f green:4/255.0f blue:30/255.0f alpha:1.0f];
    _signUpNavBar.tintColor = [UIColor whiteColor];
    _signUpNavBar.translucent = NO;
    _signUpNavBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    fullNameLabel.text = luser.fullName;
    emailLabel.text = luser.email;
    
    self.rolePickerView.delegate = self;
    self.rolePickerView.dataSource = self;
    self.rolePickerView.layer.backgroundColor = [[UIColor whiteColor] CGColor];
    
    for(NSString *role in [SessionData getRoleList]){
        if(![role  isEqual: @"Admin"]){
            [signUpRoles addObject:role];
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUpClicked:(id)sender {
    
    if([self validate]){
        LoggedUser * luser = [SessionData getLoggedUser];
        NSInteger *row = [rolePickerView selectedRowInComponent:0];
        NSString *selectedRole = [signUpRoles objectAtIndex:row];
        
        PFObject *userObj = [PFObject objectWithClassName:@"AppUser"];
        [userObj setObject:luser.email forKey:@"email"];
        [userObj setObject:selectedRole forKey:@"role"];
        [userObj setObject:luser.givenName forKey:@"first_name"];
        [userObj setObject:luser.familyName forKey:@"last_name"];
        [userObj setObject:[nf1 numberFromString:phoneLabelTextField.text] forKey:@"phone"];
        
        [userObj saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error){
            if(!error) {
                
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
                    luser.userObject = obj;
                }
                
                
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@""
                                              message:@"User added successfully."
                                              preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         //Navigate to home page view - view controller
                                         NSString * storyboardName = @"Main";
                                         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
                                         UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
                                         [self presentViewController:vc animated:YES completion:nil];
                                     }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
            else {
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@""
                                              message:@"Error occurred."
                                              preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:@"OK"
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         NSString * storyboardName = @"Main";
                                         UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
                                         UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"LoginController"];
                                         [self presentViewController:vc animated:YES completion:nil];
                                     }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
                
            }
        }];
        
    }
}

- (Boolean) validate{
    Boolean flag = true;
    
    if([phoneLabelTextField.text isEqualToString:@""] || [phoneLabelTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0){
        self.phoneWarning.text = @"Phone required.";
        flag = FALSE;
    }else if([nf1 numberFromString:phoneLabelTextField.text] == nil){
        self.phoneWarning.text = @"Phone is number.";
        flag = FALSE;
    }else if(phoneLabelTextField.text.length != 10 ){
        self.phoneWarning.text = @"Phone contains 10 digits.";
        flag = FALSE;
    }else if(phoneLabelTextField.text.length == 10 ){
        NSInteger value = [phoneLabelTextField.text integerValue];
        NSString *val = [NSString stringWithFormat:@"%ld",(long)value];
        if( val.length != 10 ){
            self.phoneWarning.text = @"Phone contains 10 digits.";
            flag =  FALSE;
        }else{
            self.phoneWarning.text = @"";
        }
    }else{
        self.phoneWarning.text = @"";
    }
    
    return flag;
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
    return [signUpRoles count];
}

// The data to return for the row and component (column) that's being passed in
- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return signUpRoles[row];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
}

@end
