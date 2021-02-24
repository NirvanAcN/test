//
//  MHMCutMaskView.h
//  test
//
//  Created by 马浩萌 on 2021/2/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MHMCutMaskView;

@protocol MHMCutMaskViewDelegate <NSObject>

@optional
-(void)cutMaskViewPanEnded:(MHMCutMaskView *)cutMaskView from:(CGPoint)startPoint to:(CGPoint)endPoint;
-(void)cutMaskViewPanEnded:(MHMCutMaskView *)cutMaskView originFrame:(CGRect)oFrame newFrame:(CGRect)nFrame;

@end

@interface MHMCutMaskView : UIView

@property (weak) id<MHMCutMaskViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
