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

@end

@implementation ATCTableViewController

#pragma mark - Properties

-(NSArray *)transitionList {
    if ( !_transitionList ) {
        _transitionList = @[@[@"Simple Fade (Push)", @"Bounce (Push)"], @[@"Simple Fade (Modal)", @"Bounce (Modal)"]];
    }
    return _transitionList;
}

#pragma mark - Initialisation

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillLayoutSubviews {

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
    // Return the number of rows in the section.
    return [self.transitionList[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"listCell" forIndexPath:indexPath];
    
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
        if ( indexPath.row == 0 ) {
            self.atcTransitioningDelegate = [[ATCTransitioningDelegate alloc] initWithTransitionType:ATCTransitionAnimationTypeFade direction:self.directionStepper.value duration:self.durationStepper.value ];
        } else if ( indexPath.row == 1 ) {
            
            self.atcTransitioningDelegate = [[ATCTransitioningDelegate alloc] initWithTransitionType:ATCTransitionAnimationTypeBounce direction:self.directionStepper.value duration:self.durationStepper.value ];
            

        }

        self.atcTransitioningDelegate.interactive = self.interactiveSwitch.on;

        
        ATCDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"detailViewController"];
        detailVC.modalPresentationStyle = UIModalPresentationCustom;
        detailVC.transitioningDelegate = self.atcTransitioningDelegate;
    
        [self presentViewController:detailVC animated:YES completion:nil];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Navigation


-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
    if ( ip.section == 1 ) return NO;
    return YES;
}

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSIndexPath *ip = [self.tableView indexPathForSelectedRow];
    
    if ( ip.section == 0 ) {
        if ( ip.row == 0 ) {
            self.atcTransitioningDelegate = [[ATCTransitioningDelegate alloc] initWithTransitionType:ATCTransitionAnimationTypeFade direction:self.directionStepper.value duration:self.durationStepper.value ];
        } else if ( ip.row == 1 ) {
            self.atcTransitioningDelegate = [[ATCTransitioningDelegate alloc] initWithTransitionType:ATCTransitionAnimationTypeBounce direction:self.directionStepper.value duration:self.durationStepper.value ];
            
        }
    }
    self.atcTransitioningDelegate.interactive = self.interactiveSwitch.on;
    self.navigationController.delegate = self.atcTransitioningDelegate;
    
}


@end
