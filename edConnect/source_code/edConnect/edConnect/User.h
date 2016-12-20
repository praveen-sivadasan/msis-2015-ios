//
//  User.h
//  edConnect
//
//  Created by Praveen Sivadasan on 12/4/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface User : NSObject{
    NSString *userId;
    NSString *email;
    NSString *role;
    NSString *first_name;
    NSString *last_name;
    NSString *phone;
    UIImage *userImage;
}

@property(nonatomic, readwrite) NSString *userId;
@property(nonatomic, readwrite) NSString *email;
@property(nonatomic, readwrite) NSString *role;
@property(nonatomic, readwrite) NSString *first_name;
@property(nonatomic, readwrite) NSString *last_name;
@property(nonatomic, readwrite) NSString *phone;
@property(nonatomic, readwrite) UIImage *userImage;


@end
