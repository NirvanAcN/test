//
//  LayerTestView.m
//  test
//
//  Created by 马浩萌 on 2021/1/5.
//

#import "LayerTestView.h"
#import "LayerTestLayer.h"

@implementation LayerTestView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.circleLayer = [LayerTestLayer layer];
        self.circleLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.circleLayer.contentsScale = [UIScreen mainScreen].scale;
        [self.layer addSublayer:self.circleLayer];
        NSLog(@"%@", NSStringFromCGRect(_circleLayer.frame));
        NSLog(@"%@", NSStringFromCGPoint(_circleLayer.position));
    }
    return self;
}

@end
