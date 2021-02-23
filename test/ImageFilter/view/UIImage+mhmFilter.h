//
//  UIImage+mhmFilter.h
//  test
//
//  Created by 马浩萌 on 2021/1/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NSString * MHMImageFilterName NS_EXTENSIBLE_STRING_ENUM;

@interface UIImage (mhmFilter)

-(UIImage *)mhm_imageOfFilter:(MHMImageFilterName)filterName;

@end

FOUNDATION_EXPORT MHMImageFilterName const MHMImageFilterNameCIColorPosterize;
FOUNDATION_EXPORT MHMImageFilterName const MHMImageFilterNameCIColorMonochrome;
FOUNDATION_EXPORT MHMImageFilterName const MHMImageFilterNameCIMaximumComponent;
FOUNDATION_EXPORT MHMImageFilterName const MHMImageFilterNameCIPhotoEffectMono;
FOUNDATION_EXPORT MHMImageFilterName const MHMImageFilterNameCIFalseColor;
FOUNDATION_EXPORT MHMImageFilterName const MHMImageFilterNameCIComicEffect;
FOUNDATION_EXPORT MHMImageFilterName const MHMImageFilterNameCIHatchedScreen;
FOUNDATION_EXPORT MHMImageFilterName const MHMImageFilterNameCIThermal;
FOUNDATION_EXPORT MHMImageFilterName const MHMImageFilterNameCIMorphologyGradient;
FOUNDATION_EXPORT MHMImageFilterName const MHMImageFilterNameCIColorThreshold;
FOUNDATION_EXPORT MHMImageFilterName const MHMImageFilterNameCICircularScreen;
FOUNDATION_EXPORT MHMImageFilterName const MHMImageFilterNameCISpotColor;
FOUNDATION_EXPORT MHMImageFilterName const MHMImageFilterNameCIPhotoEffectTonal;
FOUNDATION_EXPORT MHMImageFilterName const MHMImageFilterNameCILineOverlay;
FOUNDATION_EXPORT MHMImageFilterName const MHMImageFilterNameCIColorInvert;

NS_ASSUME_NONNULL_END
