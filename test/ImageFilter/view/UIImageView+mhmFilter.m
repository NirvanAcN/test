//
//  UIImageView+mhmFilter.m
//  test
//
//  Created by 马浩萌 on 2021/1/7.
//

#import "UIImageView+mhmFilter.h"

@implementation UIImageView (mhmFilter)

-(void)mhm_setImage:(UIImage *)originImage withFilter:(MHMImageFilterName)filterName placeholderImage:(UIImage *)placeholderImage {
    self.image = placeholderImage ? placeholderImage : originImage;
    if (!filterName) return;
    dispatch_queue_t con_queue = dispatch_queue_create("image_filter_queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(con_queue, ^{
        UIImage * filteredImage = [originImage mhm_imageOfFilter:filterName];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = filteredImage;
        });
    });
}

@end
