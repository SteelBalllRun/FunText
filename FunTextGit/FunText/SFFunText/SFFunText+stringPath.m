//
//  SFFunText+stringPath.m
//  FunText
//
//  Created by evans on 05/12/2016.
//  Copyright © 2016 evans. All rights reserved.
//

#import "SFFunText+stringPath.h"
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

@implementation SFFunText (stringPath)
CGPathRef CGPathCreateSingleLetterCharWithinAttributedString(NSAttributedString *str, int index)
{
    CGMutablePathRef path = CGPathCreateMutable();
    
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)str);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++) {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++) {
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            
            {
                CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                if (CGPathIsEmpty(letter)) {
                    continue;
                }
                CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
                if (runGlyphIndex == index) {
                    CGPathAddPath(path, &t, letter);
                    CFRelease(letter);
                    break;
                }
                CFRelease(letter);
            }
        }
    }
    CFRelease(line);
    CGAffineTransform trans = CGAffineTransformMakeScale(1, -1);
    CGPathRef final = CGPathCreateCopyByTransformingPath(path, &trans);
    CGPathRelease(path);
    return final;
}

CGPathRef CGPathCreateSingleLineStringWithAttributedString(NSAttributedString *str)
{
    CGMutablePathRef letters = CGPathCreateMutable();
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)str);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++) {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++) {
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            
            {
                CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                if (CGPathIsEmpty(letter)) {
                    continue;
                }
                CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
                CGPathAddPath(letters, &t, letter);
                CFRelease(letter);
            }
        }
    }
    
    CFRelease(line);
    CGAffineTransform trans = CGAffineTransformMakeScale(1, -1);
    CGPathRef final = CGPathCreateCopyByTransformingPath(letters, &trans);
    CGPathRelease(letters);
    
    return final;
}

- (NSArray *)CGPathCreateSingleLineStringWithAttributedString:(NSAttributedString *)str
{
    NSMutableArray * final = [NSMutableArray array];
    
    CTLineRef line = CTLineCreateWithAttributedString((__bridge CFAttributedStringRef)str);
    CFArrayRef runArray = CTLineGetGlyphRuns(line);
    for (CFIndex runIndex = 0; runIndex < CFArrayGetCount(runArray); runIndex++) {
        CTRunRef run = (CTRunRef)CFArrayGetValueAtIndex(runArray, runIndex);
        CTFontRef runFont = CFDictionaryGetValue(CTRunGetAttributes(run), kCTFontAttributeName);
        for (CFIndex runGlyphIndex = 0; runGlyphIndex < CTRunGetGlyphCount(run); runGlyphIndex++) {
            CFRange thisGlyphRange = CFRangeMake(runGlyphIndex, 1);
            CGGlyph glyph;
            CGPoint position;
            CTRunGetGlyphs(run, thisGlyphRange, &glyph);
            CTRunGetPositions(run, thisGlyphRange, &position);
            {
                CGPathRef letter = CTFontCreatePathForGlyph(runFont, glyph, NULL);
                if (CGPathIsEmpty(letter)) {
                    continue;
                }
                CGAffineTransform t = CGAffineTransformMakeTranslation(position.x, position.y);
                CGAffineTransform trans = CGAffineTransformScale(t, 1, -1);
                CGPathRef path = CGPathCreateCopyByTransformingPath(letter, &trans);
                [final addObject:CFBridgingRelease(CGPathCreateCopy(path))];
                CFRelease(letter);
            } 
        }
    }
    CFRelease(line);
    return final;
}
@end
