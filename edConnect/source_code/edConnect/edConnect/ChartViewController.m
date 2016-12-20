//
//  ChartViewController.m
//  edConnect
//
//  Created by Praveen Sivadasan on 12/16/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import "ChartViewController.h"
#import "FSLineChart.h"
#import "UIColor+FSPalette.h"
#import "EnrolledStudentsViewController.h"

@interface ChartViewController ()

@property (nonatomic, strong) IBOutlet FSLineChart *chartWithDates;

@end

@implementation ChartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    
    _statNavBar.barTintColor = [UIColor colorWithRed:171/255.0f green:4/255.0f blue:30/255.0f alpha:1.0f];
    _statNavBar.tintColor = [UIColor whiteColor];
    _statNavBar.translucent = NO;
    _statNavBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

    
    [self loadChartWithDates];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
}


#pragma mark - Setting up the chart

- (void)loadChartWithDates {
    // Generating some dummy data
    
    NSArray * list = [self fetchApprovedStudents];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    CGRect frame = CGRectMake(5,70,screenWidth-50,screenHeight-100);
    
    _chartWithDates = [[FSLineChart alloc] initWithFrame:frame];
    
    NSMutableArray* names = [[NSMutableArray alloc] init];
    NSMutableArray* chartData ;
    
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    f.numberStyle = NSNumberFormatterDecimalStyle;
    chartData = [NSMutableArray arrayWithCapacity:[list count]];
    for(int i=0;i<[list count];i++) {
        if([list[i] objectForKey:@"grade"] != nil){
            NSNumber *x = [list[i] objectForKey:@"grade"];
            chartData[i] = x;
        }else{
            chartData[i] = (NSNumber*)0;
        }
        
        /* fetching user*/
        PFObject * userObj = [list[i] objectForKey:@"userId"];
        if(![[userObj allKeys] containsObject:@"first_name"]){
            //Fetch the user details sperately
            NSString *appUserId = [userObj valueForKey:@"objectId"];
            userObj = [self fetchAppUserFromUserCourse:appUserId];
        }
        
        /* full name */
        NSString *full_name = [[userObj objectForKey:@"first_name"] stringByAppendingString:[NSString stringWithFormat: @" %@", [userObj objectForKey:@"last_name"]]];
        
        [names addObject:full_name];
    }

    _chartWithDates.verticalGridStep = 6;
    _chartWithDates.horizontalGridStep = (int)[list count];
    _chartWithDates.fillColor = nil;
    _chartWithDates.displayDataPoint = YES;
    _chartWithDates.dataPointColor = [UIColor fsOrange];
    _chartWithDates.dataPointBackgroundColor = [UIColor fsOrange];
    _chartWithDates.dataPointRadius = 0.5;
    _chartWithDates.color = [_chartWithDates.dataPointColor colorWithAlphaComponent:0.3];
    _chartWithDates.valueLabelPosition = ValueLabelLeftMirrored;
    
    NSArray *array = [names copy];

    
    _chartWithDates.labelForIndex = ^(NSUInteger item) {
        return array[item];
    };
    
    _chartWithDates.labelForValue = ^(CGFloat value) {
        return [NSString stringWithFormat:@"%.02f", value];
    };
    
    [_chartWithDates setChartData:chartData];
    
    [self.view addSubview:_chartWithDates];
    
}

- (PFObject*) fetchAppUserFromUserCourse:(NSString*) id{
    PFQuery *query = [PFQuery queryWithClassName:@"AppUser"];
    [query whereKey:@"objectId" equalTo:id];
    NSArray *allusers = [query findObjects];
    if([allusers count] != 0){
        return [allusers objectAtIndex:0];
    }
    return nil;
}

-(NSArray*) fetchApprovedStudents{
    PFQuery *query1 = [PFQuery queryWithClassName:@"StudentCourses"];
    [query1 whereKey:@"courseId" equalTo:_selectedCourse];
    [query1 whereKey:@"status" equalTo:@"Approved"];
    [query1 whereKeyExists:@"grade"];
    return [query1 findObjects];
}

- (IBAction)backButtonClicked:(id)sender {
    
    NSString * storyboardName = @"Main";
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:storyboardName bundle: nil];
    UIViewController * vc;
    vc = [storyboard instantiateViewControllerWithIdentifier:@"EnrolledStudentsViewController"];
    
    EnrolledStudentsViewController *obj = (EnrolledStudentsViewController*)vc;
    obj.selectedUserCourseObj = _selectedUserCourseObj;
    obj.selectedCourse = _selectedCourse;
    
    [self presentViewController:vc animated:YES completion:nil];
}
@end
