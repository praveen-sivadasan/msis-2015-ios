//
//  LoggedUser.h
//  edConnect
//
//  Created by Praveen Sivadasan on 12/4/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import "User.h"
#import <Parse/Parse.h>

@interface LoggedUser : NSObject{
    NSString *userId;
    NSString *idToken;
    NSString *fullName;
    NSString *givenName;
    NSString *familyName;
    NSString *email;
    User *user;
    PFObject *userObject;
}
@property(nonatomic, readwrite) NSString *userId;
@property(nonatomic, readwrite) NSString *idToken;
@property(nonatomic, readwrite) NSString *fullName;
@property(nonatomic, readwrite) NSString *givenName;
@property(nonatomic, readwrite) NSString *familyName;
@property(nonatomic, readwrite) NSString *email;
@property(nonatomic, readwrite) User *user;
@property(nonatomic, readwrite) PFObject *userObject;

+ (LoggedUser*) setLoggedUser:(GIDGoogleUser*) user;


//Apple keychain
//+ (NSString *) getPasswordForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error;
//+ (BOOL) storeUsername: (NSString *) username andPassword: (NSString *) password forServiceName: (NSString *) serviceName updateExisting: (BOOL) updateExisting error: (NSError **) error;
@end
