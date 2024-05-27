//
//  LoginController.h
//  edConnect
//
//  Created by Praveen Sivadasan on 12/4/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <Parse/Parse.h>

@interface LoginController : UIViewController<GIDSignInDelegate>

/* Buttons */
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property(weak, nonatomic) IBOutlet GIDSignInButton *signInButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UILabel *appName;
@property (weak, nonatomic) IBOutlet UIImageView *googleIconView;


- (IBAction)logInUser:(id)sender;
@end
