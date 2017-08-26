//
//  ViewController.m
//  Runtime修改分页控制器的距离
//
//  Created by 黄永锐 on 2017/8/26.
//  Copyright © 2017年 LoveQi. All rights reserved.
//

#import "ViewController.h"
#import <objc/message.h>
#import "HYRPageControl.h"


@interface ViewController ()<UIScrollViewDelegate>
/*** 数据源 ***/
@property (nonatomic, strong) NSArray *imagesArr;
/*** 分页控件 ***/
@property (nonatomic, strong) HYRPageControl *pageControl;
@end




@implementation ViewController

#pragma mark - 懒加载
- (NSArray *)imagesArr{
    if(_imagesArr == nil){
        _imagesArr = @[@"welcome1.png",@"welcome2.png",@"welcome3.png",@"welcome4.png"];
    }
    return _imagesArr;
}

#pragma mark - 程序的生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //创建sv
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.delegate = self;
    
    for (NSInteger i = 0; i < self.imagesArr.count; i++) {
        //图片路径
        NSString *filePath = [[NSBundle mainBundle] pathForResource:self.imagesArr[i] ofType:nil];
        //创建UIImageView
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * [UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        //加载图片
        imageView.image = [UIImage imageWithContentsOfFile:filePath];
        [scrollView addSubview:imageView];
    }
    
    
    scrollView.frame = self.view.bounds;
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    
    //设置sv的内容尺寸
    scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * self.imagesArr.count, 0);
    
    //把sv添加到父视图
    [self.view addSubview:scrollView];
    
    //创建分页控制器
    HYRPageControl *pageControl = [[HYRPageControl alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 100, [UIScreen mainScreen].bounds.size.width, 50)];
    pageControl.backgroundColor = [UIColor cyanColor];
    pageControl.numberOfPages = self.imagesArr.count;
    pageControl.pageIndicatorTintColor = [UIColor redColor];
    [self.view addSubview:pageControl];
    self.pageControl = pageControl;
    
    //对UIPageControl缩放（图片大小间距都会变）
    //self.pageControl.transform = CGAffineTransformScale(CGAffineTransformIdentity, 18.0/7.0, 20.0/7.0);
    
    
    //runtime 交换方法 实现圆点之间的距离
    //系统的方法
    Method origin = class_getInstanceMethod([UIPageControl class], sel_registerName("_indicatorSpacing"));
    Method custom = class_getInstanceMethod([self class], sel_registerName("hyr_indicatorSpacing"));
    //但是调用了私有的API方法，据说上传appstroe会被拒的
    method_exchangeImplementations(origin, custom);
    
    
}

#pragma mark - 自定义方法来实现 圆点之间的距离  利用runtime交换方法
-(CGFloat)hyr_indicatorSpacing{
    return 80.0;
}



#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //
    NSInteger page = scrollView.contentOffset.x / [UIScreen mainScreen].bounds.size.width;
    self.pageControl.currentPage = page;
}

#pragma mark - 获取模型中所有成员变量
-(void)getObjProperty{
    // runtime:根据模型中属性,去字典中取出对应的value给模型属性赋值
    // 1.获取模型中所有成员变量 key
    // 获取哪个类的成员变量
    // count:成员变量个数
    unsigned int count = 0;
    // 获取成员变量数组
    Ivar *ivarList = class_copyIvarList([UIPageControl class], &count);
    for (NSInteger i = 0; i<count; i++) {
        
        // 获取成员变量
        Ivar ivar = ivarList[i];
        
        // 获取成员变量名字
        NSString *ivarName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        
        // 获取成员变量类型
        NSString *ivarType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        NSLog(@"-----%@--%@",ivarName,ivarType);
    }
    
}

-(void)getAllMethod{
    
    //runtime 获取所有方法名
    unsigned int count = 0;
    //获取方法列表
    Method *methodList = class_copyMethodList([UIPageControl class], &count);
    for (NSInteger i = 0; i < count; i++) {
        //
        Method method = methodList[i];
        SEL sel = method_getName(method);
        NSString *methodName = [NSString stringWithUTF8String:sel_getName(sel)];
        
        //返回值类型
        char *dst = method_copyReturnType(method);
        
        //        size_t dstLen = 512;
        //        char dst[512] = {};
        //        method_getReturnType(method, dst, dstLen);
        
        NSLog(@"methodName:%@- retunType:%@",methodName,[NSString stringWithUTF8String:dst]);
        
    }

}

@end
