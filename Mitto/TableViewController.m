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

@interface TableViewController () <UITableViewDataSource, UITableViewDelegate, FYXVisitDelegate, UIScrollViewDelegate>
{
    UIRefreshControl *refreshControl;
}

@property NSMutableArray *transmitters;
@property FYXVisitManager *visitManager;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)add:(id)sender;

@property int one;
@property int two;
@property int three;
@property int four;

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
    
    //initialise the refresh controller
    refreshControl = [[UIRefreshControl alloc] init];
    
    //set the title for pull request
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Release to update..."];
    
    //call he refresh function
    [refreshControl addTarget:self action:@selector(refreshMyTableView)
             forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refreshControl;
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
    //NSLog(@"############## didArrive: %@", visit);
}

- (void)didDepart:(FYXVisit *)visit
{
    //NSLog(@"############## didDepart: %@", visit);

   
}

- (void)receivedSighting:(FYXVisit *)visit updateTime:(NSDate *)updateTime RSSI:(NSNumber *)RSSI
{
   // NSLog(@"############## receivedSighting: %@", visit);
    
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
        UIImage *image = [UIImage imageNamed:@"apartment-2.png"];
        [cell.imageView setImage:image];
    } else if ([cell.label.text isEqualToString:@"Maroun"]){
        UIImage *image = [UIImage imageNamed:@"job2x.png"];
        [cell.imageView setImage:image];
    } else if ([cell.label.text isEqualToString:@"Quintin"]){
        UIImage *image = [UIImage imageNamed:@"bicycle2x.png"];
        [cell.imageView setImage:image];
    }  else if ([cell.label.text isEqualToString:@"Marlena"]){
        UIImage *image = [UIImage imageNamed:@"tesla.png"];
        [cell.imageView setImage:image];
    }

    
    return cell;
}

/*-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
   // DetailViewController *detail = [self.storyboard instantiateViewControllerWithIdentifier:@"Detail"];
    //detail.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    //[self presentViewController:detail animated:YES completion:nil];
}*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"detail"])
    {
        DetailViewController *detail = [segue destinationViewController];
    }
}



-(void)refreshMyTableView{
    
    //set the title while refreshing
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:@"Refreshing the TableView"];
    //set the date and time of refreshing
    NSDateFormatter *formattedDate = [[NSDateFormatter alloc]init];
    [formattedDate setDateFormat:@"MMM d, h:mm a"];
    NSString *lastupdated = [NSString stringWithFormat:@"Last Updated on %@",[formattedDate stringFromDate:[NSDate date]]];
    refreshControl.attributedTitle = [[NSAttributedString alloc]initWithString:lastupdated];
    [self.transmitters removeAllObjects];
    [self.tableView reloadData];
    //end the refreshing
    [refreshControl endRefreshing];
    
}

- (IBAction)add:(id)sender {
}
@end
