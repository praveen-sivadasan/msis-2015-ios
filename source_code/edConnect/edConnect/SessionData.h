//
//  SessionData.h
//  edConnect
//
//  Created by Praveen Sivadasan on 12/4/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoggedUser.h"

@interface SessionData : NSObject

+ (LoggedUser*) getLoggedUser;
+ (void) setLoggedUser:(LoggedUser*) loggedUser;
+ (void) setOperationValues;
+ (NSDictionary *) getOperationValues;
+ (NSArray *) getTermList;
+ (NSArray *) getRoleList;

+(NSString *) getReqRej;
+(NSString *) getReqApp;
+(NSString *) getReqPen;

@end
