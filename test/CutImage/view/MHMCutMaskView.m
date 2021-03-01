//
//  MHMCutMaskView.m
//  test
//
//  Created by 马浩萌 on 2021/2/5.
//

#import "MHMCutMaskView.h"

@import Masonry;

typedef NS_OPTIONS(NSUInteger, MHMCutMaskViewCornerDirection) {
    MHMCutMaskViewCornerDirectionRight = 1 << 0,
    MHMCutMaskViewCornerDirectionLeft  = 1 << 1,
    MHMCutMaskViewCornerDirectionTop    = 1 << 2,
    MHMCutMaskViewCornerDirectionBottom  = 1 << 3
};

@implementation MHMCutMaskView
{
    CGPoint _lastPoint;
    NSArray <UIView *> * _corners;
}

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        //        UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
        //        [self addGestureRecognizer:panGestureRecognizer];
        
        [self customCornersView];
    }
    return self;
}

-(void)customCornersView {
    
    UIView * cornerViewLT = [UIView new];
    cornerViewLT.tag = MHMCutMaskViewCornerDirectionLeft|MHMCutMaskViewCornerDirectionTop;
    cornerViewLT.backgroundColor = UIColor.blackColor;
    [self addSubview:cornerViewLT];
    [cornerViewLT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@20);
        make.leading.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(-10);
    }];
    
    UIView * cornerViewRT = [UIView new];
    cornerViewRT.tag = MHMCutMaskViewCornerDirectionRight|MHMCutMaskViewCornerDirectionTop;
    cornerViewRT.backgroundColor = UIColor.blackColor;
    [self addSubview:cornerViewRT];
    [cornerViewRT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@20);
        make.trailing.equalTo(self).inset(-10);
        make.top.equalTo(self).inset(-10);
    }];
    
    UIView * cornerViewRB = [UIView new];
    cornerViewRB.tag = MHMCutMaskViewCornerDirectionRight|MHMCutMaskViewCornerDirectionBottom;
    cornerViewRB.backgroundColor = UIColor.blackColor;
    [self addSubview:cornerViewRB];
    [cornerViewRB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@20);
        make.trailing.equalTo(self).inset(-10);
        make.bottom.equalTo(self).inset(-10);
    }];
    
    
    UIView * cornerViewLB = [UIView new];
    cornerViewLB.tag = MHMCutMaskViewCornerDirectionLeft|MHMCutMaskViewCornerDirectionBottom;
    cornerViewLB.backgroundColor = UIColor.blackColor;
    [self addSubview:cornerViewLB];
    [cornerViewLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@20);
        make.leading.equalTo(self).inset(-10);
        make.bottom.equalTo(self).inset(-10);
    }];
    
//    [cornerViewLT addGestureRecognizer:panGestureRecognizer];
//    [cornerViewRT addGestureRecognizer:panGestureRecognizer];
//    [cornerViewRB addGestureRecognizer:panGestureRecognizer];
//    [cornerViewLB addGestureRecognizer:panGestureRecognizer];

    _corners = @[cornerViewLT, cornerViewRT, cornerViewRB, cornerViewLB];
    
    [_corners enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
        [obj addGestureRecognizer:panGestureRecognizer];
    }];
}

- (void)drawRect:(CGRect)rect {
    NSLog(@"%@", NSStringFromCGRect(rect));
    UIBezierPath * path = [UIBezierPath bezierPath];
    CGFloat horizontalHeight = rect.size.height / 3;
    CGFloat longitudinalHeight = rect.size.width / 3;
    for (int i = 0; i < 4; i ++) {
        UIBezierPath * horizontalPath = [UIBezierPath bezierPath];
        [horizontalPath moveToPoint:CGPointMake(0, horizontalHeight * i)];
        [horizontalPath addLineToPoint:CGPointMake(rect.size.width, horizontalHeight * i)];
        UIBezierPath * longitudinalPath = [UIBezierPath bezierPath];
        [longitudinalPath moveToPoint:CGPointMake(longitudinalHeight * i, 0)];
        [longitudinalPath addLineToPoint:CGPointMake(longitudinalHeight * i, rect.size.height)];
        [path appendPath:horizontalPath];
        [path appendPath:longitudinalPath];
    }
    [UIColor.whiteColor setStroke];
    path.lineWidth = 1;
    [path stroke];
}

-(void)onPan:(UIPanGestureRecognizer *)panGestureRecognizer {
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            _lastPoint = panGestureRecognizer.view.center;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            panGestureRecognizer.view.center = [panGestureRecognizer locationInView:self];
            [self updateSelfFrame:panGestureRecognizer.view.tag];
            break;
        }
            
        case UIGestureRecognizerStateEnded: {
            UIView * cornerViewLT = [self viewWithTag:MHMCutMaskViewCornerDirectionLeft|MHMCutMaskViewCornerDirectionTop];
            UIView * cornerViewRB = [self viewWithTag:MHMCutMaskViewCornerDirectionRight|MHMCutMaskViewCornerDirectionBottom];

            CGRect newFrame = (CGRect){cornerViewLT.center, (CGSize){cornerViewRB.center.x - cornerViewLT.center.x, cornerViewRB.center.y - cornerViewLT.center.y}};
            self.frame = newFrame;
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(cutMaskViewPanEnded:from:to:)]) {
                NSLog(@"%@", NSStringFromCGPoint(_lastPoint));
                NSLog(@"%@", NSStringFromCGPoint(panGestureRecognizer.view.center));
                [self.delegate cutMaskViewPanEnded:self from:_lastPoint to:panGestureRecognizer.view.center];
            }
            break;
        }
        default:
            break;
    }
}

-(void)updateSelfFrame:(MHMCutMaskViewCornerDirection)directionTag {
    UIView * currentView = [self viewWithTag:directionTag];
    
    UIView * cornerViewLT = [self viewWithTag:MHMCutMaskViewCornerDirectionLeft|MHMCutMaskViewCornerDirectionTop];
    UIView * cornerViewLB = [self viewWithTag:MHMCutMaskViewCornerDirectionLeft|MHMCutMaskViewCornerDirectionBottom];
    UIView * cornerViewRT = [self viewWithTag:MHMCutMaskViewCornerDirectionRight|MHMCutMaskViewCornerDirectionTop];
    UIView * cornerViewRB = [self viewWithTag:MHMCutMaskViewCornerDirectionRight|MHMCutMaskViewCornerDirectionBottom];

    switch (directionTag) {
        case MHMCutMaskViewCornerDirectionLeft|MHMCutMaskViewCornerDirectionTop: { // 左上
            cornerViewRT.center = (CGPoint){cornerViewRT.center.x, currentView.center.y};
            cornerViewLB.center = (CGPoint){currentView.center.x, cornerViewLB.center.y};
            
            break;
        }
        case MHMCutMaskViewCornerDirectionRight|MHMCutMaskViewCornerDirectionTop: { // 右上
            cornerViewLT.center = (CGPoint){cornerViewLT.center.x, currentView.center.y};
            cornerViewRB.center = (CGPoint){currentView.center.x, cornerViewRB.center.y};

            break;
        }
        case MHMCutMaskViewCornerDirectionRight|MHMCutMaskViewCornerDirectionBottom: { // 右下
            cornerViewRT.center = (CGPoint){currentView.center.x, cornerViewRT.center.y};
            cornerViewLB.center = (CGPoint){cornerViewLB.center.x, currentView.center.y};
            
            break;
        }
        case MHMCutMaskViewCornerDirectionLeft|MHMCutMaskViewCornerDirectionBottom: { // 左下
            cornerViewLT.center = (CGPoint){currentView.center.x, cornerViewLT.center.y};
            cornerViewRB.center = (CGPoint){cornerViewRB.center.x, currentView.center.y};
            
            break;
        }
        default:
            break;
    }


}

-(void)foo:(CGPoint)currentPoint {
    CGRect selfFrame = self.frame;
    CGPoint selfCenter = self.center;
    
    CGFloat xDistance = currentPoint.x - selfCenter.x;
    CGFloat yDistance = currentPoint.y - selfCenter.y;
    
    MHMCutMaskViewCornerDirection directionX = xDistance > 0 ? MHMCutMaskViewCornerDirectionRight : MHMCutMaskViewCornerDirectionLeft;
    MHMCutMaskViewCornerDirection directionY = yDistance > 0 ? MHMCutMaskViewCornerDirectionBottom : MHMCutMaskViewCornerDirectionTop;
    
    NSLog(@"%lu", directionX | directionY);
    
    //    CGPoint ltPoint = selfFrame.origin;
    //    CGPoint rtPoint = (CGPoint){ltPoint.x + selfFrame.size.width, ltPoint.y};
    //    CGPoint rbPoint = (CGPoint){ltPoint.x + selfFrame.size.width, ltPoint.y + selfFrame.size.height};
    //    CGPoint lbPoint = (CGPoint){ltPoint.x, ltPoint.y + selfFrame.size.height};
}

@end
