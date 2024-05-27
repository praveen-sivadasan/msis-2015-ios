//
//  ViewController.h
//  edConnect
//
//  Created by Praveen Sivadasan on 12/3/16.
//  Copyright © 2016 Praveen Sivadasan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <Parse/Parse.h>

@interface ViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *menuLabel;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *barButton;// of hamburger button
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
//@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


//@property (nonatomic, retain) UITabBarController *tab;

- (IBAction)logoutUser:(id)sender;
@end

