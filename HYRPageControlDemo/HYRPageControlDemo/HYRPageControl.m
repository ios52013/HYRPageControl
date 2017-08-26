//
//  HYRPageControl.m
//  Runtime修改分页控制器的距离
//
//  Created by 黄永锐 on 2017/8/26.
//  Copyright © 2017年 LoveQi. All rights reserved.
//

#import "HYRPageControl.h"
#define kDotW 30  //圆点的宽度
#define kMagrin 20 //圆点之间的间隔


@interface HYRPageControl ()
{
    CGFloat _spacing;
    CGFloat _size;
    CGFloat _LeftRight;
}
@end



@implementation HYRPageControl

#pragma mark - 法一
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //计算圆点尺寸和间距的长度
    CGFloat marginX = kDotW + kMagrin;
    
    //计算整个pageControll的宽度
    CGFloat newW = self.frame.size.width;//(self.subviews.count - 1 ) * magrin + self.subviews.count *dotW;
    
    //计算左边距
    CGFloat leftRight = (newW - ((self.subviews.count - 1 ) * kMagrin + self.subviews.count * kDotW)) / 2;
    
    //设置新frame
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, newW, self.frame.size.height);
    
    //遍历subview,设置圆点frame
    for (int i=0; i<[self.subviews count]; i++) {
        UIImageView* dot = [self.subviews objectAtIndex:i];
        [dot setFrame:CGRectMake(i * marginX + leftRight, dot.frame.origin.y, kDotW, kDotW)];
    }
}




#pragma mark - 法二

//重写父类的方法
-(void) setCurrentPage:(NSInteger)page
{
    [super setCurrentPage:page];
    
    //[self setUpDots];
}

//设置圆点
-(void) setUpDots{
    
    _size = 20;
    _spacing = 30;
    _LeftRight = (self.bounds.size.width - self.subviews.count * _size - (self.subviews.count-1) * _spacing) / 2;
    
    for (NSInteger i = 0; i<[self.subviews count]; i++) {
        //圆点
        UIView* dot = [self.subviews objectAtIndex:i];
        [dot setFrame:CGRectMake(i * (_size+_spacing) + _LeftRight, dot.frame.origin.y,_size, _size)];
        
        //添加imageView
        if ([dot.subviews count] == 0) {
            UIImageView * view = [[UIImageView alloc]initWithFrame:dot.bounds];
            [dot addSubview:view];
        };
        
        //配置imageView
        UIImageView * view = dot.subviews[0];
        
        if (i == self.currentPage) {
            view.image = [UIImage imageNamed:@"currentImage"];
        }else {
            view.image = [UIImage imageNamed:@"defaultImage"];
        }
        
    }
    
}

@end
