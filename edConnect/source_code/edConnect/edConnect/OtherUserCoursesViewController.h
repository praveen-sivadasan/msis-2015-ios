//
//  OtherUserCoursesViewController.h
//  edConnect
//
//  Created by Praveen Sivadasan on 12/13/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>


@interface OtherUserCoursesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating>

@property (strong, nonatomic)  NSArray * userCourseList;
@property (nonatomic, strong) NSArray *searchResults;

@property (weak, nonatomic) IBOutlet UITableView *mycourseTableView;
@property (nonatomic, strong) UISearchController *searchController;

@property (weak, nonatomic) IBOutlet UINavigationBar *otherUserNavBar;


@end
