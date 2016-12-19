//
//  SFFunText.m
//  FunText
//
//  Created by evans on 01/12/2016.
//  Copyright © 2016 evans. All rights reserved.
//

#import "SFFunText.h"
#import "NSString+randomStrMask.h"
#import "SFFunText+stringPath.h"
#import <CoreText/CoreText.h>
#import <QuartzCore/QuartzCore.h>

@class SFTextShapeLayer;
@interface SFFunText()<CAAnimationDelegate>
@property (nonatomic, strong) NSString *basestring;
@property (nonatomic, strong) SFTextShapeLayer *contentLayer;
@end

@implementation SFFunText

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!self.basestring) {
            self.basestring = @"basestring";
        }
        self.font = [UIFont systemFontOfSize:28];
        self.contentLayer = [SFTextShapeLayer layer];
        self.contentLayer.frame = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height);
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.basestring attributes:@{NSFontAttributeName:self.font}];

        self.contentLayer.bounds = self.bounds;
        self.contentLayer.letterStrokeColor = [UIColor whiteColor].CGColor;
        self.contentLayer.letterLineWidth = 1;
        self.contentLayer.letterFillColor = [UIColor whiteColor].CGColor;
        self.contentLayer.letterLineJoin = kCALineJoinRound;
        self.contentLayer.letterPaths = [NSMutableArray arrayWithArray:[self CGPathCreateSingleLineStringWithAttributedString:str]];
        __weak typeof(self) weakself = self;
        [self.contentLayer setAnimaStopped:^{
            __strong typeof(weakself) self = weakself;
            NSLog(@"%@",self.basestring);
        }];
        [self.layer addSublayer:self.contentLayer];
    }
    return self;
}

- (void)setText:(NSString *)text
{
    _text = text;
    [self startPlay];
}

#pragma mark - 组播动画

- (void)startPlay
{
    if (self.contentLayer.sublayers.count > 0) {
        [self __startGroupPlay:YES];
    }else
    {
        [self __startPlay];
    }
}

- (void)__startPlay
{
    if (!self.basestring) {
        self.basestring = @"base text";
    }
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:self.basestring attributes:@{NSFontAttributeName:self.font}];
    
    NSAttributedString *str_2 = [[NSAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName:self.font}];
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    
    pathAnimation.duration = .8f;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = (__bridge id)(CGPathCreateSingleLineStringWithAttributedString(str));
    pathAnimation.toValue = (__bridge id)(CGPathCreateSingleLineStringWithAttributedString(str_2));
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.delegate = self;
    
    [self.contentLayer addAnimation:pathAnimation forKey:@"path"];
}

- (void)__startGroupPlay:(BOOL)ordered
{

    NSAttributedString *str_2 = [[NSAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName:self.font}];
    NSUInteger timesize = MAX(self.basestring.length, self.text.length);
    for (int i = 0 ; i < timesize; i++) {
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        pathAnimation.duration = .5;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.toValue = (__bridge id)(CGPathCreateSingleLetterCharWithinAttributedString(str_2, i));
        pathAnimation.fillMode = kCAFillModeForwards;
        pathAnimation.removedOnCompletion = NO;
        
        
        if (i >= self.contentLayer.letterLayers.count) {
            [self.contentLayer addLetter];
        }
        SFShapeLayer *layer = [self.contentLayer.letterLayers objectAtIndex:i];
//        [layer removeAllAnimations];
        if (self.contentLayer.letterPaths.count > i) {
            [self.contentLayer.letterPaths replaceObjectAtIndex:i withObject:pathAnimation.toValue];
        }else
        {
            [self.contentLayer.letterPaths insertObject:pathAnimation.toValue atIndex:i];
        }
        pathAnimation.delegate = layer;
        [layer addAnimation:pathAnimation forKey:@"path"];
    }
    self.basestring = self.text;            //防止因为外部在for过程中修改self.text导致动画跳帧
}

#pragma mark - 消失动画

- (void)vanish:(void (^)())handler
{
    if (self.contentLayer.sublayers.count > 0) {
        [self __vanishGroup:YES handler:handler];
    }else
    {
        [self __vanish:handler];
    }
}

- (void)__vanish:(void (^)())handler
{
    NSString * target = [self.text convertToRandom];
    self.text = target;
    [self startPlay];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.text = @".........";
        [self startPlay];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            handler?handler():nil;
        });
    });
}

- (void)__vanishGroup:(BOOL)order handler:(void (^)())handler
{
    if (!order) {
        NSString * target = [self.text convertToRandom];
        self.text = target;
        [self __startGroupPlay:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.text = @".........";
            [self __startGroupPlay:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                handler?handler():nil;
            });
        });
    }else
    {
        NSString * target = [self.text convertToRandom];
        self.text = target;
        [self __vanishInOrder:1 toText:[self.text convertToRandom]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self __vanishInOrder:1 toText:@"      "];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                handler?handler():nil;
            });
        });
    }
}

- (void)__vanishInOrder:(CGFloat)duration toText:(NSString *)target
{
    self.text = target;
    NSAttributedString *str_2 = [[NSAttributedString alloc] initWithString:self.text attributes:@{NSFontAttributeName:self.font}];
    NSUInteger timesize = MAX(self.basestring.length, self.text.length);
    CGFloat timePieces = duration/self.basestring.length;
    for (int i = 0 ; i < timesize; i++) {
        CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
        pathAnimation.duration = timePieces;
        pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        pathAnimation.toValue = (__bridge id)(CGPathCreateSingleLetterCharWithinAttributedString(str_2, i));
        pathAnimation.fillMode = kCAFillModeForwards;
        pathAnimation.removedOnCompletion = NO;
        pathAnimation.beginTime = CACurrentMediaTime() + timePieces * i;
        
        if (i >= self.contentLayer.letterLayers.count) {
            [self.contentLayer addLetter];
        }
        
        SFShapeLayer *layer = [self.contentLayer.letterLayers objectAtIndex:i];
        //            [layer removeAllAnimations];
        if (self.contentLayer.letterPaths.count > i) {
            [self.contentLayer.letterPaths replaceObjectAtIndex:i withObject:pathAnimation.toValue];
        }else
        {
            [self.contentLayer.letterPaths insertObject:pathAnimation.toValue atIndex:i];
        }
        pathAnimation.delegate = layer;
        [layer addAnimation:pathAnimation forKey:@"path"];
    }
    self.basestring = self.text;            //防止因为外部在for过程中修改self.text导致动画跳帧
}

@end

@implementation SFShapeLayer

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if ([anim isKindOfClass:[CABasicAnimation class]]) {
        CABasicAnimation* animation = (CABasicAnimation*)anim;
        self.path = (__bridge CGPathRef)animation.toValue;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.animaStopped) {
                self.animaStopped();
            }
        });
    }
}

@end


@implementation SFTextShapeLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.letterPaths = [NSMutableArray array];
        self.letterLayers = [NSMutableArray array];
    }
    return self;
}

- (void)setLetterPaths:(NSArray *)paths
{
    if (paths.count == 0) {
        return;
    }
    
    for (CALayer *subLayer in self.sublayers) {
        [subLayer removeFromSuperlayer];
    }
    [self.letterLayers removeAllObjects];
    _letterPaths = [NSMutableArray arrayWithArray:paths];
    
    //todo:设置每个字母的path，以便于控制动画
    for (id _path in self.letterPaths) {
        CGMutablePathRef path = (CGMutablePathRef)CFBridgingRetain(_path);
        SFShapeLayer *letterLayer = [SFShapeLayer layer];
        letterLayer.frame = CGPathGetBoundingBox(path);
        letterLayer.path = path;
        letterLayer.bounds = CGPathGetBoundingBox(path);
        letterLayer.strokeColor = self.letterStrokeColor;
        letterLayer.lineWidth = self.letterLineWidth;
        letterLayer.fillColor = self.letterFillColor;
        letterLayer.lineJoin = self.letterLineJoin;
        __weak typeof(self) weakSelf = self;
        letterLayer.animaStopped = ^(){
            __strong typeof(self) self = weakSelf;
            if (self.contentCounter >= self.letterPaths.count) {
                //TODO:完整动画结束
                self.contentCounter = 0;
                self.animaStopped?self.animaStopped():nil;
            }else
            {
                self.contentCounter += 1;
            }
            NSLog(@"%d",self.contentCounter);
        };
        [self addSublayer:letterLayer];
        [self.letterLayers addObject:letterLayer];
    }
}

- (void)addLetter
{
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@" "];
    CGPathRef path = CGPathCreateSingleLineStringWithAttributedString(str);
    SFShapeLayer *letterLayer = [SFShapeLayer layer];
    letterLayer.frame = CGPathGetBoundingBox(path);
    letterLayer.path = path;
    letterLayer.bounds = CGPathGetBoundingBox(path);
    letterLayer.strokeColor = self.letterStrokeColor;
    letterLayer.lineWidth = self.letterLineWidth;
    letterLayer.fillColor = self.letterFillColor;
    letterLayer.lineJoin = self.letterLineJoin;
    __weak typeof(self) weakSelf = self;
    letterLayer.animaStopped = ^(){
        __strong typeof(self) self = weakSelf;
        if (self.contentCounter >= self.letterPaths.count) {
            //TODO:完整动画结束
            self.contentCounter = 0;
            self.animaStopped?self.animaStopped():nil;
        }else
        {
            self.contentCounter += 1;
        }
        NSLog(@"%d",self.contentCounter);
    };
    [self addSublayer:letterLayer];
    [self.letterLayers addObject:letterLayer];
    [self.letterPaths addObject:CFBridgingRelease(CGPathCreateCopy(path))];
}

- (void)removeLetterAtIndex:(NSUInteger)index
{
    
}

@end
