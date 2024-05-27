//
//  AppDelegate.m
//  edConnect
//
//  Created by Praveen Sivadasan on 12/3/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import "AppDelegate.h"
#import "SessionData.h"
#import "LoginController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [Parse initializeWithConfiguration:[ParseClientConfiguration configurationWithBlock:^(id<ParseMutableClientConfiguration> configuration) {
        configuration.applicationId = @"GEPojo0wMfogSrNWpfgBk2NtYbzoRePZJZk8c3OE";
        configuration.clientKey = @"BirHibZJuvDm033OzQXIpVvBETNyYJR2D8FFgwMp";
        configuration.server = @"https://parseapi.back4app.com";
        configuration.localDatastoreEnabled = YES; // If you need to enable local data store
    }]];
    
    [GIDSignIn sharedInstance].clientID = @"922915336867-j77rik8ifvg62kph8fc6mq9ogo3u243d.apps.googleusercontent.com";
    [GIDSignIn sharedInstance].delegate = self;

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // Sin out of application
//    [GIDSignIn sharedInstance ].signOut;
//    
//    //Initialize your own window
//    UIWindow *mywindow = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
//    self.window=mywindow;
//    // Initialize your own viewcontroller
//    LoginController *myViewController = [[LoginController alloc]init];
//    [self.window addSubview:myViewController.view];
//    [self.window makeKeyAndVisible];
    
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Sin out of application
}

/* Google signin */

- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
}

/* Data populate to user from here */
- (void)signIn:(GIDSignIn *)signIn
didSignInForUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    /* Google sign in instance initialization */
    [SessionData setLoggedUser:[LoggedUser setLoggedUser:user]];
    
    NSString *email = user.profile.email;
//    if(lemail){
//        [self initializePage:(LoggedUser*) luser];
//    }else{
//        /* loading sign up page */
//        NSString * storyboardName = @"Main";
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
//        UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"SignUpController"];
//        [self presentViewController:vc animated:YES completion:nil];
//    }
    

}

- (void)signIn:(GIDSignIn *)signIn
didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
//    NSString *userId = user.userID;
    // Sin out of application
    [GIDSignIn sharedInstance ].signOut;
}

// Dismiss the "Sign in with Google" view after successful login
- (void)signIn:(GIDSignIn *)signIn
dismissViewController:(UIViewController *)viewController {
    /* dismiss google page */    
    /* Google sign in instance initialization */
    GIDGoogleUser *user = [GIDSignIn sharedInstance].currentUser;
}


@end
