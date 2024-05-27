//
//  CoursesViewController.h
//  edConnect
//
//  Created by Praveen Sivadasan on 12/5/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CoursesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating>

@property (weak, nonatomic) IBOutlet UITableView *courseTableView;
@property (nonatomic, strong) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *addCourseButton;
@property (strong, nonatomic)  NSArray * courses;
@property (nonatomic, strong) NSArray *searchResults;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UINavigationBar *courseNavBar;

@end

