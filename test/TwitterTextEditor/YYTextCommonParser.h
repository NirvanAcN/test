//
//  YYTextCommonParser.h
//  test
//
//  Created by 马浩萌 on 2021/2/1.
//

#import <Foundation/Foundation.h>
@import YYText;

NS_ASSUME_NONNULL_BEGIN

@interface YYTextCommonParser : NSObject <YYTextParser>

@property (nullable, copy) NSDictionary <NSString *, NSAttributedString *> * commonMapper;

@end

NS_ASSUME_NONNULL_END
