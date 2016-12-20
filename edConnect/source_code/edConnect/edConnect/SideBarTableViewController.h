//
//  SideBarTableViewController.h
//  edConnect
//
//  Created by Praveen Sivadasan on 12/4/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideBarTableViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *sideBarTableView;

@end
