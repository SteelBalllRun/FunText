//
//  SFFunText+stringPath.h
//  FunText
//
//  Created by evans on 05/12/2016.
//  Copyright © 2016 evans. All rights reserved.
//

#import "SFFunText.h"

@interface SFFunText (stringPath)
CGPathRef CGPathCreateSingleLetterCharWithinAttributedString(NSAttributedString *str, int index);
CGPathRef CGPathCreateSingleLineStringWithAttributedString(NSAttributedString *str);
- (NSArray *)CGPathCreateSingleLineStringWithAttributedString:(NSAttributedString *)str;
@end
