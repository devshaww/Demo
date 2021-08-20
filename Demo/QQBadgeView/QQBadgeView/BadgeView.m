//
//  BadgeView.m
//  QQBadgeView
//
//  Created by Shaw on 2017/2/5.
//  Copyright © 2017年 Shaw. All rights reserved.
//

#import "BadgeView.h"

@interface BadgeView()

@property (nonatomic, weak) UIView *smallCircle;
@property (nonatomic, weak) CAShapeLayer *shapeLayer;

@end

@implementation BadgeView

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    [self setupUI];
//}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        [self setupUI];
    }
    return self;
}

- (CAShapeLayer *)shapeLayer {
    if (_shapeLayer == nil) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.fillColor = [UIColor redColor].CGColor;
        [self.superview.layer insertSublayer:layer atIndex: 0];
        _shapeLayer = layer;
    }
    
    return _shapeLayer;
}

- (void)setupUI {
    self.layer.cornerRadius = self.bounds.size.width / 2;
    self.layer.masksToBounds = YES;
    self.backgroundColor = [UIColor redColor];
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget: self action: @selector(pan:)];
    [self addGestureRecognizer: recognizer];
    
    UIView *circle = [[UIView alloc] init];
    circle.frame = self.frame;
    circle.backgroundColor = self.backgroundColor;
    circle.layer.cornerRadius = self.layer.cornerRadius;
    self.smallCircle = circle;
    [self.superview insertSubview: self.smallCircle belowSubview: self];
}

- (void)drawRect:(CGRect)rect {
    [self setupUI];
}

- (void)pan:(UIPanGestureRecognizer *)recognizer {
    CGPoint translation = [recognizer translationInView:self];
    CGPoint center = self.center;
    center.x += translation.x;
    center.y += translation.y;
    self.center = center;
    [recognizer setTranslation:CGPointZero inView:self];
    
    CGFloat distance = [self distanceWithSmallCircle:self.smallCircle bigCircle:self];

    // 小圆半径随distance增大逐渐减小 比如distance增大10 半径减小
    CGFloat smallRadius = self.bounds.size.width / 2;
    smallRadius -= distance / 10;
    self.smallCircle.bounds = CGRectMake(0, 0, smallRadius * 2, smallRadius * 2);
    self.smallCircle.layer.cornerRadius = smallRadius;   // 圆角设置 为当前半径
    NSLog(@"distance: %f",distance);
    
    UIBezierPath *path = [self pathWithSmallCircle:self.smallCircle bigCircle:self];
    
    if (!self.smallCircle.hidden) {
        self.shapeLayer.path = path.CGPath;
    }
    
    NSLog(@"%@",self.shapeLayer);
    
    if (distance >= 60) {
        self.smallCircle.hidden = YES;
        [self.shapeLayer removeFromSuperlayer];
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        // distance < 60 恢复到初始状态
        if (distance < 60) {
//            self.frame = self.smallCircle.frame;
            self.center = self.smallCircle.center;
            self.smallCircle.hidden = NO;
        }
        
        // distance >= 60 隐藏small 并将shapeLayer从super移除
        else {
            self.smallCircle.hidden = YES;
            [self.shapeLayer removeFromSuperlayer];
            self.hidden = YES;
        }
    }
}

- (CGFloat)distanceWithSmallCircle:(UIView *)small bigCircle:(UIView *)big {
    CGFloat offsetX = small.center.x - big.center.x;
    CGFloat offsetY = small.center.y - big.center.y;
    return sqrt(offsetX * offsetX + offsetY * offsetY);
}

- (UIBezierPath *)pathWithSmallCircle:(UIView *)small bigCircle:(UIView *)big {
    CGFloat x1 = small.center.x;
    CGFloat y1 = small.center.y;
    
    CGFloat x2 = small.center.x;
    CGFloat y2 = small.center.y;
    
    CGFloat distance = [self distanceWithSmallCircle:small bigCircle:big];
    
    if (distance <= 0) {
        return nil;
    }
    
    CGFloat cosΘ = (y2 - y1) / distance;
    CGFloat sinΘ = (x2 - x2) / distance;
    
    CGFloat r1 = small.bounds.size.width / 2;
    CGFloat r2 = big.bounds.size.width / 2;
    
    CGPoint pointA = CGPointMake(x1 - r1 * cosΘ, y1 + r1 * sinΘ);
    CGPoint pointB = CGPointMake(x1 + r1 * cosΘ, y1 - r1 * sinΘ);
    CGPoint pointC = CGPointMake(x2 + r2 * cosΘ, y2 - r2 * sinΘ);
    CGPoint pointD = CGPointMake(x2 - r2 * cosΘ, y2 + r2 * sinΘ);
    CGPoint pointO = CGPointMake(pointA.x + distance * 0.5 * sinΘ, pointA.y + distance * 0.5 * cosΘ);
    CGPoint pointP = CGPointMake(pointB.x + distance * 0.5 * sinΘ, pointB.y + distance * 0.5 * cosΘ);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    // AB
    [path moveToPoint:pointA];
    [path addLineToPoint:pointB];
    
    // BC
    [path addQuadCurveToPoint:pointC controlPoint:pointP];
    
    // CD
    [path addLineToPoint:pointD];
    
    // DA
    [path addQuadCurveToPoint:pointA controlPoint:pointO];
    
    return path;
}

@end
