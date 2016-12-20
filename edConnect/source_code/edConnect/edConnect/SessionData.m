//
//  SessionData.m
//  edConnect
//
//  Created by Praveen Sivadasan on 12/4/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import "SessionData.h"

@implementation SessionData

static LoggedUser *luser;
static NSDictionary *menuList;
static NSArray *termList;
static NSArray *roleList;

static NSString *REQ_APP;
static NSString *REQ_PEN;
static NSString *REQ_REJ;


+ (LoggedUser*) getLoggedUser{
    if(luser == nil){
        return [[LoggedUser alloc] init];
    }else{
        return luser;
    }
}
+ (NSDictionary *) getOperationValues{
    return menuList;
}

+ (NSArray *) getTermList{
    return termList;
}

+ (NSArray *) getRoleList{
    return roleList;
}

+(NSString *) getReqRej{
    return REQ_REJ;
}

+(NSString *) getReqApp{
    return REQ_APP;
}

+(NSString *) getReqPen{
    return REQ_PEN;
}


+ (void) setOperationValues{
    REQ_APP = @"Approved";
    REQ_PEN = @"Pending";
    REQ_REJ = @"Rejected";
    
    menuList = @{
                 @"My Courses" : @"",
                 @"Course Requests" : @"",
                 @"Courses" : @"CoursesViewController",
                 @"Students" : @"UserViewController",
                 @"Faculties" : @"UserViewController",
                 };
    termList = @[@"Spring 2017",@"Fall 2016",@"Summer 2016",@"Spring 2016",@"Fall 2015"];
    roleList = @[@"Admin",@"Student",@"Faculty"];
    
}

+ (void) setLoggedUser:(LoggedUser*) loggedUser{
    if(loggedUser != nil)
        luser = loggedUser;
}


@end
