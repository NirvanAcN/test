//
//  MHMParserModel.m
//  test
//
//  Created by 马浩萌 on 2021/2/1.
//

#import "MHMParserModel.h"
@import YYText;

@implementation MHMParserModel
{
    NSString * _tag;
    NSMutableAttributedString * _tagText;
    
    YYTextBorder * _border;
}

-(instancetype)initWithKey:(NSString *)key andShowValue:(NSString *)value {
    self = [super init];
    if (self) {
        _tag = [key copy];
        _tagText = [[NSMutableAttributedString alloc] initWithString:value];
//        [_tagText yy_insertString:@"  " atIndex:0];
//        [_tagText yy_appendString:@"  "];
        
        _border = [YYTextBorder new];
        _border.strokeWidth = 1.5;
        _border.cornerRadius = 100; // a huge value
        _border.lineJoin = kCGLineJoinBevel;
        
//        _border.insets = UIEdgeInsetsMake(-2, -5.5, -2, -8);
        [_tagText yy_setTextBackgroundBorder:_border range:_tagText.yy_rangeOfAll];
    }
    return self;
}

-(void)setFont:(UIFont *)font {
    _font = font;
    _tagText.yy_font = font;
}

-(void)setFontColor:(UIColor *)fontColor {
    _fontColor = fontColor;
    _tagText.yy_color = fontColor;
}

-(void)setTagFillColor:(UIColor *)tagFillColor {
    _tagFillColor = tagFillColor;
    _border.fillColor = tagFillColor;
}

-(void)setTagStrokeColor:(UIColor *)tagStrokeColor {
    _tagStrokeColor = tagStrokeColor;
    _border.strokeColor = tagStrokeColor;
}

-(NSDictionary *)mhmParserItem {
    return @{
        _tag: _tagText
    };
}

@end
