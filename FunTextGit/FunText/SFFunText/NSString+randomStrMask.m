//
//  NSString+randomStrMask.m
//  FunText
//
//  Created by evans on 02/12/2016.
//  Copyright © 2016 evans. All rights reserved.
//

#import "NSString+randomStrMask.h"

@implementation NSString (randomStrMask)
+ (NSString *)getRandomMask
{
    return @"œ∑´®†¥¨ˆøπ“‘åß∂ƒ©˙∆˚¬…æ«Ω≈ç√∫˜µ≤≥÷¡™£¢¶•§ªº–≠`";
}

- (NSString *)convertToRandom
{
    NSMutableString *targetStr = [NSMutableString string];
    NSString *mask = [NSString getRandomMask];
    for (int i = 0;i < self.length; i++) {
        int randomIndex = arc4random()%(mask.length);
        NSString * str = [mask substringWithRange:NSMakeRange(randomIndex, 1)];
        [targetStr appendString:str];
    }
    return targetStr;
}

@end
