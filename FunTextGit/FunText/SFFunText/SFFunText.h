//
//  SFFunText.h
//  FunText
//
//  Created by evans on 01/12/2016.
//  Copyright © 2016 evans. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface SFShapeLayer:CAShapeLayer<CAAnimationDelegate>
@property (nonatomic, copy) void (^animaStopped)();
@end

@interface SFTextShapeLayer:CAShapeLayer
@property (nonatomic, strong) NSMutableArray *letterLayers;
@property (nonatomic, strong) NSMutableArray *letterPaths;
@property (nonatomic, assign) CGColorRef letterFillColor;
@property (nonatomic, assign) CGColorRef letterStrokeColor;
@property(copy) NSString *letterLineJoin;
@property CGFloat letterLineWidth;
@property (nonatomic, assign) int contentCounter;
@property (nonatomic, copy) void (^animaStopped)();
- (void)addLetter;
- (void)removeLetterAtIndex:(NSUInteger)index;
@end


@interface SFFunText : UIView
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) NSString *text;
- (void)startPlay;
- (void)vanish:(void(^)())handler;
@end
