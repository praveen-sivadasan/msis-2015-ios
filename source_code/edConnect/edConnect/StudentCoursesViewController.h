//
//  StudentCoursesViewController.h
//  edConnect
//
//  Created by Praveen Sivadasan on 12/13/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface StudentCoursesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating>

@property (weak, nonatomic) IBOutlet UILabel *totalCourseLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalGradeLabel;

@property (weak, nonatomic) IBOutlet UILabel *courseValue;
@property (weak, nonatomic) IBOutlet UILabel *gradeValue;

@property (strong, nonatomic)  NSArray * studentCourseList;
@property (nonatomic, strong) NSArray *searchResults;

@property (weak, nonatomic) IBOutlet UITableView *mycourseTableView;
@property (nonatomic, strong) UISearchController *searchController;

@end
