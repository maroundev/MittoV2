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
   
    
    
}
// Enables background touch to return keyboards
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.textFieldOnme resignFirstResponder];
    [self.textFieldtwo resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"fyx_service_started_key"])
    {
        [FYX startService:self];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];    // it shows
}



#pragma mark - FYXServiceDelegate methods

- (void)serviceStarted
{
   // NSLog(@"#########Proximity service started!");
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"fyx_service_started_key"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)startServiceFailed:(NSError *)error
{
   // NSLog(@"#########Proximity service failed to start! error is: %@", error);
    
    NSString *message = @"Service failed to start, please check to make sure your Application Id and Secret are correct.";
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Proximity Service"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}
- (IBAction)loginPressed:(id)sender {
    
    [FYX startService:self];
}




@end
