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

#import "MDCInkGestureRecognizer.h"

#import <UIKit/UIGestureRecognizerSubclass.h>

static const CGFloat kInkGestureDefaultDragCancelDistance = 20;

@interface MDCInkGestureRecognizer ()

@property(nonatomic, assign) CGPoint touchStartLocation;
@property(nonatomic, assign) CGPoint touchCurrentLocation;

@end

@implementation MDCInkGestureRecognizer

- (instancetype)initWithTarget:(id)target action:(SEL)action {
  self = [super initWithTarget:target action:action];
  if (self) {
    _cancelOnDragOut = YES;
    _dragCancelDistance = kInkGestureDefaultDragCancelDistance;
    _targetBounds = CGRectNull;
    self.cancelsTouchesInView = NO;
    self.delaysTouchesEnded = NO;

    _touchStartLocation = CGPointZero;
    _touchCurrentLocation = CGPointZero;
  }
  return self;
}

- (CGPoint)touchStartLocationInView:(UIView *)view {
  return [view convertPoint:_touchStartLocation fromView:nil];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [super touchesBegan:touches withEvent:event];
  if (touches.count == 1) {
    self.state = UIGestureRecognizerStateBegan;
    UITouch *touch = [touches anyObject];
    self.touchStartLocation = [touch locationInView:nil];
    self.touchCurrentLocation = self.touchStartLocation;
  } else {
    self.state = UIGestureRecognizerStateCancelled;
  }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
  [super touchesMoved:touches withEvent:event];
  if (self.state == UIGestureRecognizerStateFailed) {
    return;
  }
  
  // Cancel the gesture if it is too far away.
  if (_cancelOnDragOut && ![self isTouchWithinTargetBounds]) {
    self.state = UIGestureRecognizerStateCancelled;
  } else {
    self.state = UIGestureRecognizerStateChanged;
  }
  UITouch *touch = [touches anyObject];
  self.touchCurrentLocation = [touch locationInView:nil];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesEnded:touches withEvent:event];
  self.state = UIGestureRecognizerStateEnded;
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
  [super touchesCancelled:touches withEvent:event];
  self.state = UIGestureRecognizerStateCancelled;
}

- (BOOL)isTouchWithinTargetBounds {
  CGRect targetBounds = [self effectiveTargetBounds];
  CGRect boundsInWindowCoord = [self.view convertRect:targetBounds toView:nil];
  boundsInWindowCoord =
      CGRectInset(boundsInWindowCoord, -_dragCancelDistance, -_dragCancelDistance);
  return CGRectContainsPoint(boundsInWindowCoord, _touchCurrentLocation);
}

#pragma mark - Private methods

- (CGRect)effectiveTargetBounds {
  return CGRectEqualToRect(_targetBounds, CGRectNull) ? self.view.bounds : _targetBounds;
}

@end
