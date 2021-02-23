//
//  UIImage+mhmFilter.m
//  test
//
//  Created by 马浩萌 on 2021/1/6.
//

#import "UIImage+mhmFilter.h"

@implementation UIImage (mhmFilter)

-(UIImage *)mhm_imageOfFilter:(MHMImageFilterName)filterName {
    CIFilter* filter = [CIFilter filterWithName:filterName];
    CIImage * beginImage = [CIImage imageWithCGImage:self.CGImage];
    [filter setValue:beginImage forKey:kCIInputImageKey];
    CIImage * outputImage = filter.outputImage;
    struct CGImage * resultOutputImage = [[CIContext contextWithOptions:nil] createCGImage:outputImage fromRect:outputImage.extent];
    UIImage * newImage = [UIImage imageWithCGImage:resultOutputImage];
    return newImage;
}

@end

MHMImageFilterName const MHMImageFilterNameCIColorPosterize = @"CIColorPosterize";
MHMImageFilterName const MHMImageFilterNameCIColorMonochrome = @"CIMaximumComponent";
MHMImageFilterName const MHMImageFilterNameCIMaximumComponent = @"CIPhotoEffectMono";
MHMImageFilterName const MHMImageFilterNameCIPhotoEffectMono = @"CIFalseColor";
MHMImageFilterName const MHMImageFilterNameCIFalseColor = @"CIComicEffect";
MHMImageFilterName const MHMImageFilterNameCIComicEffect = @"CIHatchedScreen";
MHMImageFilterName const MHMImageFilterNameCIHatchedScreen = @"CIThermal";
MHMImageFilterName const MHMImageFilterNameCIThermal = @"CIMorphologyGradient";
MHMImageFilterName const MHMImageFilterNameCIMorphologyGradient = @"CIColorThreshold";
MHMImageFilterName const MHMImageFilterNameCIColorThreshold = @"CICircularScreen";
MHMImageFilterName const MHMImageFilterNameCICircularScreen = @"CISpotColor";
MHMImageFilterName const MHMImageFilterNameCISpotColor = @"CIPhotoEffectTonal";
MHMImageFilterName const MHMImageFilterNameCIPhotoEffectTonal = @"CILineOverlay";
MHMImageFilterName const MHMImageFilterNameCILineOverlay = @"CIColorInvert";
MHMImageFilterName const MHMImageFilterNameCIColorInvert = @"CIColorPosterize";
