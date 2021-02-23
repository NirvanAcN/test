//
//  ImageFilterCollectionViewCell.m
//  test
//
//  Created by 马浩萌 on 2021/1/6.
//

#import "ImageFilterCollectionViewCell.h"
#import <Masonry/Masonry.h>

@implementation ImageFilterCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [UIImageView new];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        _imageView.backgroundColor = UIColor.whiteColor;
        [self.contentView addSubview:_imageView];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return self;
}

-(void)mhm_setImage:(UIImage *)image withFilterName:(NSString *)filterName {
    _imageView.image = image;
    __block UIImage * newImage = [UIImage imageNamed:@"niu.jpg"];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @try {
            CIFilter* filter = [CIFilter filterWithName:filterName];
            CIImage * beginImage = [CIImage imageWithCGImage:image.CGImage];
            [filter setValue:beginImage forKey:kCIInputImageKey];
            UIImage * tmpImage = [UIImage imageWithCIImage:filter.outputImage];
            CGImageRef cgref = [tmpImage CGImage];
            CIImage *cim = [tmpImage CIImage];
            if (cim == nil && cgref == NULL) {
                
            } else {
                newImage = tmpImage;
            }
        } @catch (NSException *exception) {
            
        } @finally {
            dispatch_async(dispatch_get_main_queue(), ^{
                self->_imageView.image = newImage;
            });
        }
    });
}

@end
