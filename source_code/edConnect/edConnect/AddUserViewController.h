//
//  AddUserViewController.h
//  edConnect
//
//  Created by Praveen Sivadasan on 12/11/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface AddUserViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *fnameWarningLabel;
@property (weak, nonatomic) IBOutlet UILabel *lnameWarningLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneWarningLabel;

@property (weak, nonatomic) IBOutlet UILabel *fnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *imageSizeLabel;

@property (weak, nonatomic) IBOutlet UITextField *fnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *lnameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *roleTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (nonatomic, retain) UIImagePickerController *imagecontroller;

@property (weak, nonatomic) IBOutlet UINavigationBar *profileNavBar;

@property (weak, nonatomic) IBOutlet UIButton *updateButton;
@property (weak, nonatomic) IBOutlet UIButton *uploadButton;


@property(nonatomic, readwrite) PFObject *selectedUser;

- (IBAction)updateButtonClicked:(id)sender;
- (IBAction)getCourseImage:(id)sender;

@end
