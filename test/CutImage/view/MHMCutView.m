//
//  MHMCutView.m
//  test
//
//  Created by 马浩萌 on 2021/1/9.
//

#import "MHMCutView.h"
#import "MHMCutMaskView.h"

@import Masonry;
@import AVFoundation;

@interface MHMCutView ()

@property (nonatomic, strong) UIImageView * containImageView;

@end

static const CGFloat kDefaultInsetValue = 20;

@implementation MHMCutView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

//- (void)layoutSubviews {
//    self.containImageView.frame = (CGRect){CGPointZero ,self.frame.size};
//}

#pragma mark - UIImageView
-(UIImageView *)containImageView {
    if (!_containImageView) {
        _containImageView = [UIImageView new];
        _containImageView.userInteractionEnabled = YES;
        _containImageView.contentMode = UIViewContentModeScaleAspectFit;
        _containImageView.backgroundColor = UIColor.cyanColor;
        [self addSubview:_containImageView];
    }
    return _containImageView;
}

-(void)setCImage:(UIImage *)cImage {
    _cImage = cImage;
    self.containImageView.image = cImage;
    
    [self layoutIfNeeded];
    CGSize selfSize = self.bounds.size;
    CGSize containSize = CGSizeMake(selfSize.width - 2 * kDefaultInsetValue, selfSize.height - 2 * kDefaultInsetValue); // 获取实际承载的size
    // 以宽为基准进行计算
    CGSize cImageSize = cImage.size;
    // 计算宽方向上的缩放比例
    CGFloat scaleOfWidth = cImageSize.width / containSize.width;
    // 计算展示的高度
    CGFloat showedHeight = cImageSize.height / scaleOfWidth;
    // 判断展示的高度是否超出contain view
    CGFloat imageMultiplie = cImageSize.width / cImageSize.height;
    if (showedHeight > containSize.height) { // 超出则以高为基准进行布局
        [self.containImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.top.bottom.equalTo(self).inset(kDefaultInsetValue);
            make.width.equalTo(self.containImageView.mas_height).multipliedBy(imageMultiplie);
        }];
    } else {
        [self.containImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.leading.trailing.equalTo(self).inset(kDefaultInsetValue);
            make.width.equalTo(self.containImageView.mas_height).multipliedBy(imageMultiplie);
        }];
    }
    [self layoutIfNeeded];
    
    CGRect foo = AVMakeRectWithAspectRatioInsideRect(cImage.size, self.containImageView.bounds);
    NSLog(@"%@", NSStringFromCGRect(foo));
    
    [self.containImageView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    CGRect newFrame = CGRectMake(foo.origin.x, foo.origin.y, foo.size.width - 200, foo.size.height - 100);
    MHMCutMaskView * viii = [[MHMCutMaskView alloc] initWithFrame:newFrame];
    viii.backgroundColor = UIColor.clearColor;
    //    viii.alpha = 0.5;
    [self.containImageView addSubview:viii];
    
    _containImageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
}

#pragma mark - xImage
-(void)setXImage:(UIImage *)xImage {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^{
        self->_xImage = xImage;
        self.containImageView.image = xImage;
        self.containImageView.frame = [self calculateImageFrameByWindowSize:xImage.size];
        self.containImageView.center = [self convertPoint:self.center fromView:self.superview];
    });
}

-(CGRect)calculateImageFrameByWindowSize:(CGSize)windowSize {
    [self layoutIfNeeded];
    CGSize selfSize = self.bounds.size;
    CGSize containSize = CGSizeMake(selfSize.width - 2 * kDefaultInsetValue, selfSize.height - 2 * kDefaultInsetValue); // 获取去除边界后的尺寸（最大展示尺寸）
    // 计算宽方向上的缩放比例
    CGFloat scaleOfWidth = windowSize.width / containSize.width;
    // 计算展示的高度
    CGFloat showedHeight = windowSize.height / scaleOfWidth;
    CGFloat imageMultiplie = windowSize.width / windowSize.height;
    CGRect result;
    // 判断展示的高度是否超出contain view
    result.size.width =  showedHeight > containSize.height ? containSize.height * imageMultiplie : containSize.width;
    result.size.height = showedHeight > containSize.height ? containSize.height : containSize.width / imageMultiplie;
    return result;
}

@end
