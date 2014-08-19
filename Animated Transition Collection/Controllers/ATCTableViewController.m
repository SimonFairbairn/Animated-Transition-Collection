//
//  ATCTableViewController.m
//  Animated Transition Collection
//
//  Created by Simon Fairbairn on 11/10/2013.
//  Copyright (c) 2013 Simon Fairbairn. All rights reserved.
//

#import "ATCTableViewController.h"
#import "ATCDetailViewController.h"
#import "ATCTransitioningDelegate.h"

@interface ATCTableViewController ()

@property (nonatomic, strong) NSArray *transitionList;
@property (nonatomic, strong) ATCTransitioningDelegate *atcTransitioningDelegate;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UIStepper *durationStepper;

@property (weak, nonatomic) IBOutlet UILabel *directionLabel;
@property (weak, nonatomic) IBOutlet UIStepper *directionStepper;
@property (weak, nonatomic) IBOutlet UISwitch *interactiveSwitch;

@property (nonatomic, strong) NSIndexPath *selectedRow;

@end

@implementation ATCTableViewController

#pragma mark - Properties

-(NSArray *)transitionList {
    if ( !_transitionList ) {
        _transitionList = @[@[@"Simple Fade", @"Bounce", @"Squish", @"Float"], @[@"Simple Fade", @"Bounce", @"Squish"],@[@"Same As Presentation", @"Simple Fade", @"Bounce", @"Squish"]];
    }
    return _transitionList;
}

#pragma mark - Initialisation

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.selectedRow = [NSIndexPath indexPathForRow:0 inSection:2];
}

#pragma mark - Actions

- (IBAction)changeDuration:(UIStepper *)sender {
    self.durationLabel.text = [@"Duration: " stringByAppendingFormat:@"%1.1f", sender.value];
}

- (IBAction)changeDirection:(UIStepper *)sender {
    
    NSString *direction = @"Left";
    
    if ( sender.value == 2 ) {
        direction = @"Top";
    } else if ( sender.value == 3 ) {
        direction = @"Right";
    } else if ( sender.value == 4 ) {
        direction = @"Bottom";
    }
    
    self.directionLabel.text = [@"Direction: " stringByAppendingString:direction];
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.transitionList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.transitionList[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if ( indexPath.section == 2 ) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    if ( [indexPath isEqual:self.selectedRow]  )  {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    // Configure the cell...
    cell.textLabel.text = self.transitionList[indexPath.section][indexPath.row];
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title;
    
    switch (section) {
        case 0: {
            title = @"Push Transitions";
            break;
        }
        case 1: {
            title = @"Modal transitions";
            break;
        }
        case 2: {
            title = @"Dismissal transition";
            break;            
        }
        default: {
            break;
        }
    }
    
    return title;
}

#pragma mark - UITableViewDelegate 

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ( indexPath.section == 1 ) {
        
        // Configure the transitioning delegate
        [self setupTransitioningDelegateForIndexPath:indexPath];
        
        // Load the view controller to be presented
        ATCDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"detailViewController"];
        detailVC.modalPresentationStyle = UIModalPresentationCustom;
        detailVC.transitioningDelegate = self.atcTransitioningDelegate;
        
        // Present
        [self presentViewController:detailVC animated:YES completion:nil];
        
    } else if ( indexPath.section == 2 ) {
        
        // If we're in the dismissal section, make a note of what's selected
        if ( self.selectedRow ) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:self.selectedRow];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        self.selectedRow = indexPath;
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)setupTransitioningDelegateForIndexPath:(NSIndexPath *)indexPath {

    // Are we using a different dismissal to presentation? Row 0 = the same as presentation
    NSInteger dismissalType = ( self.selectedRow.row == 0 ) ? indexPath.row : self.selectedRow.row - 1;
    
    // Set up our delegate
    self.atcTransitioningDelegate = [[ATCTransitioningDelegate alloc] initWithPresentationTransition:indexPath.row
                                                                                 dismissalTransition:dismissalType
                                                                                           direction:self.directionStepper.value
                                                                                            duration:self.durationStepper.value];
    
    // Are we going interactive?
    self.atcTransitioningDelegate.interactive = self.interactiveSwitch.on;
}


#pragma mark - Navigation

// Make sure we're selecting one of the navigation options if we're segueing 
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
    if ( ip.section != 0 ) return NO;
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
    
    // Set 'er up
    [self setupTransitioningDelegateForIndexPath:ip];
    
    // Do the business
    self.navigationController.delegate = self.atcTransitioningDelegate;
}


@end
