//
//  TableViewController.m
//  Mitto
//
//  Created by Maroun Abi ramia on 8/23/14.
//  Copyright (c) 2014 MAR. All rights reserved.
//

#import "TableViewController.h"
#import "Cell.h"
#import "Transmitter.h"
#import "DetailViewController.h"

#import <FYX/FYX.h>
#import <FYX/FYXVisitManager.h>
#import <FYX/FYXSightingManager.h>
#import <FYX/FYXTransmitter.h>
#import <FYX/FYXVisit.h>

@interface TableViewController () <UITableViewDataSource, UITableViewDelegate, FYXVisitDelegate>

@property NSMutableArray *transmitters;
@property FYXVisitManager *visitManager;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar.topItem setTitle:@"Mitto"];
    
    self.transmitters = [NSMutableArray new];
    
    self.visitManager = [[FYXVisitManager alloc] init];
    self.visitManager.delegate = self;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.visitManager startWithOptions:@{FYXVisitOptionDepartureIntervalInSecondsKey:@15,
                                          FYXSightingOptionSignalStrengthWindowKey:@(FYXSightingOptionSignalStrengthWindowNone)}];
}



#pragma mark - FYX visit delegate

- (void)didArrive:(FYXVisit *)visit
{
    NSLog(@"############## didArrive: %@", visit);
}

- (void)didDepart:(FYXVisit *)visit
{
    NSLog(@"############## didDepart: %@", visit);
    
    Transmitter *transmitter = [[self.transmitters filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", visit.transmitter.identifier]] firstObject];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[self.transmitters indexOfObject:transmitter] inSection:0];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[cell class]])
    {
        [self grayOutSightingsCell:((Cell*)cell)];
    }
}

- (void)receivedSighting:(FYXVisit *)visit updateTime:(NSDate *)updateTime RSSI:(NSNumber *)RSSI
{
    NSLog(@"############## receivedSighting: %@", visit);
    
    Transmitter *transmitter = [[self.transmitters filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"identifier == %@", visit.transmitter.identifier]] firstObject];
    if (transmitter == nil)
    {
        transmitter = [Transmitter new];
        transmitter.identifier = visit.transmitter.identifier;
        transmitter.name = visit.transmitter.name ? visit.transmitter.name : visit.transmitter.identifier;
        transmitter.lastSighted = [NSDate dateWithTimeIntervalSince1970:0];
        transmitter.rssi = [NSNumber numberWithInt:-100];
        transmitter.previousRSSI = transmitter.rssi;
        transmitter.batteryLevel = 0;
        transmitter.temperature = 0;
        
        [self.transmitters addObject:transmitter];
        
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.transmitters.count - 1 inSection:0]]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
        
        if ([self.transmitters count] == 1)
        {
            [self hideNoTransmittersView];
        }
    }
    
    transmitter.lastSighted = updateTime;
    
    if ([self shouldUpdateTransmitterCell:visit transmitter:transmitter RSSI:RSSI])
    {
        transmitter.previousRSSI = transmitter.rssi;
        transmitter.rssi = RSSI;
        transmitter.batteryLevel = visit.transmitter.battery;
        transmitter.temperature = visit.transmitter.temperature;

    }
}

- (float)barWidthForRSSI:(NSNumber *)rssi
{
    NSInteger barMaxValue = [[NSUserDefaults standardUserDefaults] integerForKey:@"rssi_bar_max_value"];
    NSInteger barMinValue = [[NSUserDefaults standardUserDefaults] integerForKey:@"rssi_bar_min_value"];
    
    float rssiValue = [rssi floatValue];
    float barWidth;
    if (rssiValue >= barMaxValue)
    {
        barWidth = 270.0f;
    }
    else if (rssiValue <= barMinValue)
    {
        barWidth = 5.0f;
    } else
    {
        NSInteger barRange = barMaxValue - barMinValue;
        float percentage = (barMaxValue - rssiValue) / (float)barRange;
        barWidth = (1.0f - percentage) * 270.0f;
    }
    return barWidth;
}

- (void)grayOutSightingsCell:(Cell *)sightingsCell
{
    if (sightingsCell)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            sightingsCell.contentView.alpha = 0.3f;
            CGRect oldFrame = sightingsCell.imageView.frame;
            sightingsCell.imageView.frame = CGRectMake(oldFrame.origin.x, oldFrame.origin.y, 0, oldFrame.size.height);
            sightingsCell.isGrayedOut = YES;
        });
    }
}



- (BOOL)shouldUpdateTransmitterCell:(FYXVisit *)visit transmitter:(Transmitter *)transmitter RSSI:(NSNumber *)rssi
{
    if ([transmitter.rssi isEqual:rssi] &&
        [transmitter.batteryLevel isEqualToNumber:visit.transmitter.battery] &&
        [transmitter.temperature isEqualToNumber:visit.transmitter.temperature])
    {
        return NO;
    }
    return YES;
}

- (BOOL)isTransmitterAgedOut:(Transmitter *)transmitter
{
    NSDate *now = [NSDate date];
    NSTimeInterval ageOutPeriod = [[NSUserDefaults standardUserDefaults] integerForKey:@"age_out_period"];
    
    if ([now timeIntervalSinceDate:transmitter.lastSighted] > ageOutPeriod) {
        return YES;
    }
    return NO;
}


#pragma mark - User interface manipulation

- (void)hideNoTransmittersView
{
    // self.loadingView.hidden = YES;
}

- (void)showNoTransmittersView
{
    // self.loadingView.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.transmitters count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    // Configure the cell...
    Transmitter *tran = [self.transmitters objectAtIndex:indexPath.row];
    cell.label.text = tran.name;
    if ([cell.label.text isEqualToString:@"Shana"]) {
        //[self downloadImage:cell :@"http://rack.1.mshcdn.com/media/ZgkyMDEzLzExLzEyLzc1L2FpcmJuYi45MGI0OC5qcGcKcAl0aHVtYgkxMjAweDYyNyMKZQlqcGc/549d0831/671/airbnb.jpg"];
        UIImage *image = [UIImage imageNamed:@"cool-office-space.jpg"];
        [cell.imageView setImage:image];
    }
    return cell;
}
-(void)downloadImage :(Cell *)cell :(NSString *)urlToPass {
    //Download images in background so it doesn't lag.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *imageUrl = [NSString stringWithFormat:@"%@",urlToPass];
        //http://%@/favicon.ico
        NSURL  *url = [NSURL URLWithString:imageUrl];
        NSData *data = [[NSData alloc] initWithContentsOfURL:url];
        [cell.activityLoader startAnimating];
        
        //set your image on main thread.
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                [cell.imageView setImage:[UIImage imageWithData:data]];
            }else{
                
                [cell.imageView setImage:[UIImage imageNamed:@"emptyspace.png"]];
                
            }
            [cell.activityLoader stopAnimating];
            [cell.activityLoader setHidesWhenStopped:YES];
            
        });
        
    });
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
    detail.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:detail animated:YES completion:nil];
}

@end
