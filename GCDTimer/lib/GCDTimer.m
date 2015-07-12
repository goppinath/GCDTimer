//
//  GCDTimer.m
//  GCDTimer
//
//  Created by Goppinath Thurairajah on 12.07.15.
//  Copyright (c) 2015 Goppinath Thurairajah. http://goppinath.com
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "GCDTimer.h"

@interface GCDTimer ()

@property (copy, nonatomic) void (^block)();
@property (strong, nonatomic) dispatch_source_t timer;

@property (nonatomic) BOOL repeats;

@end

@implementation GCDTimer

- (instancetype)initWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats queue:(dispatch_queue_t)queue block:(void (^)())block {
    
    if (self = [super init]) {
        
        NSParameterAssert(block);
        
        _repeats = repeats;
        _block = block;
        
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue?queue:dispatch_get_main_queue());
        
        dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, seconds * NSEC_PER_SEC), seconds * NSEC_PER_SEC, _tolerance * NSEC_PER_SEC);
        
        __weak typeof(self) weakSelf = self;
        
        dispatch_source_set_event_handler(_timer, ^{
            
            if (!repeats) {
                
                dispatch_source_cancel(weakSelf.timer);
            }
            
            if (block) {
                
                block();
            }
        });
        
        dispatch_resume(_timer);
    }
    
    return self;
}

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats queue:(dispatch_queue_t)queue block:(void (^)())block {
    
    return [[self alloc] initWithTimeInterval:seconds repeats:repeats queue:queue block:block];
}

+ (instancetype)timerWithTimeInterval:(NSTimeInterval)seconds repeats:(BOOL)repeats block:(void (^)())block {
    
    return [[self alloc] initWithTimeInterval:seconds repeats:repeats queue:nil block:block];
}

- (void)fire {
    
    if (!_repeats) {
        
        dispatch_source_cancel(_timer);
    }
    
    if (_block) {
        
        _block();
    }
}

- (void)invalidate {
    
    if (_timer) {
        
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
    
    _block = nil;
}

- (void)dealloc {
    
    [self invalidate];
}

@end
