                                          //
//  UserViewController.h
//  edConnect
//
//  Created by Praveen Sivadasan on 12/11/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface UserViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating>

@property (weak, nonatomic) IBOutlet UITableView *userTableView;
@property (nonatomic, strong) UISearchController *searchController;

@property (strong, nonatomic)  NSArray * users;
@property (nonatomic, strong) NSArray *searchResults;

@property (nonatomic,readwrite) BOOL showStudents;

@property (weak, nonatomic) IBOutlet UINavigationBar *userNavBar;

@end
