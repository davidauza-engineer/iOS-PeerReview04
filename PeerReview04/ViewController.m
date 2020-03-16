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

@property (weak, nonatomic) IBOutlet UITextField *endLocationD;
@property (weak, nonatomic) IBOutlet UILabel *distanceD;

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
    NSString *destD = self.endLocationD.text;
    NSArray *dests = @[destA, destB, destC, destD];
    
    self.req = [self.req initWithLocationDescriptions: dests sourceDescription: start];
    
    __weak ViewController *weakSelf = self;
    
    self.req.callback = ^void(NSArray * responses) {
        ViewController *strongSelf = weakSelf;
        if (!strongSelf) {
            return;
        }
        
        NSNull *badResult = [NSNull null];
        NSArray *distanceLabels = @[strongSelf.distanceA, strongSelf.distanceB, strongSelf.distanceC, strongSelf.distanceD];
        
        for (int i = 0; i < [responses count]; i++) {
            UILabel *currentLabel = distanceLabels[i];
            if (responses[i] != badResult) {
                double distance = [responses[i] floatValue];
                NSString *distanceString;
                switch (strongSelf.unitController.selectedSegmentIndex) {
                    case 0:
                        distanceString = [NSString stringWithFormat: @"%.2f m", distance];
                        break;
                    
                    case 1:
                        distance /= 1000.0;
                        distanceString = [NSString stringWithFormat: @"%.2f km", distance];
                        break;
                        
                    case 2:
                        distance /= 1609.0;
                        distanceString = [NSString stringWithFormat: @"%.2f miles", distance];
                        break;
                }
                currentLabel.text = distanceString;
            } else {
                currentLabel.text = @"Error";
            }
        }
        
        strongSelf.req = nil;
        strongSelf.calculateButton.enabled = YES;
    };
    
    [self.req start];
}

@end
