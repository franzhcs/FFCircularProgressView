//
//  ViewController.m
//  FFCircularProgressBar
//
//  Created by Fabiano Francesconi on 16/07/13.
//  Copyright (c) 2013 Fabiano Francesconi. All rights reserved.
//

#import "ViewController.h"

#import "FFCircularProgressView.h"

@interface ViewController ()
@property (strong) FFCircularProgressView *circularPV;
@end

@implementation ViewController

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
	// Do any additional setup after loading the view.
    
    self.circularPV = [[FFCircularProgressView alloc] initWithFrame:CGRectMake(40, 40, 80, 80)];
    _circularPV.center = self.view.center;
    
    [self.view addSubview:_circularPV];

    double delayInSeconds = 1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        dispatch_async(dispatch_get_main_queue(), ^{
            [_circularPV startSpinProgressBackgroundLayer];
//            for (float i=0; i<1.1; i+=0.01F) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [_circularPV setProgress:i];
//                });
//                usleep(10000);
//            }            
        });
    });
    
    delayInSeconds = 5;
    popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_circularPV stopSpinProgressBackgroundLayer];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
