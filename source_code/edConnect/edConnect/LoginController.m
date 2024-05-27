//
//  LoginController.m
//  edConnect
//
//  Created by Praveen Sivadasan on 12/4/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//
#import "LoginController.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import "SessionData.h"
#import <Buglife/Buglife.h>

@interface LoginController ()
@end

@implementation LoginController

@synthesize signInButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [GIDSignIn sharedInstance].uiDelegate = self;
    [GIDSignIn sharedInstance ].signOut;
    
    [self initializePage];
    [self setNeedsStatusBarAppearanceUpdate];

    // report bugs initialization
    [[Buglife sharedBuglife] startWithEmail:@"sivadasan.praveen@gmail.com"];
}

-(void) initializePage{
    UIImage *img = [UIImage imageNamed:@"login.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:img];
    [self.view addSubview:imageView ];
    [self.view sendSubviewToBack:imageView ];
    
    
    [[self appName] setFont:[UIFont fontWithName:@"Copperplate-Bold" size:25]];
    _loginButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    
    
    _navBar.barTintColor = [UIColor colorWithRed:171/255.0f green:4/255.0f blue:30/255.0f alpha:1.0f];
    _navBar.tintColor = [UIColor whiteColor];
    
    UIImage *retreievedImage = [UIImage imageNamed:@"gicon.png"];
    _googleIconView.image = retreievedImage;
    
    //_navBar.translucent = NO;
    //_navBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    //_loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    //UIImage *img1 = [UIImage imageNamed:@"google-login.png"];
    //_loginButton setty
    //[_loginButton setImage:img1 forState:UIControlStateNormal];
    
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/* Sign in */
// Stop the UIActivityIndicatorView animation that was started when the user
// pressed the Sign In button
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    // [myActivityIndicator stopAnimating];
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn
presentViewController:(UIViewController *)viewController {
    [self presentViewController:viewController animated:YES completion:nil];
}

// Dismiss the "Sign in with Google" view after successful login
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    
    /* dismiss google page */
    [self dismissViewControllerAnimated:YES completion:nil];
    
    /* Initialize static values in session */
    [SessionData setOperationValues];
    
    /* navigate to view controller without secondary authentication*/
    [self navigateToHomePage];
    
    /* navigate with secondary authentication*/
    //[self edConnectUserAuthentication];
    
}

- (void) navigateToHomePage{
    //Navigate to another view
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;//UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:nil];

}

//- (void) edConnectUserAuthentication{
//    /* fetch user details */
//    LoggedUser *luser = [SessionData getLoggedUser];
//    if(luser.email == nil){
//        UIAlertController * alert=   [UIAlertController
//                                      alertControllerWithTitle:@"EdConnect"
//                                      message:@"Re-enter email address"
//                                      preferredStyle:UIAlertControllerStyleAlert];
//        
//        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault
//                                                   handler:^(UIAlertAction * action) {
//                                                       UITextField *alertTextField = alert.textFields[0];
//                                                       NSString *uemail  = alertTextField.text;
//                                                       
//                                                       if([uemail isEqualToString:@""] || ([uemail stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]].length == 0) ){
//                                                           
//                                                           alertTextField.layer.borderColor = [[UIColor redColor] CGColor];
//                                                           alertTextField.layer.borderWidth = 1.0f;
//                                                           
//                                                           [self presentViewController:alert animated:YES completion:nil];
//                                                       }else{User *u = [self fetchUser:uemail];
//                                                           
//                                                           if(u == nil){
//                                                               /* pop up to signup */
//                                                               UIAlertController * alert1=   [UIAlertController
//                                                                                              alertControllerWithTitle:@"EdConnect"
//                                                                                              message:@"User sign-up"
//                                                                                              preferredStyle:UIAlertControllerStyleAlert];
//                                                               UIAlertAction* ok1 = [UIAlertAction actionWithTitle:@"Submit" style:UIAlertActionStyleDefault
//                                                                                                           handler:^(UIAlertAction * action) {
//                                                                                                               if((alert1.textFields[4]).text.lowercaseString == (@"Faculty").lowercaseString ||
//                                                                                                                  (alert1.textFields[4]).text.lowercaseString == (@"Student").lowercaseString){
//                                                                                                                   /* insert first*/
//                                                                                                                   PFObject *newUser = [PFObject objectWithClassName:@"User"];
//                                                                                                                   [newUser setObject:(alert1.textFields[0]).text forKey:@"first_name"];
//                                                                                                                   [newUser setObject:(alert1.textFields[1]).text forKey:@"last_name"];
//                                                                                                                   [newUser setObject:(alert1.textFields[2]).text forKey:@"username"];
//                                                                                                                   [newUser setObject:(alert1.textFields[3]).text forKey:@"password"];
//                                                                                                                   [newUser setObject:uemail forKey:@"email"];
//                                                                                                                   [newUser setObject:(alert1.textFields[4]).text forKey:@"role"];
//                                                                                                                   
//                                                                                                                   [newUser saveInBackground];
//                                                                                                                   
//                                                                                                                   User *u = [self fetchUser:uemail];
//                                                                                                                   [SessionData getLoggedUser].user = u;
//                                                                                                                   [SessionData getLoggedUser].userObject = newUser;
//                                                                                                                   
//                                                                                                                   [self navigateToHomePage];
//                                                                                                               }else{
//                                                                                                                   alert1.textFields[4].layer.borderColor = [[UIColor redColor] CGColor];
//                                                                                                                   alert1.textFields[4].layer.borderWidth = 2.0f;
//                                                                                                               }
//                                                                                                               
//                                                                                                           }];
//                                                               [alert1 addAction:ok1];
//                                                               
//                                                               UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
//                                                                                                                                           handler:^(UIAlertAction * action) {
//                                                                                                                                                   [alert1 dismissViewControllerAnimated:YES completion:nil];
//                                                                                            
//                                                                                            [GIDSignIn sharedInstance ].signOut;
//                                                                                            
//                                                                                            //Navigate to another view
//                                                                                            NSString * storyboardName = @"Main";
//                                                                                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
//                                                                                            UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"LoginController"];
//                                                                                            [self presentViewController:vc animated:YES completion:nil];
//                                                                                            
//                                                                                        }];
//                                                               
//                                                               [alert1 addAction:cancel];
//                                                               
//                                                               [alert1 addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//                                                                   textField.placeholder = @"First Name*";
//                                                               }];
//                                                               [alert1 addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//                                                                   textField.placeholder = @"Last Name*";
//                                                               }];
//                                                               [alert1 addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//                                                                   textField.placeholder = @"User Name*";
//                                                               }];
//                                                               [alert1 addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//                                                                   textField.placeholder = @"Password";
//                                                               }];
//                                                               [alert1 addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//                                                                   textField.placeholder = @"Role(Faculty/Student)";
//                                                               }];
//                                                               
//                                                               [self presentViewController:alert1 animated:YES completion:nil];
//                                                           }else{
//                                                               
//                                                               //Navigate to another view
//                                                               [SessionData getLoggedUser].user = u;
//                                                               [SessionData getLoggedUser].userObject = newUser;
//                                                               
//                                                               NSString * storyboardName = @"Main";
//                                                               UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
//                                                               UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
//                                                               [self presentViewController:vc animated:YES completion:nil];
//                                                           }
//                                                           
//                                                           
//                                                       }
//                                                       
//                                                   }];
//        
//        UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault
//                                                                                    handler:^(UIAlertAction * action) {
//                                                                                            [alert dismissViewControllerAnimated:YES completion:nil];
//                                     
//                                     [GIDSignIn sharedInstance ].signOut;
//                                     
//                                     //Navigate to another view
//                                     NSString * storyboardName = @"Main";
//                                     UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
//                                     UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"LoginController"];
//                                     [self presentViewController:vc animated:YES completion:nil];
//                                     
//                                 }];
//        
//        [alert addAction:ok];
//        [alert addAction:cancel];
//        [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
//            textField.placeholder = @"Username";
//        }];
//        [self presentViewController:alert animated:YES completion:nil];
//    }
//}

//- (User*) populateUser:(User*) u pfObj:(PFObject*) obj{
//    u = [[User alloc] init];
//    //u.fName = [obj  valueForKey:@"first_name"];
//    //u.lName = [obj  valueForKey:@"last_name"];
//    u.email = [obj  valueForKey:@"email"];
//   // u.pwd = [obj  valueForKey:@"password"];
//    //u.uName = [obj  valueForKey:@"username"];
//    u.userId = [obj valueForKey:@"objectId"];
//    u.role = [obj valueForKey:@"role"];
//    return u;
//}

//- (User*) fetchUser:(NSString*) uemail{
//    PFQuery *query = [PFQuery queryWithClassName:@"User"];
//    [query selectKeys:@[@"objectId",@"username",@"password",@"email",@"first_name",@"last_name",@"role"]];
//    [query whereKey:@"email" equalTo:uemail];
//    NSArray * users = [query findObjects];
//    User *u ;
//    if(users != nil){
//        for(PFObject * obj in users){
//            u = [self populateUser:u pfObj:obj];
//            break;
//        }
//    }
//    
//    return u;
//}

- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error{
    NSString *userId = user.userID;
}

- (IBAction)logInUser:(id)sender {
    [GIDSignIn sharedInstance ].signIn;
    [[GIDSignIn sharedInstance] signInSilently];
}

@end
