//
//  ViewController.m
//  GCDTimer
//
//  Created by Goppinath Thurairajah on 12.07.15.
//  Copyright (c) 2015 Goppinath Thurairajah. All rights reserved.
//

#import "ViewController.h"

#import "GCDTimer.h"

@interface ViewController ()

@end

@implementation ViewController {
    
    GCDTimer *timer_;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCallback:) userInfo:nil repeats:NO];
//        
//        [[NSRunLoop currentRunLoop] run];
//    });
//    
//    [[NSOperationQueue new] addOperationWithBlock:^{
//        
//        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerCallback:) userInfo:nil repeats:NO];
//    }];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        timer_ = [GCDTimer timerWithTimeInterval:2 repeats:YES queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) block:^{
            
            NSLog(@"Timer callback");
        }];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)timerCallback:(NSTimer *)timer {
    
    NSLog(@"Timer callback");
}

@end
