//
//  YYTextCommonParser.m
//  test
//
//  Created by 马浩萌 on 2021/2/1.
//

#import "YYTextCommonParser.h"

#pragma mark - Common Parser

#define LOCK(...) dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER); \
__VA_ARGS__; \
dispatch_semaphore_signal(_lock);

@implementation YYTextCommonParser {
    NSRegularExpression *_regex;
    NSDictionary *_mapper;
    dispatch_semaphore_t _lock;
}

- (instancetype)init {
    self = [super init];
    _lock = dispatch_semaphore_create(1);
    return self;
}

- (NSDictionary *)commonMapper {
    LOCK(NSDictionary *mapper = _mapper); return mapper;
}

-(void)setCommonMapper:(NSDictionary<NSString *,NSAttributedString *> *)commonMapper {
    LOCK(
         _mapper = commonMapper.copy;
         if (_mapper.count == 0) {
             _regex = nil;
         } else {
             NSMutableString *pattern = @"(".mutableCopy;
             NSArray *allKeys = _mapper.allKeys;
             NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@"$^?+*.,#|{}[]()\\"];
             for (NSUInteger i = 0, max = allKeys.count; i < max; i++) {
                 NSMutableString *one = [allKeys[i] mutableCopy];
                 
                 // escape regex characters
                 for (NSUInteger ci = 0, cmax = one.length; ci < cmax; ci++) {
                     unichar c = [one characterAtIndex:ci];
                     if ([charset characterIsMember:c]) {
                         [one insertString:@"\\" atIndex:ci];
                         ci++;
                         cmax++;
                     }
                 }
                 
                 [pattern appendString:one];
                 if (i != max - 1) [pattern appendString:@"|"];
             }
             [pattern appendString:@")"];
             _regex = [[NSRegularExpression alloc] initWithPattern:pattern options:kNilOptions error:nil];
         }
    );
}

// correct the selected range during text replacement
- (NSRange)_replaceTextInRange:(NSRange)range withLength:(NSUInteger)length selectedRange:(NSRange)selectedRange {
    // no change
    if (range.length == length) return selectedRange;
    // right
    if (range.location >= selectedRange.location + selectedRange.length) return selectedRange;
    // left
    if (selectedRange.location >= range.location + range.length) {
        selectedRange.location = selectedRange.location + length - range.length;
        return selectedRange;
    }
    // same
    if (NSEqualRanges(range, selectedRange)) {
        selectedRange.length = length;
        return selectedRange;
    }
    // one edge same
    if ((range.location == selectedRange.location && range.length < selectedRange.length) ||
        (range.location + range.length == selectedRange.location + selectedRange.length && range.length < selectedRange.length)) {
        selectedRange.length = selectedRange.length + length - range.length;
        return selectedRange;
    }
    selectedRange.location = range.location + length;
    selectedRange.length = 0;
    return selectedRange;
}

- (BOOL)parseText:(NSMutableAttributedString *)text selectedRange:(NSRangePointer)range {
    if (text.length == 0) return NO;
    
    [text yy_removeAttributesInRange:NSMakeRange(0, text.length)];
    
    NSDictionary *mapper;
    NSRegularExpression *regex;
    LOCK(mapper = _mapper; regex = _regex;);
    if (mapper.count == 0 || regex == nil) return NO;
    
    NSArray *matches = [regex matchesInString:text.string options:kNilOptions range:NSMakeRange(0, text.length)];
    if (matches.count == 0) return NO;
    
    NSRange selectedRange = range ? *range : NSMakeRange(0, 0);
    NSUInteger cutLength = 0;
    for (NSUInteger i = 0, max = matches.count; i < max; i++) {
        NSTextCheckingResult *one = matches[i];
        NSRange oneRange = one.range;
        if (oneRange.length == 0) continue;
//        oneRange.location -= cutLength;
        NSString *subStr = [text.string substringWithRange:oneRange];
        NSAttributedString * mapperAtr = mapper[subStr];
        if (!mapperAtr) continue;
        
        CGFloat fontSize = 12; // CoreText default value
        CTFontRef font = (__bridge CTFontRef)([text yy_attribute:NSFontAttributeName atIndex:oneRange.location]);
        if (font) fontSize = CTFontGetSize(font);
        NSMutableAttributedString *atr = [[NSMutableAttributedString alloc] initWithAttributedString:mapperAtr];
        [atr yy_setTextBackedString:[YYTextBackedString stringWithString:subStr] range:NSMakeRange(0, atr.length)];
        [text replaceCharactersInRange:oneRange withString:atr.string];
        [text yy_removeDiscontinuousAttributesInRange:NSMakeRange(oneRange.location, atr.length)];
        [text addAttributes:atr.yy_attributes range:NSMakeRange(oneRange.location, atr.length)];
        selectedRange = [self _replaceTextInRange:oneRange withLength:atr.length selectedRange:selectedRange];
        cutLength += oneRange.length - 1;
    }
    if (range) *range = selectedRange;
    
    return YES;
}

@end
