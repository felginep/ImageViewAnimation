//
//  ViewController.m
//  ImageViewAnimation
//
//  Created by Pierre on 02/12/2014.
//  Copyright (c) 2014 Felginep. All rights reserved.
//

#import "ViewController.h"
#import "AnimatedLayer.h"

@interface ViewController () {
    AnimatedLayer * _animatedLayer;
    NSTimer * _timer;
    CGFloat _percentage;
}
@end

@implementation ViewController

- (void)dealloc {
    _animatedLayer = nil;
    [_timer invalidate], _timer = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageView.backgroundColor = [UIColor darkGrayColor];
    self.imageView.image = nil;

    _animatedLayer = [[AnimatedLayer alloc] init];
    _animatedLayer.frame = self.view.bounds;
    [_animatedLayer setNeedsDisplay];

    self.imageView.layer.mask = _animatedLayer;
    _percentage = 0;
}

- (IBAction)animate:(id)sender {
    self.imageView.image = nil;
    _percentage = _animatedLayer.percentage = 0;
    _timer = [NSTimer timerWithTimeInterval:0.01f target:self selector:@selector(_handleTimer:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}


- (void)_handleTimer:(id)sender {
    _percentage += 0.01f;
    _animatedLayer.percentage = _percentage;
    if (_percentage >= 1.0f) {
        [_animatedLayer startAnimating];
        self.imageView.image = [UIImage imageNamed:@"image.jpg"];
        [_timer invalidate];
        _timer = nil;
    }
}




@end
