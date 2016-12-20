//
//  EnrolledStudentsViewController.h
//  edConnect
//
//  Created by Praveen Sivadasan on 12/15/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface EnrolledStudentsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *studentView;
@property (nonatomic, strong) UISearchController *searchController;


@property (weak, nonatomic) IBOutlet UIBarButtonItem *viewChartButton;


/* action */
- (IBAction)backButton:(id)sender;
- (IBAction)updateGrades:(id)sender;
- (IBAction)showChart:(id)sender;


/* Variables */
@property(nonatomic, readwrite) PFObject *selectedCourse;
@property(nonatomic, readwrite) PFObject *selectedUserCourseObj;
@property (strong, nonatomic)  NSArray * approvedStudentCourseList;
@property (nonatomic, strong) NSArray *searchResults;


@property (weak, nonatomic) IBOutlet UINavigationBar *enrolledNavBar;


@end
