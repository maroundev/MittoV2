//
//  DetailViewController.m
//  Mitto
//
//  Created by Maroun Abi ramia on 8/23/14.
//  Copyright (c) 2014 MAR. All rights reserved.
//

#import "DetailViewController.h"
#import <MessageUI/MessageUI.h>

@interface DetailViewController () <MFMailComposeViewControllerDelegate>
- (IBAction)back:(id)sender;
- (IBAction)contact:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *descriptionView;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation DetailViewController
@synthesize rowPicked;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.descriptionView setEditable:YES];
    self.descriptionView.textColor = [UIColor whiteColor];
    [self.descriptionView setEditable:NO];
    [self showDetails:rowPicked];
    
    NSLog(@"ROWPICKED IS@@@@@@@@@@@@@@@@@@@@@@:::::> %d", rowPicked);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(BOOL)prefersStatusBarHidden{
    return NO;
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

- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)contact:(id)sender {
    NSString *emailTitle = @"Mitto: Interested user";
    // Email Content
    NSString *messageBody = @"Hello, I am interested in your post.";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"xxxxxxxxxx@gmail.com"];
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    mc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:mc animated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)showDetails :(int )productSelected{
    if (productSelected == 1){
        UIImage *image = [UIImage imageNamed:@"office.jpg"];
        [self.imageView setImage:image];
        self.label.text = @"iOS Developer Wanted";
        self.descriptionView.text = @"Looking for product-aware engineer who is a thoughtful, responsible and passionate builder who appreciates user experience. We’re looking for someone who is not only well versed in iOS development, but also has a strong understanding of good UX and isn’t afraid to get their hands dirty in backend code.\n\nWe believe that great product people use lots of products, so if you’re an active user of Airbnb, we are listening.";
    }
    else if (productSelected == 2){
        UIImage *image = [UIImage imageNamed:@"bike.png"];
        [self.imageView setImage:image];
        self.label.text = @"Stylish bike for sale";
        self.descriptionView.text = @"Bertelli's frame anthracite, size m, with a custom chrome fork. Very sweet ideal saddle, vintage, but like new.\n\nHand built wheels, composed by gipiemme track hubs, performance mt tubular rims and some generic tubular tires. The crankset is the old-fashion replica of the campagnolo imported by viking cycles.";
    }
    else if (productSelected == 3){
        UIImage *image = [UIImage imageNamed:@"bed.jpg"];
        [self.imageView setImage:image];
        self.label.text = @"Luxurious Apartment Available";
        self.descriptionView.text = @"Whether you are here for work or pleasure, you will be able to relax and enjoy staying in one of the newest lofts in one of San Francisco's highly desirable and most convenient neighborhoods!\n\nWireless high-speed fiber optic internet available. This new green building was constructed without air conditioning -- due to San Francisco's coastal climate, you would never need it (temperatures hover in the 60s year-round).";
    }
    else if (productSelected == 4){
        UIImage *image = [UIImage imageNamed:@"car.jpg"];
        [self.imageView setImage:image];
        self.label.text = @"2014 Tesla Model S For Sale";
        self.descriptionView.text = @"2014 Tesla Model S Performance 85kwh. The P85 kwh offers an extended range of 265 miles/charge and an additional 114 hp over the standard 60kwh Model S. The P85+ has a total of 416hp which gets you from 0-60mph in 4.2seconds, making it one of the fastest sedans on the market.\n\nAll this aside, the P85+ Model S is not only fast, it's also safe. The Model S achieved the best safety rating of any car ever tested by the NHTSA, only of many awards achieved by the Model S.";
    }
}
@end
