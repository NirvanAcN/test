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
    UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
    
    UIView * cornerViewLT = [UIView new];
    cornerViewLT.backgroundColor = UIColor.blackColor;
    [self addSubview:cornerViewLT];
    [cornerViewLT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@20);
        make.leading.equalTo(self).offset(-10);
        make.top.equalTo(self).offset(-10);
    }];
    
    UIView * cornerViewRT = [UIView new];
    cornerViewRT.backgroundColor = UIColor.blackColor;
    [self addSubview:cornerViewRT];
    [cornerViewRT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@20);
        make.trailing.equalTo(self).inset(-10);
        make.top.equalTo(self).inset(-10);
    }];
    
    UIView * cornerViewRB = [UIView new];
    cornerViewRB.backgroundColor = UIColor.blackColor;
    [self addSubview:cornerViewRB];
    [cornerViewRB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.equalTo(@20);
        make.trailing.equalTo(self).inset(-10);
        make.bottom.equalTo(self).inset(-10);
    }];
    
    
    UIView * cornerViewLB = [UIView new];
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
    [cornerViewLB addGestureRecognizer:panGestureRecognizer];

    _corners = @[cornerViewLT, cornerViewRT, cornerViewRB, cornerViewLB];
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
    
    CGPoint c = [panGestureRecognizer locationInView:self];
    switch (panGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            //            _lastFrame = self.frame;
            //            [self foo:c];
            
            _lastPoint = panGestureRecognizer.view.center;
            
            break;
        }
        case UIGestureRecognizerStateChanged: {
            //            CGPoint c = [panGestureRecognizer locationInView:self];
            //            if (c.x > _lastFrame.size.width || c.y > _lastFrame.size.height) {
            //                //                break;
            //            } else {
            //                self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, c.x, c.y);
            //            }
            panGestureRecognizer.view.center = [panGestureRecognizer locationInView:self];
//            NSLog(@"%@", NSStringFromCGPoint(panGestureRecognizer.view.center));
            [self updateSelfFrame];
            break;
        }
            
        case UIGestureRecognizerStateEnded: {
            //            if (self.delegate && [self.delegate respondsToSelector:@selector(cutMaskViewPanEnded:originFrame:newFrame:)]) {
            //                [self.delegate cutMaskViewPanEnded:self originFrame:_lastFrame newFrame:self.frame];
            //            }
            
            //            -(void)cutMaskViewPanEnded:(MHMCutMaskView *)cutMaskView originFrame:(CGRect)oFrame newFrame:(CGRect)nFrame;
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

-(void)updateSelfFrame {
    CGPoint originViewCenter = _corners.firstObject.center;
    CGPoint sizeViewCenter = _corners[2].center;
    CGRect newFrame = (CGRect){originViewCenter, (CGSize){sizeViewCenter.x - originViewCenter.x, sizeViewCenter.y - originViewCenter.y}};
    self.frame = newFrame;
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
