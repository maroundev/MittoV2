//
//  MViewController.m
//  Mitto
//
//  Created by Maroun Abi ramia on 8/23/14.
//  Copyright (c) 2014 MAR. All rights reserved.
//

#import "MViewController.h"
#import <FYX/FYX.h>
#import "TableViewController.h"

@interface MViewController () <FYXServiceDelegate>

@property (strong, nonatomic) IBOutlet UISwitch *proximityServiceSwitch;
@property (strong, nonatomic) IBOutlet UIView *proximityServiceSwitchView;
@property (strong, nonatomic) IBOutlet UIView *logoView;
@property (strong, nonatomic) IBOutlet UIView *switchView;


@end

@implementation MViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupProximityEnableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    [self beginLoadingAnimation];
}


- (void)setupProximityEnableView
{
    UIView *v = self.switchView;
    [v.layer setCornerRadius:10.0f];
    [v.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    [v.layer setBorderWidth:0.5f];
    [v.layer setShadowColor:[UIColor blackColor].CGColor];
    [v.layer setShadowOpacity:0.0];
    [v.layer setShadowRadius:0.0];
    [v.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
}

- (void)beginLoadingAnimation
{
    [UIView animateWithDuration:0.9 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.logoView.transform = CGAffineTransformMakeTranslation(0.0, -70.0);
    } completion:^(BOOL finished) {
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"fyx_service_started_key"])
        {
            [FYX startService:self];
        }
        else
        {
            [self.proximityServiceSwitchView setHidden:false];
        }
    }];
}

- (void)presentSightingViewController
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    UINavigationController *controller = [storyboard instantiateViewControllerWithIdentifier:@"TableView"];
    controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    /*[self presentViewController:controller animated:YES completion:^{
        id<UIApplicationDelegate> appDelegate = [UIApplication sharedApplication].delegate;
        appDelegate.window.rootViewController = controller;
        [appDelegate.window makeKeyAndVisible];
    }];*/
}

#pragma mark - FYXServiceDelegate methods

- (void)serviceStarted
{
    NSLog(@"#########Proximity service started!");
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"fyx_service_started_key"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self presentSightingViewController];
}

- (void)startServiceFailed:(NSError *)error
{
    NSLog(@"#########Proximity service failed to start! error is: %@", error);
    
    NSString *message = @"Service failed to start, please check to make sure your Application Id and Secret are correct.";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Proximity Service"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [self.proximityServiceSwitch setOn:NO animated:YES];
}

- (IBAction)proximityServiceSwitchChanged:(id)sender
{
    [FYX startService:self];
}


@end
