//
//  MHMCutMaskView.m
//  test
//
//  Created by 马浩萌 on 2021/2/5.
//

#import "MHMCutMaskView.h"

@implementation MHMCutMaskView

-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        UIPanGestureRecognizer * panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
        [self addGestureRecognizer:panGestureRecognizer];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
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
    path.lineWidth = 1.5;
    [path stroke];
}

-(void)onPan:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint c = [panGestureRecognizer locationInView:self];
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, c.x, c.y);
}

@end
