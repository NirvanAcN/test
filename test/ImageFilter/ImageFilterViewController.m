//
//  ImageFilterViewController.m
//  test
//
//  Created by 马浩萌 on 2021/1/6.
//

#import "ImageFilterViewController.h"
#import "UIImage+mhmFilter.h"
#import "ImageFilterCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import "UIImageView+mhmFilter.h"
#import <SDWebImage/SDWebImage.h>

@interface ImageFilterViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@end

@implementation ImageFilterViewController
{
    UICollectionView * _collectionView;
    NSArray * _myFilters;
    UIImage * _image;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.whiteColor;
    
    _myFilters = @[
                   @"CIColorPosterize",
                   @"CIColorMonochrome",
                   @"CIMaximumComponent",
                   @"CIPhotoEffectMono",
//                   @"CIPointillize",
                   @"CIFalseColor",
                   @"CIComicEffect",
                   @"CIHatchedScreen",
                   @"CIThermal",
                   @"CIMorphologyGradient",
                   @"CIColorThreshold",
                   @"CICircularScreen",
                   @"CISpotColor",
                   @"CIPhotoEffectTonal",
                   @"CILineOverlay",
                   @"CIColorInvert"];
    
    _image = [UIImage imageNamed:@"方形源鹅.png"];
//    _originImageView.image = image;
//    _imageView.image = [image _mhm_imageOfFilter:myFilter[myFilter.count - 1]];
    
    UICollectionViewFlowLayout * fl = [UICollectionViewFlowLayout new];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:fl];
    _collectionView.backgroundColor = [UIColor cyanColor];
    [_collectionView registerClass:[ImageFilterCollectionViewCell class] forCellWithReuseIdentifier:@"ImageFilterCollectionViewCell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.view);
        make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
    }];
}

-(NSArray<NSString *> *)prepateDatasource {
    NSArray<NSString *> * allCategories = @[
        kCICategoryDistortionEffect,
        kCICategoryGeometryAdjustment,
        kCICategoryCompositeOperation,
        kCICategoryHalftoneEffect,
        kCICategoryColorAdjustment,
        kCICategoryColorEffect,
        kCICategoryTransition,
        kCICategoryTileEffect,
        kCICategoryGenerator,
        kCICategoryReduction,
        kCICategoryGradient,
        kCICategoryStylize,
        kCICategorySharpen,
        kCICategoryBlur,
        kCICategoryVideo,
        kCICategoryStillImage,
        kCICategoryInterlaced,
        kCICategoryNonSquarePixels,
        kCICategoryHighDynamicRange,
        kCICategoryBuiltIn,
        kCICategoryFilterGenerator,
    ];
    NSMutableSet * mSet = [NSMutableSet set];
    [allCategories enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [[CIFilter filterNamesInCategory:obj] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [mSet addObject:obj];
        }];
    }];
    return [mSet allObjects];
}

- (IBAction)buttonClick:(UIButton *)sender {

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"*** %@", _myFilters[indexPath.row]);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _myFilters.count;
}

-(__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageFilterCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageFilterCollectionViewCell" forIndexPath:indexPath];
    [cell.imageView mhm_setImage:_image withFilter:_myFilters[indexPath.row] placeholderImage:[UIImage imageNamed:@"niu.jpg"]];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@""]];
//    [cell mhm_setImage:_image withFilterName:_myFilters[indexPath.row]];
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return (CGSize){200, 200};
}

@end


/*
 CICategoryColorEffect - CIMaximumComponent
 CICategoryColorEffect - CIMinimumComponent
 CICategoryColorEffect - CIPhotoEffectChrome
 CICategoryColorEffect - CIPhotoEffectFade
 CICategoryColorEffect - CIPhotoEffectInstant
 CICategoryColorEffect - CIPhotoEffectMono
 CICategoryColorEffect - CIPhotoEffectNoir
 CICategoryColorEffect - CIPhotoEffectProcess
 CICategoryColorEffect - CIPhotoEffectTonal
 CICategoryColorEffect - CIPhotoEffectTransfer
 CICategoryColorEffect - CISepiaTone
 CICategoryColorEffect - CIThermal
 CICategoryColorEffect - CIXRay
 CICategoryStylize - CIBloom
 CICategoryStylize - CIComicEffect
 CICategoryStylize - CICrystallize
 CICategoryStylize - CIDepthOfField
 CICategoryStylize - CIEdges
 CICategoryStylize - CIGaborGradients
 CICategoryStylize - CIHeightFieldFromMask
 CICategoryStylize - CIHexagonalPixellate
 CICategoryStylize - CILineOverlay
 CICategoryStylize - CIPixellate
 CICategoryStylize - CIPointillize
 CICategoryStylize - CISpotColor 接近漫画
 CICategoryStylize - CISpotLight
 CICategoryBlur - CIBokehBlur
 CICategoryBlur - CIBoxBlur
 CICategoryBlur - CIDiscBlur
 CICategoryBlur - CIGaussianBlur
 CICategoryBlur - CIMedianFilter
 CICategoryBlur - CIMorphologyGradient
 CICategoryBlur - CIMorphologyRectangleMaximum
 CICategoryBlur - CIMorphologyRectangleMinimum
 CICategoryBlur - CIMotionBlur
 CICategoryBlur - CIZoomBlur
 CICategoryVideo - CIBloom
 CICategoryVideo - CIComicEffect
 CICategoryVideo - CICrystallize
 CICategoryVideo - CIDepthOfField
 CICategoryVideo - CIDiscBlur
 CICategoryVideo - CIEdges
 CICategoryVideo - CIGaborGradients
 CICategoryVideo - CIGaussianBlur
 CICategoryVideo - CIGloom
 CICategoryVideo - CIHeightFieldFromMask
 CICategoryVideo - CIHexagonalPixellate
 CICategoryVideo - CILineOverlay
 CICategoryVideo - CIMaximumComponent
 CICategoryVideo - CIMedianFilter
 CICategoryVideo - CIMinimumComponent
 CICategoryVideo - CIMorphologyGradient
 CICategoryVideo - CIMorphologyRectangleMaximum
 CICategoryVideo - CIMorphologyRectangleMinimum
 CICategoryVideo - CIMotionBlur
 CICategoryVideo - CINinePartStretched
 CICategoryVideo - CIPhotoEffectChrome
 CICategoryVideo - CIPhotoEffectFade
 CICategoryVideo - CIPhotoEffectInstant
 CICategoryVideo - CIPhotoEffectMono
 CICategoryVideo - CIPhotoEffectNoir
 CICategoryVideo - CIPhotoEffectProcess
 CICategoryVideo - CIPhotoEffectTonal
 CICategoryVideo - CIPhotoEffectTransfer
 CICategoryVideo - CIPixellate
 CICategoryVideo - CIPointillize
 CICategoryVideo - CISepiaTone
 CICategoryVideo - CISpotColor
 CICategoryVideo - CISpotLight
 CICategoryVideo - CIThermal
 CICategoryVideo - CIVignetteEffect
 CICategoryVideo - CIXRay
 CICategoryVideo - CIZoomBlur
 CICategoryStillImage - CIBloom
 CICategoryStillImage - CIBokehBlur
 CICategoryStillImage - CIBoxBlur
 CICategoryStillImage - CIComicEffect
 CICategoryStillImage - CICrystallize
 CICategoryStillImage - CIPhotoEffectChrome
 CICategoryStillImage - CISpotColor
 
 */
