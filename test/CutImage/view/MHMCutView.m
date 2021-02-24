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

@interface MHMCutView () <MHMCutMaskViewDelegate>

@property (nonatomic, strong) UIImageView * containImageView;

@property (nonatomic, strong) MHMCutMaskView * maskView;

@end

static const CGFloat kDefaultInsetValue = 20;

@implementation MHMCutView
{
    CGRect _windowsAnchor;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)testAction {
//    [self cropActionByWidth:0 andHeight:0];
    self.maskView.frame = _windowsAnchor;
}

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

#pragma mark - mask view
-(MHMCutMaskView *)maskView {
    if (!_maskView) {
        _maskView = [MHMCutMaskView new];
        [self addSubview:_maskView];
        [self bringSubviewToFront:_maskView];
        _maskView.backgroundColor = UIColor.orangeColor;
        _maskView.delegate = self;
        _maskView.alpha = 0.4;
    }
    return _maskView;
}

#pragma mark - xImage
-(void)setXImage:(UIImage *)xImage {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0), dispatch_get_main_queue(), ^{
        self->_xImage = xImage;
        self.containImageView.image = xImage;
        self.containImageView.frame = [self calculateImageFrameByWindowSize:xImage.size];
        self.containImageView.center = [self convertPoint:self.center fromView:self.superview];
        self->_windowsAnchor = self.containImageView.frame;
    });
}

-(CGRect)calculateImageFrameByWindowSize:(CGSize)windowSize {
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

#pragma mark - crop action
-(void)cropActionByWidth:(CGFloat)changedWidth andHeight:(CGFloat)changedHeight {
    CGSize f2 = self.containImageView.frame.size;
    CGRect maskOriginFrame = self.maskView.frame;

    CGRect f1 = [self calculateImageFrameByWindowSize:(CGSize){f2.width - changedWidth, f2.height - changedHeight}];
    f1.origin = self.containImageView.frame.origin;
    
    self.maskView.frame = f1;
    self.maskView.center = [self convertPoint:self.center fromView:self.superview];
    
    CGFloat zoomScale = fabsl(changedWidth) > fabsl(changedHeight) ? self.maskView.frame.size.width / maskOriginFrame.size.width : self.maskView.frame.size.height / maskOriginFrame.size.height;

    NSLog(@"%f", zoomScale);
    
//    CGAffineTransform lastTranform3D = CATransform3DGetAffineTransform(self.containImageView.transform3D);
//    self.containImageView.transform = CGAffineTransformScale(lastTranform3D, zoomScale, zoomScale);
    self.containImageView.transform = CGAffineTransformScale(self.containImageView.transform, zoomScale, zoomScale);
    NSLog(@"%@ - %@", NSStringFromCGSize(self.maskView.frame.size), NSStringFromCGSize(self.containImageView.frame.size));
    CGRect newFrame = self.containImageView.frame;
    newFrame.origin = self.maskView.frame.origin;
    self.containImageView.frame = newFrame;
}

#pragma mark - MHMCutMaskViewDelegate
-(void)cutMaskViewPanEnded:(MHMCutMaskView *)cutMaskView originFrame:(CGRect)oFrame newFrame:(CGRect)nFrame {
    [self cropActionByWidth:CGRectGetWidth(oFrame) - CGRectGetWidth(nFrame) andHeight:CGRectGetHeight(oFrame) - CGRectGetHeight(nFrame)];
}

@end
