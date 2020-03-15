//
//  ViewController.m
//  PeerReview04
//
//  Created by David Auza on 15/03/20.
//  Copyright © 2020 David Auza. All rights reserved.
//

#import "ViewController.h"
#import "DistanceGetter/DGDistanceRequest.h"

@interface ViewController ()

@property (nonatomic) DGDistanceRequest *req;

@property (weak, nonatomic) IBOutlet UITextField *startLocation;

@property (weak, nonatomic) IBOutlet UITextField *endLocationA;
@property (weak, nonatomic) IBOutlet UILabel *distanceA;

@property (weak, nonatomic) IBOutlet UITextField *endLocationB;
@property (weak, nonatomic) IBOutlet UILabel *distanceB;

@property (weak, nonatomic) IBOutlet UITextField *endLocationC;
@property (weak, nonatomic) IBOutlet UILabel *distanceC;

@property (weak, nonatomic) IBOutlet UIButton *calculateButton;

@property (weak, nonatomic) IBOutlet UISegmentedControl *unitController;

@end

@implementation ViewController

- (IBAction)calculateButtonTap:(id)sender {
    
    self.calculateButton.enabled = NO;
    
    self.req = [DGDistanceRequest alloc];
    NSString *start = self.startLocation.text;
    NSString *destA = self.endLocationA.text;
    NSString *destB = self.endLocationB.text;
    NSString *destC = self.endLocationC.text;
    NSArray *dests = @[destA, destB, destC];
    
    self.req = [self.req initWithLocationDescriptions: dests sourceDescription: start];
    
    __weak ViewController *weakSelf = self;
    
    self.req.callback = ^void(NSArray * responses) {
        ViewController *strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        NSNull *badResult = [NSNull null];
        
        if (responses[0] != badResult) {
            double num;
            
            if (strongSelf.unitController.selectedSegmentIndex == 0) {
                num = [responses[0] floatValue];
                NSString *x = [NSString stringWithFormat: @"%.2f m", num];
                strongSelf.distanceA.text = x;
            } else if (strongSelf.unitController.selectedSegmentIndex == 1) {
                num = [responses[0] floatValue] / 1000.0;
                NSString *x = [NSString stringWithFormat: @"%.2f km", num];
                strongSelf.distanceA.text = x;
            } else {
                num = [responses[0] floatValue] / 1609;
                NSString *x = [NSString stringWithFormat: @"%.2f miles", num];
                strongSelf.distanceA.text = x;
            }
        } else {
            strongSelf.distanceA.text = @"Error";
        }
        
        strongSelf.req = nil;
        strongSelf.calculateButton.enabled = YES;
    };
    
    [self.req start];
}

@end
