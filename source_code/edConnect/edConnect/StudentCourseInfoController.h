//
//  StudentCourseInfoController.h
//  edConnect
//
//  Created by Praveen Sivadasan on 12/13/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface StudentCourseInfoController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCapacityLabel;
@property (weak, nonatomic) IBOutlet UILabel *seatsAvailableLabel;
@property (weak, nonatomic) IBOutlet UILabel *instructorLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;


@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *totalCapacityTextField;
@property (weak, nonatomic) IBOutlet UITextField *seatsAvaiTextField;
@property (weak, nonatomic) IBOutlet UITextField *instructorTextField;
@property (weak, nonatomic) IBOutlet UITextField *statusTextField;
@property (weak, nonatomic) IBOutlet UITextField *gradesTextField;


@property(nonatomic, readwrite) PFObject *studentCourseObj;

@end
