//
//  AnimatedLayer.m
//  ImageViewAnimation
//
//  Created by Pierre on 02/12/2014.
//  Copyright (c) 2014 Felginep. All rights reserved.
//

#import "AnimatedLayer.h"
#import <UIKit/UIKit.h>

@interface AnimatedLayer () {
    CADisplayLink * _displayLink;
    CGFloat _smallCircleRadius;
    CGFloat _bigCircleRadius;
    CGFloat _delayCount;
}
@end

#define DURATION 0.2f
#define DELAY 0.5f
#define MIN_RADIUS 30.0f
#define MIN_SMALL_RADIUS 24.0f

@implementation AnimatedLayer

- (instancetype)init {
    if (self = [super init]) {
        self.contentsScale = [UIScreen mainScreen].scale;
        [self _reset];
    }
    return self;
}

- (void)startAnimating {
    _state = StateAnimating;
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(_redraw)];
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stopAnimating {
    [_displayLink invalidate], _displayLink = nil;
}

- (void)setPercentage:(CGFloat)percentage {
    _percentage = percentage;
    if (_percentage >= 100.0f) {
        self.state = StateAnimating;
    } else if (percentage == 0) {
        [self _reset];
    }
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx {
    if (self.state == StateLoading) {
        CGContextSetLineWidth(ctx, 6.0f);
        CGContextSetLineJoin(ctx, kCGLineJoinRound);
        CGContextBeginPath(ctx);
        CGContextAddArc(ctx, self.bounds.size.width / 2.0f, self.bounds.size.height / 2.0f, MIN_RADIUS, 0, self.percentage * 2 * M_PI, NO);
        CGContextStrokePath(ctx);
    } else if (self.state == StateAnimating) {
        [self _drawRectWithRadius:_bigCircleRadius inContext:ctx];
        CGContextSetBlendMode(ctx, kCGBlendModeClear);
        [self _drawRectWithRadius:_smallCircleRadius inContext:ctx];
    }
}

#pragma mark - Private methods

- (void)_drawRectWithRadius:(CGFloat)radius inContext:(CGContextRef)ctx {
    CGFloat diameter = 2 * radius;
    CGRect rect = CGRectMake((self.bounds.size.width - diameter) / 2.0f,
                             (self.bounds.size.height - diameter) / 2.0f,
                             diameter,
                             diameter);
    CGContextFillEllipseInRect(ctx, rect);
}

- (void)_redraw {
    if (_delayCount < DELAY) {
        _delayCount += 1 / 60.0f;
        return;
    }
    
    CGFloat maxSize = MAX(self.bounds.size.width, self.bounds.size.height);
    CGFloat maxRadius = sqrtf(maxSize * maxSize / 2);
    CGFloat bigStep = (maxRadius - MIN_RADIUS) / (DURATION * 60);
    _bigCircleRadius += bigStep;

    CGFloat smallStep = MIN_SMALL_RADIUS / (DURATION * 60);
    _smallCircleRadius -= smallStep;

    if (_bigCircleRadius >= maxRadius ||  _bigCircleRadius <= 0) { // end animation
        [self stopAnimating];
    }

    [self setNeedsDisplay];
}

- (void)_reset {
    _smallCircleRadius = MIN_SMALL_RADIUS;
    _bigCircleRadius = MIN_RADIUS;
    _percentage = 0;
    _delayCount = 0;
    _state = StateLoading;
}

@end
