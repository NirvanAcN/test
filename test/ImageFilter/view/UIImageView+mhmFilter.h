//
//  UIImageView+mhmFilter.h
//  test
//
//  Created by 马浩萌 on 2021/1/7.
//

#import <UIKit/UIKit.h>
#import "UIImage+mhmFilter.h"

NS_ASSUME_NONNULL_BEGIN


@interface UIImageView (mhmFilter)

-(void)mhm_setImage:(nonnull UIImage *)originImage withFilter:(nullable MHMImageFilterName)filterName placeholderImage:(nullable UIImage *)placeholderImage;

@end

NS_ASSUME_NONNULL_END
