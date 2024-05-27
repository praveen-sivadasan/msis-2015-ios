//
//  FacultyCourseInfoController.h
//  edConnect
//
//  Created by Praveen Sivadasan on 12/13/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MessageUI/MessageUI.h>



@interface FacultyCourseInfoController : UIViewController<MFMailComposeViewControllerDelegate>{
    MFMailComposeViewController *mailComposer;
}


/* Labels */
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalCapacityLabel;
@property (weak, nonatomic) IBOutlet UILabel *seatsAvailableLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *instructorLabel;

/* Text fields */
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *capacityTextField;
@property (weak, nonatomic) IBOutlet UITextField *seatsTextField;
@property (weak, nonatomic) IBOutlet UITextField *statusTextField;
@property (weak, nonatomic) IBOutlet UITextField *instructorTextField;


/* Button refernce for hiding and showing according to the user*/
@property (weak, nonatomic) IBOutlet UIButton *studentsEnrolledButton;
@property (weak, nonatomic) IBOutlet UIButton *approveButton;


@property (weak, nonatomic) IBOutlet UINavigationBar *courseNavBar;


/* Actions */
- (IBAction)studentsEnrolledClicked:(id)sender;
- (IBAction)approveRequest:(id)sender;


/* Variables */
@property(nonatomic, readwrite) PFObject *selectedUserCourseObj;

@end
