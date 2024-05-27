//
//  LoggedUser.m
//  edConnect
//
//  Created by Praveen Sivadasan on 12/4/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import "LoggedUser.h"
//#import <Security/Security.h>
//Apple keychain
//static NSString *SFHFKeychainUtilsErrorDomain = @"SFHFKeychainUtilsErrorDomain";

@implementation LoggedUser

@synthesize userId;
@synthesize idToken;
@synthesize fullName;
@synthesize givenName;
@synthesize familyName;
@synthesize email;
@synthesize user;

+ (LoggedUser*) setLoggedUser:(GIDGoogleUser*) user{
    LoggedUser *luser = [[LoggedUser alloc] init];
    luser.userId = user.userID;
    luser.idToken = user.authentication.idToken;
    luser.fullName = user.profile.name;
    luser.givenName = user.profile.givenName;
    luser.familyName = user.profile.familyName;
    luser.email = user.profile.email;
    luser.user = [[User alloc]init];
    return luser;
}


/* Apple keychain username-password*/
//+ (NSString *) getPasswordForUsername: (NSString *) username andServiceName: (NSString *) serviceName error: (NSError **) error {
//    if (!username || !serviceName) {
//        *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: -2000 userInfo: nil];
//        return nil;
//    }
//    
//    SecKeychainItemRef item = [SFHFKeychainUtils getKeychainItemReferenceForUsername: username andServiceName: serviceName error: error];
//    
//    if (*error || !item) {
//        return nil;
//    }
//    
//    // from Advanced Mac OS X Programming, ch. 16
//    UInt32 length;
//    char *password;
//    SecKeychainAttribute attributes[8];
//    SecKeychainAttributeList list;
//    
//    attributes[0].tag = kSecAccountItemAttr;
//    attributes[1].tag = kSecDescriptionItemAttr;
//    attributes[2].tag = kSecLabelItemAttr;
//    attributes[3].tag = kSecModDateItemAttr;
//    
//    list.count = 4;
//    list.attr = attributes;
//    
//    OSStatus status = SecKeychainItemCopyContent(item, NULL, &list, &length, (void **)&password);
//    
//    if (status != noErr) {
//        *error = [NSError errorWithDomain: SFHFKeychainUtilsErrorDomain code: status userInfo: nil];
//        return nil;
//    }
//    
//    NSString *passwordString = nil;
//    
//    if (password != NULL) {
//        char passwordBuffer[1024];
//        
//        if (length > 1023) {
//            length = 1023;
//        }
//        strncpy(passwordBuffer, password, length);
//        
//        passwordBuffer[length] = '\0';
//        passwordString = [NSString stringWithCString:passwordBuffer];
//    }
//    
//    SecKeychainItemFreeContent(&list, password);
//    
//    CFRelease(item);
//    
//    return passwordString;
//}

    
@end
