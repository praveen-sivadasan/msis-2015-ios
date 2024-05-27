//
//  AppDelegate.h
//  edConnect
//
//  Created by Praveen Sivadasan on 12/3/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <Parse/Parse.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

