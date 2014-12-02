//
//  AnimatedLayer.h
//  ImageViewAnimation
//
//  Created by Pierre on 02/12/2014.
//  Copyright (c) 2014 Felginep. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef enum {
    StateLoading = 0,
    StateAnimating = 1
} State;

@interface AnimatedLayer : CALayer

@property (nonatomic) CGFloat percentage;
@property (nonatomic) State state;

- (void)startAnimating;
- (void)stopAnimating;

@end
