//
//  ViewController.m
//  edConnect
//
//  Created by Praveen Sivadasan on 12/3/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import "ViewController.h"
#import "SessionData.h"
#import <GoogleSignIn/GoogleSignIn.h>
#import "SWRevealViewController.h"
#import "MainTabBarController.h"
#import "CoursesViewController.h"
#import "UserViewController.h"
#import "PatternViewCell.h"
#import "JSBadgeView.h"


@interface ViewController ()

@property(nonatomic,strong) NSMutableArray * patternImageArray;

@end

@implementation ViewController

@synthesize nameLabel;

- (void)viewWillAppear:(BOOL)animated{
    LoggedUser *luser = [SessionData getLoggedUser];
    
    /* beautifying page */
    _navBar.barTintColor = [UIColor colorWithRed:171/255.0f green:4/255.0f blue:30/255.0f alpha:1.0f];
    _navBar.tintColor = [UIColor whiteColor];
    _navBar.translucent = NO;
    _navBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    
    self.view.layer.backgroundColor = [[UIColor colorWithRed:242/255.0f green:241/255.0f blue:236/255.0f alpha:1.0f] CGColor];
    
    if(luser.user.userId == nil){
        NSArray * users;
        PFQuery *query = [PFQuery queryWithClassName:@"AppUser"];
        [query whereKey:@"email" equalTo:luser.email];
        //[query selectKeys:@[@"objectId",@"email",@"role"]];
        users = [query findObjects];
        if([users count] != 0){
            PFObject *obj = [users objectAtIndex:0];
            luser.user.email = [obj objectForKey:@"email"];
            luser.user.userId = [obj valueForKey:@"objectId"];
            luser.user.role =[obj objectForKey:@"role"];
            luser.user.first_name = [obj objectForKey:@"first_name"];
            luser.user.last_name = [obj objectForKey:@"last_name"];
            luser.user.phone = [obj objectForKey:@"phone"];
            
            luser.userObject = obj;
            
            /* processing image back*/
            NSData *imageFile = [[obj objectForKey:@"image"] getData];
            UIImage *retreievedImage = [[UIImage alloc] initWithData:imageFile];
            luser.user.userImage = retreievedImage;
        }
    }
    
    if(luser.user.userId != nil){
        [self initializePage:(LoggedUser*) luser];
        //[self.activityIndicator stopAnimating];
        //self.activityIndicator.hidden = YES;
        /* Tab bar controller */
        
    }else{
        /* loading sign up page */
        NSString * storyboardName = @"Main";
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
        UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"SignUpController"];
        vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;//UIModalTransitionStyleFlipHorizontal;
        // [_activityIndicator stopAnimating];
        
        [self presentViewController:vc animated:YES completion:nil];
        
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    LoggedUser *luser = [SessionData getLoggedUser];
    [self initializePage:(LoggedUser*) luser];
    
    //nameLabel.textAlignment = NSTextAlignmentRight;
    //    NSString * storyboardName = @"Main";
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    //    SWRevealViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    //    [self.navigationController pushViewController:vc animated:YES];
    
    //    SWRevealViewController *sideBar = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
    //    [self.navigationController pushViewController:sideBar animated:YES];
    
    /* Slide bar */
    //    _barButton.target = self.revealViewController;
    //    _barButton.action = @selector(revealToggle:);
    //    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    //    self.navigationController.navigationBarHidden = NO;
    //
    //    SWRevealViewController *revealViewController = self.revealViewController;
    //    if ( revealViewController )
    //    {
    //        [self.barButton setTarget: self.revealViewController];
    //        [self.barButton setAction: @selector( revealToggle: )];
    //        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    //    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void) initializePage:(LoggedUser*) luser{
    
    _patternImageArray = [[NSMutableArray alloc] init];
    
    NSString *full_name = [luser.user.first_name stringByAppendingString:[NSString stringWithFormat: @" %@", luser.user.last_name]];
    nameLabel.text = [full_name stringByAppendingString:[NSString stringWithFormat: @" ( %@ )", luser.user.role]];
    [[self nameLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:12]];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    
    [[self menuLabel] setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:17]];
    
    /* Load menu view*/
    //self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //self.tableView.dataSource=self;
    //self.tableView.delegate=self;
    
    self.collectionView.dataSource=self;
    self.collectionView.delegate=self;
    self.collectionView.backgroundColor = [UIColor colorWithRed:242/255.0f green:241/255.0f blue:236/255.0f alpha:1.0f];
    
    if([luser.user.role isEqualToString:@"Admin"]){
        [self.patternImageArray addObject:@"requests.png"];
    }else{
        [self.patternImageArray addObject:@"myCourse.png"];
    }
    [self.patternImageArray addObject:@"courses.png"];
    [self.patternImageArray addObject:@"students.png"];
    [self.patternImageArray addObject:@"faculty.png"];
    
    UIImage * userImage = [UIImage imageNamed:@"user_default.png"];
    [_userImageView setImage:userImage];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logoutUser:(id)sender {
    [GIDSignIn sharedInstance ].signOut;
    
    //Navigate to another view
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"LoginController"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}




-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.patternImageArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    PatternViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PatternCell" forIndexPath:indexPath];
    NSString *mypatternString = [self.patternImageArray objectAtIndex:indexPath.row];
    cell.patternImageView.image = [UIImage imageNamed:mypatternString];
    
    
    [cell.patternLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:12]];
    cell.patternLabel.backgroundColor = [UIColor colorWithRed:242/255.0f green:241/255.0f blue:236/255.0f alpha:1.0f];
    cell.patternLabel.textAlignment = NSTextAlignmentCenter;
    
    
    if([mypatternString isEqualToString:@"requests.png"]){
        cell.patternLabel.text = @"Requests";
        NSInteger count = [self fetchCountAllPendingRequests];
        if(count > 0){
           JSBadgeView *badgeView = [[JSBadgeView alloc] initWithParentView:cell.patternImageView alignment:JSBadgeViewAlignmentTopRight];
           badgeView.badgeText = [NSString stringWithFormat: @"%ld",(long)count];
            
        }
        
    }else if([mypatternString isEqualToString:@"requests.png"]){
        cell.patternLabel.text = @"Requests";
    }else if([mypatternString isEqualToString:@"myCourse.png"]){
        cell.patternLabel.text = @"My course";
    }else if([mypatternString isEqualToString:@"courses.png"]){
        cell.patternLabel.text = @"Courses";
    }else if([mypatternString isEqualToString:@"students.png"]){
        cell.patternLabel.text = @"Students";
    }else if([mypatternString isEqualToString:@"faculty.png"]){
        cell.patternLabel.text = @"Faculties";
    }
    
    return cell;
}

-(NSInteger) fetchCountAllPendingRequests{
    LoggedUser* luser = [SessionData getLoggedUser];
    
    if([luser.user.role isEqualToString:@"Admin"]){
        
        NSArray *myReqs;
        
        PFQuery *query1 = [PFQuery queryWithClassName:@"StudentCourses"];
        [query1 whereKey:@"status" equalTo:@"Pending"];
        NSArray *myReq1 = [query1 findObjects];
        
        PFQuery *query2 = [PFQuery queryWithClassName:@"FacultyCourses"];
        [query2 whereKey:@"status" equalTo:@"Pending"];
        NSArray *myReq2 = [query2 findObjects];
        
        myReqs = [myReq1 arrayByAddingObjectsFromArray:myReq2];
        
        if(myReqs != nil)
            return [myReqs count];
        
        return 0;
    }
    return 0;
}


-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(70.0, 70.0);
}


-(UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *imageName = _patternImageArray[indexPath.row];
    NSString *controller;
    LoggedUser *luser = [SessionData getLoggedUser];
    
    if([imageName isEqualToString:@"requests.png"] || ([imageName isEqualToString:@"myCourse.png"] && [luser.user.role isEqualToString:@"Faculty"])){
        controller = @"OtherUserCoursesViewController";
    }else if([imageName isEqualToString:@"myCourse.png"]){
        controller = @"StudentCoursesViewController";
    }else if([imageName isEqualToString:@"courses.png"]){
        controller = @"CoursesViewController";
    }else if([imageName isEqualToString:@"students.png"]){
        controller = @"UserViewController";
    }else if([imageName isEqualToString:@"faculty.png"]){
        controller = @"UserViewController";
    }
    
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:controller];
    
    if([imageName isEqualToString:@"students.png"]){
        UserViewController *uc = (UserViewController*)vc;
        uc.showStudents = true ;
    }else if([imageName isEqualToString:@"faculty.png"]){
        UserViewController *uc = (UserViewController*)vc;
        uc.showStudents = false ;
    }
    
    
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;//UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:vc animated:YES completion:nil];
}




///* UITableView Controller logic*/
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [menuList count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    LoggedUser *luser = [SessionData getLoggedUser];
//    static NSString *cellId=@"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
//    if(cell==Nil){
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
//    }
//    NSString * v = [menuList objectAtIndex:indexPath.row];
//
//    if([v isEqualToString:@"My Courses"]){
//        //hiding only for admin
//        if(![luser.user.role isEqualToString:@"Admin"]){
//            cell.textLabel.text = v ;
//        }
//    }else if([v isEqualToString:@"Course Requests"]){
//        //printing only for admin
//        if([luser.user.role isEqualToString:@"Admin"]){
//            cell.textLabel.text = v ;
//        }
//    }else{
//        cell.textLabel.text = v ;
//    }
//    // cell.imageView.image = [v img];
//
//    return cell;
//}
//
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    NSString *cellText = cell.textLabel.text;
//
//    for(id key in operationsList) {
//        if(key == cellText && !([cellText isEqualToString:@"My Courses"] ||[cellText isEqualToString:@"Course Requests"]  )){
//            // For all controllers except my course view controllers
//            NSString *controller = [operationsList objectForKey:key];
//            NSString * storyboardName = @"Main";
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
//            UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:controller];
//
//            if([cellText isEqualToString:@"Students"]){
//                UserViewController *uc = (UserViewController*)vc;
//                uc.showStudents = true ;
//            }else if([cellText isEqualToString:@"Faculties"]){
//                UserViewController *uc = (UserViewController*)vc;
//                uc.showStudents = false ;
//            }
//
//            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;//UIModalTransitionStyleFlipHorizontal;
//            [self presentViewController:vc animated:YES completion:nil];
//
//        }else if(key == cellText){
//            NSString * storyboardName = @"Main";
//            LoggedUser *luser = [SessionData getLoggedUser];
//
//            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
//            NSString *controller;
//            if([luser.user.role isEqualToString:@"Student"]){
//                controller = @"StudentCoursesViewController";
//
//            }else if([luser.user.role isEqualToString:@"Faculty"] || [luser.user.role isEqualToString:@"Admin"]){
//                //otheruser my courses controller
//                controller = @"OtherUserCoursesViewController";
//            }
//
//            UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:controller];
//            vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;//UIModalTransitionStyleFlipHorizontal;
//            [self presentViewController:vc animated:YES completion:nil];
//
//        }
//    }
//}

@end
