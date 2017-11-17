/*
 Copyright 2015-present the Material Components for iOS authors. All Rights Reserved.

 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at

 http://www.apache.org/licenses/LICENSE-2.0

 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "MDCInkView.h"

#import "private/MDCInkLayer.h"

@interface MDCInkView ()
//@property(nonatomic, readonly) MDCInkLayer *inkLayer;

@property(nonatomic, strong) MDCInkLayer *activeInkLayer;
@property(nonatomic, strong) NSMutableArray<MDCInkLayer *> *inkLayers;
@property(nonatomic, assign) BOOL touchInsideView;

@end

@implementation MDCInkView

//+ (Class)layerClass {
//  return [MDCInkLayer class];
//}

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    [self commonMDCInkViewInit];
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
  self = [super initWithCoder:aDecoder];
  if (self) {
    [self commonMDCInkViewInit];
  }
  return self;
}

- (void)commonMDCInkViewInit {
  self.userInteractionEnabled = NO;
  self.backgroundColor = [UIColor clearColor];
  self.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
  self.inkColor = self.defaultInkColor;
  _touchInsideView = YES;
}

//- (void)setInkStyle:(MDCInkStyle)inkStyle {
//  _inkStyle = inkStyle;
//  switch (inkStyle) {
//    case MDCInkStyleBounded:
//      self.inkLayer.masksToBounds = YES;
//      self.inkLayer.bounded = YES;
//      break;
//    case MDCInkStyleUnbounded:
//      self.inkLayer.masksToBounds = NO;
//      self.inkLayer.bounded = NO;
//      break;
//  }
//}

- (void)setFrame:(CGRect)frame {
  [super setFrame:frame];
  self.activeInkLayer.bounds = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

//- (void)setInkColor:(UIColor *)inkColor {
//  if (inkColor == nil) {
//    return;
//  }
//  _inkColor = inkColor;
//}
//
//- (UIColor *)inkColor {
//  return self.inkColor;
//}

//- (CGFloat)maxRippleRadius {
//  return self.inkLayer.maxRippleRadius;
//}
//
//- (void)setMaxRippleRadius:(CGFloat)radius {
//  if (self.inkLayer.maxRippleRadius != radius) {
//    self.inkLayer.maxRippleRadius = radius;
//    [self setNeedsLayout];
//  }
//}
//
//- (BOOL)usesCustomInkCenter {
//  return self.inkLayer.useCustomInkCenter;
//}
//
//- (void)setUsesCustomInkCenter:(BOOL)usesCustomInkCenter {
//  self.inkLayer.useCustomInkCenter = usesCustomInkCenter;
//}
//
//- (CGPoint)customInkCenter {
//  return self.inkLayer.customInkCenter;
//}
//
//- (void)setCustomInkCenter:(CGPoint)customInkCenter {
//  self.inkLayer.customInkCenter = customInkCenter;
//}

//- (MDCInkLayer *)inkLayer {
//  return (MDCInkLayer *)self.layer;
//}

- (void)startTouchBeganAnimationAtPoint:(CGPoint)point
                             completion:(MDCInkCompletionBlock)completionBlock {
  MDCInkLayer *inkLayer = [MDCInkLayer layer];
//  inkLayer.animationDelegate = self;
//  inkLayer.inkColor = self.inkColor;
  inkLayer.inkColor = self.inkColor;
  
  switch (self.inkStyle) {
    case MDCInkStyleBounded:
      self.clipsToBounds = YES;
      break;
    case MDCInkStyleUnbounded:
      self.clipsToBounds = NO;
      break;
  }

  inkLayer.completionBlock = completionBlock;
  inkLayer.opacity = 0;
  inkLayer.frame = self.bounds;
  [self.layer addSublayer:inkLayer];
  [self.inkLayers addObject:inkLayer];
  [inkLayer startAnimationAtPoint:point];
  self.activeInkLayer = inkLayer;
//  [self.inkLayer spreadFromPoint:point completion:completionBlock];
}

- (void)startTouchEndedAnimationAtPoint:(CGPoint)point
                             completion:(MDCInkCompletionBlock)completionBlock {
  if (completionBlock) {
    
  }
  [self.activeInkLayer endAnimationAtPoint:point];
//  [self.inkLayer evaporateWithCompletion:completionBlock];
}

- (void)cancelAllAnimationsAnimated:(BOOL)animated {
//  [self.inkLayer resetAllInk:animated];
  if (animated) {
    
  }
}

- (UIColor *)defaultInkColor {
  return [[UIColor alloc] initWithWhite:0 alpha:0.06f];
}

#pragma mark

+ (MDCInkView *)injectedInkViewForView:(UIView *)view {
  MDCInkView *foundInkView = nil;
  for (MDCInkView *subview in view.subviews) {
    if ([subview isKindOfClass:[MDCInkView class]]) {
      foundInkView = subview;
      break;
    }
  }
  if (!foundInkView) {
    foundInkView = [[MDCInkView alloc] initWithFrame:view.bounds];
    foundInkView.autoresizingMask =
        UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [view addSubview:foundInkView];
  }
  return foundInkView;
}

@end
