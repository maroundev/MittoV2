//
//  MContainerViewController.m
//  Mitto
//
//  Created by Shana Azria on 8/23/14.
//  Copyright (c) 2014 MAR. All rights reserved.
//

#import "MContainerViewController.h"

@interface MContainerViewController ()

@end

@implementation MContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)menuPressed:(id)sender {
    CGRect uiFrame = self.menuView.frame;
    CGRect uiFrame2 = self.mainView.frame;
    //click on button
    if (uiFrame.origin.x == -83) {
        
        NSLog(@"you cna see it!! x: %f, y: %f, width: %f, height: %f", uiFrame2.origin.x, uiFrame2.origin.y, uiFrame2.size.width, uiFrame2.size.height);
        [UIView animateWithDuration:0.3f animations:^{
            [self.menuView setFrame:CGRectMake(0, uiFrame.origin.y, uiFrame.size.width, uiFrame.size.height)];
        }];
        [UIView animateWithDuration:0.3f animations:^{
            [self.mainView setFrame:CGRectMake(uiFrame2.origin.x+83, uiFrame2.origin.y, uiFrame2.size.width, uiFrame2.size.height)];
        }];
        
        
       
    } else {
        
        NSLog(@"you cannot see it!! x: %f, y: %f, width: %f, height: %f", uiFrame2.origin.x, uiFrame2.origin.y, uiFrame2.size.width, uiFrame2.size.height);
        [UIView animateWithDuration:0.3f animations:^{
            [self.menuView setFrame:CGRectMake(-83, uiFrame.origin.y, uiFrame.size.width, uiFrame.size.height)];
        }];
        [UIView animateWithDuration:0.3f animations:^{
            [self.mainView setFrame:CGRectMake(uiFrame2.origin.x-83, uiFrame2.origin.y, uiFrame2.size.width, uiFrame2.size.height)];
        }];

    }
    
    
   
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.menuView.hidden = NO;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
