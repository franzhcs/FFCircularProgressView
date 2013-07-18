//
//  FFCircularProgressBar.m
//  FFCircularProgressBar
//
//  Created by Fabiano Francesconi on 16/07/13.
//  Copyright (c) 2013 Fabiano Francesconi. All rights reserved.
//

#import "FFCircularProgressView.h"
#import "UIColor+iOS7.h"

@interface FFCircularProgressView()

@property (atomic, assign) CGFloat oldProgressValue;

@property (nonatomic, strong) CAShapeLayer *progressBackgroundLayer;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) CAShapeLayer *iconLayer;

@end

@implementation FFCircularProgressView

#define kArrowSizeRatio .15
#define kArrowSizeRatio .12
#define kStopSizeRatio  .35
#define kTickWidthRatio .3

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        _lineWidth = self.frame.size.width * 0.025;
        
        self.progressBackgroundLayer = [CAShapeLayer layer];
        _progressBackgroundLayer.strokeColor = [UIColor colorWithIos7Gray].CGColor;
        _progressBackgroundLayer.fillColor = self.backgroundColor.CGColor;
        _progressBackgroundLayer.lineCap = kCALineCapRound;
        _progressBackgroundLayer.lineWidth = _lineWidth;
        [self.layer addSublayer:_progressBackgroundLayer];

        self.progressLayer = [CAShapeLayer layer];
        _progressLayer.strokeColor = [UIColor colorWithIos7Blue].CGColor;
        _progressLayer.fillColor = nil;
        _progressLayer.lineCap = kCALineCapRound;
        _progressLayer.lineWidth = _lineWidth * 2.0;
        [self.layer addSublayer:_progressLayer];

        self.iconLayer = [CAShapeLayer layer];
        _iconLayer.strokeColor = [UIColor colorWithIos7Blue].CGColor;
        _iconLayer.fillColor = nil;
        _iconLayer.lineCap = kCALineCapButt;
        _iconLayer.lineWidth = _lineWidth;
        _iconLayer.fillRule = kCAFillRuleNonZero;
        [self.layer addSublayer:_iconLayer];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Draw background
    UIBezierPath *processBackgroundPath = [UIBezierPath bezierPath];
    processBackgroundPath.lineWidth = _lineWidth;
    processBackgroundPath.lineCapStyle = kCGLineCapRound;
    CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    CGFloat radius = (self.bounds.size.width - _lineWidth)/2;
    CGFloat startAngle = - ((float)M_PI / 2); // 90 degrees
    CGFloat endAngle = (2 * (float)M_PI) + startAngle;
    [processBackgroundPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    _progressBackgroundLayer.path = processBackgroundPath.CGPath;

    // Draw progress
    UIBezierPath *processPath = [UIBezierPath bezierPath];
    processPath.lineCapStyle = kCGLineCapButt;
    processPath.lineWidth = _lineWidth;
    endAngle = (self.progress * 2 * (float)M_PI) + startAngle;

    radius = (self.bounds.size.width - _lineWidth*4) / 2.0;
    [processPath addArcWithCenter:center radius:radius startAngle:startAngle endAngle:endAngle clockwise:YES];
    
    [_progressLayer setPath:processPath.CGPath];
    
    if ([self progress] == 1.0) {
        [self drawTick];
    } else if (([self progress] > 0) && [self progress] < 1.0) {
        [self drawStop];
    } else {
        [self drawArrow];
    }
}

#pragma mark -
#pragma mark Setters

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    
    _progressBackgroundLayer.lineWidth = _lineWidth;
    _progressLayer.lineWidth = _lineWidth * 2.0;
    _iconLayer.lineWidth = _lineWidth;
}

#pragma mark -
#pragma mark Drawing

- (void) drawTick {
    CGFloat radius = MIN(self.frame.size.width, self.frame.size.height)/2;
    
    /*
     First draw a tick that looks like this:
     
     A---F
     |   |
     |   E-------D
     |           |
     B-----------C
     
     (Remember: (0,0) is top left)
     */
    UIBezierPath *tickPath = [UIBezierPath bezierPath];
    CGFloat tickWidth = radius * kTickWidthRatio;
    [tickPath moveToPoint:CGPointMake(0, 0)];                            // A
    [tickPath addLineToPoint:CGPointMake(0, tickWidth * 2)];             // B
    [tickPath addLineToPoint:CGPointMake(tickWidth * 3, tickWidth * 2)]; // C
    [tickPath addLineToPoint:CGPointMake(tickWidth * 3, tickWidth)];     // D
    [tickPath addLineToPoint:CGPointMake(tickWidth, tickWidth)];         // E
    [tickPath addLineToPoint:CGPointMake(tickWidth, 0)];                 // F
    [tickPath closePath];
    
    // Now rotate it through -45 degrees...
    [tickPath applyTransform:CGAffineTransformMakeRotation(-M_PI_4)];
    
    // ...and move it into the right place.
    [tickPath applyTransform:CGAffineTransformMakeTranslation(radius * .44, radius)];
    
    [_iconLayer setPath:tickPath.CGPath];
    [_iconLayer setFillColor:[UIColor whiteColor].CGColor];
    [_progressBackgroundLayer setFillColor:_progressLayer.strokeColor];
}

- (void) drawStop {
    CGFloat radius = (self.bounds.size.width)/2;
    CGFloat ratio = kStopSizeRatio;
    CGFloat sideSize = self.bounds.size.width * ratio;
    
    UIBezierPath *stopPath = [UIBezierPath bezierPath];
    [stopPath moveToPoint:CGPointMake(0, 0)];
    [stopPath addLineToPoint:CGPointMake(sideSize, 0.0)];
    [stopPath addLineToPoint:CGPointMake(sideSize, sideSize)];
    [stopPath addLineToPoint:CGPointMake(0.0, sideSize)];
    [stopPath closePath];
    
    // ...and move it into the right place.
    [stopPath applyTransform:CGAffineTransformMakeTranslation(radius * (1-ratio), radius* (1-ratio))];
    
    [_iconLayer setPath:stopPath.CGPath];
    [_iconLayer setStrokeColor:_progressLayer.strokeColor];
    [_iconLayer setFillColor:[UIColor colorWithIos7Blue].CGColor];
}

- (void) drawArrow {
    CGFloat radius = (self.bounds.size.width)/2;
    CGFloat ratio = kArrowSizeRatio;
    CGFloat segmentSize = self.bounds.size.width * ratio;

    // Draw icon
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0.0, 0.0)];
    [path addLineToPoint:CGPointMake(segmentSize * 2.0, 0.0)];
    [path addLineToPoint:CGPointMake(segmentSize * 2.0, segmentSize)];
    [path addLineToPoint:CGPointMake(segmentSize * 3.0, segmentSize)];
    [path addLineToPoint:CGPointMake(segmentSize, segmentSize * 3.3)];
    [path addLineToPoint:CGPointMake(-segmentSize, segmentSize)];
    [path addLineToPoint:CGPointMake(0.0, segmentSize)];
    [path addLineToPoint:CGPointMake(0.0, 0.0)];
    [path closePath];

    [path applyTransform:CGAffineTransformMakeTranslation(-segmentSize /2.0, -segmentSize / 1.2)];
    [path applyTransform:CGAffineTransformMakeTranslation(radius * (1-ratio), radius* (1-ratio))];
    _iconLayer.path = path.CGPath;
}

#pragma mark Setters

- (void)setProgress:(CGFloat)progress {
    if (progress > 1.0) progress = 1.0;
    
    if (_progress != progress) {
        _progress = progress;
        
        if (_progress == 1.0) {
            [self animateProgressBackgroundLayerFillColor];
        }
        
        [self setNeedsDisplay];
    }
}

#pragma mark Animations

- (void) animateProgressBackgroundLayerFillColor {
    CABasicAnimation *colorAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    
    colorAnimation.duration = .5;
    colorAnimation.repeatCount = 1.0;
    colorAnimation.removedOnCompletion = NO;
    
    colorAnimation.fromValue = (__bridge id) _progressBackgroundLayer.backgroundColor;
    colorAnimation.toValue = (__bridge id) _progressLayer.strokeColor;
    
    colorAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    
    [_progressBackgroundLayer addAnimation:colorAnimation forKey:@"colorAnimation"];
}

@end
