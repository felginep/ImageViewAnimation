//
//  UIImageView+Animation.m
//  ImageViewAnimation
//
//  Created by Pierre on 04/12/2014.
//  Copyright (c) 2014 Felginep. All rights reserved.
//

#import "UIImageView+Animation.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (Animation)

- (void)animateImageWithURL:(NSURL *)url {
    __block CAShapeLayer * shapeLayer;
    if (!self.layer.mask) {
        shapeLayer = [[CAShapeLayer alloc] init];
        CGFloat size = 40.0;
        shapeLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0.5f * (self.bounds.size.width - size), 0.5f * (self.bounds.size.height - size), size, size)].CGPath;
        shapeLayer.lineWidth = 2.0f;
        shapeLayer.strokeColor = [UIColor blackColor].CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        shapeLayer.strokeEnd = 0;
        self.layer.mask = shapeLayer;
    }

    [self sd_setImageWithURL:url placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        CGFloat percentage = (CGFloat)receivedSize / (CGFloat)expectedSize;
        NSLog(@"percentage => %f", percentage);
        if (percentage > 0) {
            shapeLayer.strokeEnd = percentage;
        }

    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        NSLog(@"completed");
        self.image = image;
        if (cacheType == SDImageCacheTypeDisk || cacheType == SDImageCacheTypeMemory) { // NO animation
            self.layer.mask = nil;
            shapeLayer = nil;
            return ;
        }

        shapeLayer.strokeEnd = 0;
        shapeLayer.strokeColor = [UIColor clearColor].CGColor;
        shapeLayer.fillColor = [UIColor blackColor].CGColor;

        CGFloat size = 40.0;
        CGRect rect = CGRectMake(0.5f * (self.bounds.size.width - size), 0.5f * (self.bounds.size.height - size), size, size);

        UIBezierPath * path = [UIBezierPath bezierPathWithOvalInRect:rect];
        rect = CGRectInset(rect, 2, 2);
        [path appendPath:[UIBezierPath bezierPathWithOvalInRect:rect]];
        shapeLayer.path = path.CGPath;
        shapeLayer.fillRule = kCAFillRuleEvenOdd;

        CGFloat maxSize = MAX(self.bounds.size.width, self.bounds.size.height);
        CGFloat maxRadius = sqrtf(maxSize * maxSize / 2);
        rect = CGRectMake(0.5f * (self.bounds.size.width - 2 * maxRadius), 0.5f * (self.bounds.size.height - 2 * maxRadius), 2 * maxRadius, 2 * maxRadius);
        path = [UIBezierPath bezierPathWithOvalInRect:rect];
        rect = CGRectMake(0.5f * self.bounds.size.width, 0.5f * self.bounds.size.height, 0, 0);
        [path appendPath:[UIBezierPath bezierPathWithOvalInRect:rect]];

        [CATransaction begin]; {
            [CATransaction setAnimationDuration:3.3f];
            [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
            [CATransaction setCompletionBlock:^{
                NSLog(@"animationCompleted");
                shapeLayer = nil;
                self.layer.mask = nil;
            }];

            CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"path"];
            animation.beginTime = CACurrentMediaTime() + 0.3f;
            animation.fromValue = (__bridge id)(shapeLayer.path);
            animation.toValue = (__bridge id)path.CGPath;
            animation.delegate = self;
            animation.removedOnCompletion = NO;
            animation.fillMode = kCAFillModeForwards;

            [shapeLayer addAnimation:animation forKey:@"pathAnimation"];
        } [CATransaction commit];


    }];
}

@end
