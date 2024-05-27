//
//  AddCoursesViewController.h
//  edConnect
//
//  Created by Praveen Sivadasan on 12/5/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AddCoursesViewController : UIViewController<UIImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UIPickerView *termPickerView;
@property (weak, nonatomic) IBOutlet UIImageView *courseImage;
@property (weak, nonatomic) IBOutlet UIDatePicker *startDatePicker;
@property (nonatomic, retain) UIImagePickerController *imagecontroller;

@property (weak, nonatomic) IBOutlet UITextField *courseName;
@property (weak, nonatomic) IBOutlet UITextField *instructorName;
@property (weak, nonatomic) IBOutlet UITextField *capacityNumber;
@property (weak, nonatomic) IBOutlet UILabel *imageSizeLabel;


@property (weak, nonatomic) IBOutlet UILabel *courseWarning;
@property (weak, nonatomic) IBOutlet UILabel *termWarning;
@property (weak, nonatomic) IBOutlet UILabel *instructorWarning;
@property (weak, nonatomic) IBOutlet UILabel *capacityWarning;


@property (weak, nonatomic) IBOutlet UILabel *courseLabelText;
@property (weak, nonatomic) IBOutlet UILabel *termLabelText;
@property (weak, nonatomic) IBOutlet UILabel *instructorLabelText;
@property (weak, nonatomic) IBOutlet UILabel *capacityLabelText;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabelText;

@property (weak, nonatomic) IBOutlet UINavigationItem *pageHeaderField;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;


@property(nonatomic, readwrite) PFObject *selectedCourse;
@property(nonatomic, readwrite) PFObject *courseRequest;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteButton;
@property (weak, nonatomic) IBOutlet UINavigationBar *courseNavBar;

- (IBAction)addCourses:(id)sender;
- (IBAction)getCourseImage:(id)sender;
- (IBAction)deleteButtonClicked:(id)sender;

@end
