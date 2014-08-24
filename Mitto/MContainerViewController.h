//
//  MContainerViewController.h
//  Mitto
//
//  Created by Shana Azria on 8/23/14.
//  Copyright (c) 2014 MAR. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MContainerViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl *toggleButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *plusButton;

@end
