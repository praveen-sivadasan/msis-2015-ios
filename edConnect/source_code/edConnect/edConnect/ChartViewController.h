//
//  ChartViewController.h
//  edConnect
//
//  Created by Praveen Sivadasan on 12/16/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ChartViewController : UIViewController


@property (weak, nonatomic) IBOutlet UINavigationBar *statNavBar;


- (IBAction)backButtonClicked:(id)sender;

/* Variables */
@property(nonatomic, readwrite) PFObject *selectedCourse;
@property(nonatomic, readwrite) PFObject *selectedUserCourseObj;

@end
