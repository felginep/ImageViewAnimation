//
//  ViewController.m
//  ImageViewAnimation
//
//  Created by Pierre on 02/12/2014.
//  Copyright (c) 2014 ;. All rights reserved.
//

#import "ViewController.h"
#import "SDImageCache.h"
#import "UIImageView+Animation.h"

@implementation ViewController

- (IBAction)animate:(id)sender {
    SDImageCache * imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];

    [self.imageView animateImageWithURL:[NSURL URLWithString:@"http://www.designbolts.com/wp-content/uploads/2014/09/Colorful-Apple-iPhone-6-Plus-wallpaper1.jpg"]];
}

@end
