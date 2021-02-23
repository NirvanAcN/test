//
//  MHMParserModel.h
//  test
//
//  Created by 马浩萌 on 2021/2/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MHMParserModel : NSObject

-(instancetype)init NS_UNAVAILABLE;
-(instancetype)initWithKey:(nonnull NSString *)key andShowValue:(nonnull NSString *)value NS_DESIGNATED_INITIALIZER;

@property (nonatomic, copy, readonly) NSDictionary * mhmParserItem;

@property (nonatomic, strong) UIColor * tagStrokeColor;
@property (nonatomic, strong) UIColor * tagFillColor;
@property (nonatomic, strong) UIFont * font;
@property (nonatomic, strong) UIColor * fontColor;


@end

NS_ASSUME_NONNULL_END
