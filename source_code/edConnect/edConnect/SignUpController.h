//
//  SignUpController.h
//  edConnect
//
//  Created by Praveen Sivadasan on 12/11/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface SignUpController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *nameLabelText;
@property (weak, nonatomic) IBOutlet UILabel *emailLabelText;
@property (weak, nonatomic) IBOutlet UILabel *roleLabelText;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabelText;
@property (weak, nonatomic) IBOutlet UILabel *phoneWarning;



@property (weak, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UIPickerView *rolePickerView;
@property (weak, nonatomic) IBOutlet UITextField *phoneLabelTextField;

@property (weak, nonatomic) IBOutlet UINavigationBar *signUpNavBar;

- (IBAction)signUpClicked:(id)sender;

@end
