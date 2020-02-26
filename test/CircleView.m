//
//  CircleView.m
//  test
//
//  Created by weiguang on 2019/8/30.
//  Copyright © 2019 duia. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _radius = 100;
        _fill = NO;
        _lineWidth = 5;
        _color = [UIColor redColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGFloat centerX = (self.bounds.size.width - self.bounds.origin.x)/2;
    CGFloat centerY = (self.bounds.size.height - self.bounds.origin.y)/2;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    // 添加圆形
    [path addArcWithCenter:CGPointMake(centerX, centerY) radius:_radius startAngle:0 endAngle:360 clockwise:YES];
    // 设置线条宽度
    path.lineWidth = _lineWidth;
    
    [_color setStroke];
    
    [path stroke];
    
    if (_fill) {
        [_color setFill];
        [path fill];
    }
}


@end
