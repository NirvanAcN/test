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

@property (nonatomic, strong) UIView * containView;

@property (nonatomic, strong) UIImageView * containImageView;

@property (nonatomic, strong) MHMCutMaskView * maskView;

@end

static const CGFloat kDefaultInsetValue = 20;

@implementation MHMCutView
{
    CGRect _windowsAnchor;
    CGFloat _totalZoomScale;
    CGAffineTransform _originTransform;
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
    _totalZoomScale = 1;
    self.maskView.frame = self.containImageView.frame;
}

#pragma mark - UIImageView
-(UIView *)containView {
    if (!_containView) {
        _containView = [UIView new];
        _containView.backgroundColor = UIColor.redColor;
        [self addSubview:_containView];
    }
    return _containView;
}

-(UIImageView *)containImageView {
    if (!_containImageView) {
        _containImageView = [UIImageView new];
        _containImageView.userInteractionEnabled = YES;
        _containImageView.contentMode = UIViewContentModeScaleAspectFit;
        _containImageView.backgroundColor = UIColor.cyanColor;
        [self.containView addSubview:_containImageView];
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
        [self.containView addSubview:_maskView];
        [self.containView bringSubviewToFront:_maskView];
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
        
        self.containView.frame = [self calculateImageFrameByWindowSize:xImage.size];
        self.containImageView.frame = self.containView.frame;
        self.containView.center = [self convertPoint:self.center fromView:self.superview];
        
        self->_windowsAnchor = self.containView.frame;
        self->_originTransform = self.containImageView.transform;
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
//    NSLog(@"%@", NSStringFromCGPoint([self convertPoint:self.maskView.center fromView:self.containView]));

    // 记录缩放背景、裁切窗口的原始frame
    CGSize containViewOriginFrame = self.containView.frame.size;
    CGRect maskOriginFrame = self.maskView.frame;
    
    // 计算裁切窗口缩放后的尺寸
    CGSize maskNewSize = [self calculateImageFrameByWindowSize:(CGSize){containViewOriginFrame.width - changedWidth, containViewOriginFrame.height - changedHeight}].size;
    
//    NSLog(@"%@", NSStringFromCGSize(maskNewSize));
//    NSLog(@"%@", NSStringFromCGSize(maskOriginFrame.size));
    
    CGFloat zoomScaleWidth = maskNewSize.width / maskOriginFrame.size.width;
    CGFloat zoomScaleHeight = maskNewSize.height / maskOriginFrame.size.height;
    NSLog(@"%f, %f", zoomScaleWidth, zoomScaleHeight);
//    if (CGSizeEqualToSize(CGSizeMake(maskOriginFrame.size.width * zoomScaleWidth, maskOriginFrame.size.height * zoomScaleWidth), maskNewSize)) {
//        NSLog(@"zoomScaleWidth");
//    } else if (CGSizeEqualToSize(CGSizeMake(maskOriginFrame.size.width * zoomScaleHeight, maskOriginFrame.size.height * zoomScaleHeight), maskNewSize)) {
//        NSLog(@"zoomScaleHeight");
//    } else {
//        NSLog(@"????");
//    }
    
    CGFloat zoomScale = MAX(zoomScaleWidth, zoomScaleHeight);
    NSLog(@"%f", zoomScale);
    CGAffineTransform scaleTransform = CGAffineTransformMakeScale(zoomScale, zoomScale);
//    CGAffineTransform scaleTransform = CGAffineTransformScale(self.containView.transform, zoomScale, zoomScale);
    self.containView.transform = scaleTransform;
    
    CGRect newFrame = self.containView.frame;
    self.containView.frame = newFrame;
    
    CGPoint p1 = [self convertPoint:self.maskView.center fromView:self.containView];
    CGPoint p2center = [self convertPoint:self.center fromView:self.superview];
    self.containView.center = (CGPoint){self.containView.center.x + p2center.x - p1.x, self.containView.center.y + p2center.y - p1.y};
    
    [self.maskView setNeedsDisplay];
}

#pragma mark - MHMCutMaskViewDelegate
-(void)cutMaskViewPanEnded:(MHMCutMaskView *)cutMaskView originFrame:(CGRect)oFrame newFrame:(CGRect)nFrame {
    [self cropActionByWidth:CGRectGetWidth(oFrame) - CGRectGetWidth(nFrame) andHeight:CGRectGetHeight(oFrame) - CGRectGetHeight(nFrame)];
}

-(void)cutMaskViewPanEnded:(MHMCutMaskView *)cutMaskView from:(CGPoint)startPoint to:(CGPoint)endPoint {
    [self cropActionByWidth:startPoint.x - endPoint.x andHeight:startPoint.y - endPoint.y];
}

@end
