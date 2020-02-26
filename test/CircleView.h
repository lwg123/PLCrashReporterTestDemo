//
//  CircleView.h
//  test
//
//  Created by weiguang on 2019/8/30.
//  Copyright © 2019 duia. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 自定义的view显示到storyboard预览，需添加IB_DESIGNABLE
// 属性栏中修改属性需在属性前加上IBInspectable关键字
IB_DESIGNABLE
@interface CircleView : UIView

@property (nonatomic, assign) IBInspectable CGFloat lineWidth; // 圆形线条的宽度
@property (nonatomic, assign) IBInspectable CGFloat radius; // 圆形的半径
@property (nonatomic, strong) IBInspectable UIColor *color; // 绘制的颜色
@property (nonatomic, assign) IBInspectable BOOL fill; // 是否填充，是不是实心圆

@end

NS_ASSUME_NONNULL_END
