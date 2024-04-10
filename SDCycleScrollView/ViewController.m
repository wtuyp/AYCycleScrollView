//
//  ViewController.m
//  SDCycleScrollView
//
//  Created by aier on 15-3-22.
//  Copyright (c) 2015年 GSD. All rights reserved.
//

/*
 
 *********************************************************************************
 *
 * 🌟🌟🌟 新建SDCycleScrollView交流QQ群：185534916 🌟🌟🌟
 *
 * 在您使用此自动轮播库的过程中如果出现bug请及时以以下任意一种方式联系我们，我们会及时修复bug并
 * 帮您解决问题。
 * 新浪微博:GSD_iOS
 * Email : gsdios@126.com
 * GitHub: https://github.com/gsdios
 *
 * 另（我的自动布局库SDAutoLayout）：
 *  一行代码搞定自动布局！支持Cell和Tableview高度自适应，Label和ScrollView内容自适应，致力于
 *  做最简单易用的AutoLayout库。
 * 视频教程：http://www.letv.com/ptv/vplay/24038772.html
 * 用法示例：https://github.com/gsdios/SDAutoLayout/blob/master/README.md
 * GitHub：https://github.com/gsdios/SDAutoLayout
 *********************************************************************************
 
 */

#import "ViewController.h"
#import "AyCycleScrollView.h"
#import "CustomCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "SDCollectionViewCell.h"

@interface ViewController () <AyCycleScrollViewDelegate>

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) AyCycleScrollView *cycleScrollView0;
@property (nonatomic, strong) AyCycleScrollView *cycleScrollView1;
@property (nonatomic, strong) AyCycleScrollView *cycleScrollView2;
@property (nonatomic, strong) AyCycleScrollView *cycleScrollView3;
@property (nonatomic, strong) AyCycleScrollView *cycleScrollView4;

@property (nonatomic, copy) NSArray *imageNames;
@property (nonatomic, copy) NSArray *imagesURLStrings;
@property (nonatomic, copy) NSArray *titles;

@end

@implementation ViewController
{
    NSMutableArray<AyCycleScrollView *> *_scrollViews;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:0.99];
    UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"005.jpg"]];
    backgroundView.frame = self.view.bounds;
    [self.view addSubview:backgroundView];
    
    UIScrollView *demoContainerView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    demoContainerView.contentSize = CGSizeMake(self.view.frame.size.width, 1200);
    [self.view addSubview:demoContainerView];
    
    self.title = @"轮播Demo";

    
    // 情景一：采用本地图片实现
    NSArray *imageNames = @[@"h1.jpg",
                            @"h2.jpg",
                            @"h3.jpg",
                            @"h4.jpg",
                            @"h7" // 本地图片请填写全名
                            ];
    self.imageNames = imageNames;
    
    // 情景二：采用网络图片实现
    NSArray *imagesURLStrings = @[
                           @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                           @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                           @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                           ];
    self.imagesURLStrings = imagesURLStrings;
    
    // 情景三：图片配文字
    NSArray *titles = @[@"新建交流QQ群：185534916 ",
                        @"disableScrollGesture可以设置禁止拖动",
                        @"感谢您的支持，如果下载的",
                        @"如果代码在使用过程中出现问题",
                        @"您可以发邮件到gsdios@126.com"
                        ];
    
    self.titles = titles;
    
    CGFloat w = self.view.bounds.size.width;
    
    _scrollViews = [[NSMutableArray alloc] init];

// >>>>>>>>>>>>>>>>>>>>>>>>> demo轮播图1 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    // 本地加载 --- 创建不带标题的图片轮播器
    AyCycleScrollView *cycleScrollView = [[AyCycleScrollView alloc] initWithFrame:CGRectMake(0, 64, w, 180)];
    cycleScrollView.infiniteLoop = YES;
    cycleScrollView.delegate = self;
//    cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    [demoContainerView addSubview:cycleScrollView];
    cycleScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
    //         --- 轮播时间间隔，默认1.0秒，可自定义
    //cycleScrollView.autoScrollTimeInterval = 4.0;
    [cycleScrollView registerClass:SDCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(SDCollectionViewCell.class)];
    
    self.cycleScrollView0 = cycleScrollView;
    [_scrollViews addObject:cycleScrollView];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        cycleScrollView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    });
    
// >>>>>>>>>>>>>>>>>>>>>>>>> demo轮播图2 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    // 网络加载 --- 创建带标题的图片轮播器
    AyCycleScrollView *cycleScrollView2 = [[AyCycleScrollView alloc] initWithFrame:CGRectMake(0, 280, w, 180)];
    
//    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
//    cycleScrollView2.titlesGroup = titles;
//    cycleScrollView2.currentPageDotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    [cycleScrollView2 registerClass:SDCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(SDCollectionViewCell.class)];
    [demoContainerView addSubview:cycleScrollView2];
    cycleScrollView2.defaultIndex = 1;
    
    self.cycleScrollView1 = cycleScrollView2;
    [_scrollViews addObject:cycleScrollView2];
    
    //         --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
//        [cycleScrollView2 scrollToIndex:1 animated:NO];
    });
    
    /*
     block监听点击方式
     
     cycleScrollView2.clickItemOperationBlock = ^(NSInteger index) {
        NSLog(@">>>>>  %ld", (long)index);
     };
     
     */
    
    
// >>>>>>>>>>>>>>>>>>>>>>>>> demo轮播图3 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
    AyCycleScrollView *cycleScrollView3 = [[AyCycleScrollView alloc] initWithFrame:CGRectMake(0, 500, w, 180)];
//    cycleScrollView3.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
//    cycleScrollView3.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
//    cycleScrollView3.imageURLStringsGroup = imagesURLStrings;
    [cycleScrollView3 registerClass:SDCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(SDCollectionViewCell.class)];
    
    [demoContainerView addSubview:cycleScrollView3];
    
    self.cycleScrollView2 = cycleScrollView3;
    [_scrollViews addObject:cycleScrollView3];
    
// >>>>>>>>>>>>>>>>>>>>>>>>> demo轮播图4 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    // 网络加载 --- 创建只上下滚动展示文字的轮播器
    // 由于模拟器的渲染问题，如果发现轮播时有一条线不必处理，模拟器放大到100%或者真机调试是不会出现那条线的
    AyCycleScrollView *cycleScrollView4 = [[AyCycleScrollView alloc] initWithFrame:CGRectMake(0, 750, w, 40)];
    cycleScrollView4.scrollDirection = UICollectionViewScrollDirectionVertical;
//    cycleScrollView4.onlyDisplayText = YES;
    
    NSMutableArray *titlesArray = [NSMutableArray new];
    [titlesArray addObject:@"纯文字上下滚动轮播"];
    [titlesArray addObject:@"纯文字上下滚动轮播 -- demo轮播图4"];
    [titlesArray addObjectsFromArray:titles];
//    cycleScrollView4.titlesGroup = [titlesArray copy];
    [cycleScrollView4 disableScrollGesture];
    [cycleScrollView4 registerClass:SDCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(SDCollectionViewCell.class)];
    
    [demoContainerView addSubview:cycleScrollView4];
    
    self.cycleScrollView3 = cycleScrollView4;
    [_scrollViews addObject:cycleScrollView4];
    
// >>>>>>>>>>>>>>>>>>>>>>>>> demo轮播图5 自定义cell的轮播图 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
    
    // 如果要实现自定义cell的轮播图，必须先实现customCollectionViewCellClassForCycleScrollView:和setupCustomCell:forIndex:代理方法
    
    self.cycleScrollView4 = [[AyCycleScrollView alloc] initWithFrame:CGRectMake(0, 820, w, 120)];
//    self.cycleScrollView4.currentPageDotImage = [UIImage imageNamed:@"pageControlCurrentDot"];
//    self.cycleScrollView4.pageDotImage = [UIImage imageNamed:@"pageControlDot"];
//    self.cycleScrollView4.imageURLStringsGroup = imagesURLStrings;
    [self.cycleScrollView4 registerClass:CustomCollectionViewCell.class forCellWithReuseIdentifier:NSStringFromClass(CustomCollectionViewCell.class)];
    
    [demoContainerView addSubview:self.cycleScrollView4];
    
    
    [_scrollViews addObject:self.cycleScrollView4];
    
    __weak typeof(self) weakSelf = self;
    [_scrollViews enumerateObjectsUsingBlock:^(AyCycleScrollView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.delegate = (id<AyCycleScrollViewDelegate>)weakSelf;
        obj.dataSource = (id<AyCycleScrollViewDataSource>)weakSelf;
    }];
    
    [self startTimer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 如果你发现你的CycleScrollview会在viewWillAppear时图片卡在中间位置，你可以调用此方法调整图片位置
//    [你的CycleScrollview adjustWhenControllerViewWillAppera];
}

#pragma mark - SDCycleScrollViewDataSource

- (NSInteger)numberOfItemsInCycleScrollView:(AyCycleScrollView *)cycleScrollView {
    if (cycleScrollView == self.cycleScrollView0) {
        return self.imageNames.count;
    } else if (cycleScrollView == self.cycleScrollView1
               || cycleScrollView == self.cycleScrollView2
               || cycleScrollView == self.cycleScrollView4) {
        return self.imagesURLStrings.count;
    } else if (cycleScrollView == self.cycleScrollView3) {
        return self.titles.count;
    }
    return 0;
}

- (__kindof UICollectionViewCell *)cycleScrollView:(AyCycleScrollView *)cycleScrollView cellForItemAtIndex:(NSInteger)index {
    if (cycleScrollView != self.cycleScrollView4) {
        SDCollectionViewCell *cell = [cycleScrollView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(SDCollectionViewCell.class) forIndex:index];
        
        if (cycleScrollView == self.cycleScrollView0) {
            cell.imageView.image = [UIImage imageNamed:self.imageNames[index]];
        } else if (cycleScrollView == self.cycleScrollView1
                   || cycleScrollView == self.cycleScrollView2) {
            [cell.imageView sd_setImageWithURL:self.imagesURLStrings[index] placeholderImage:[UIImage imageNamed:@"placeholder"]];
            if (cycleScrollView == self.cycleScrollView2) {
                cell.title = self.titles[index];
                
                if (!cell.hasConfigured) {
                    cell.titleLabelBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
                    cell.titleLabelHeight = 30;
                    cell.titleLabelTextAlignment = NSTextAlignmentLeft;
                    cell.titleLabelTextColor = [UIColor whiteColor];
                    cell.titleLabelTextFont = [UIFont systemFontOfSize:14];
                    cell.hasConfigured = YES;
                    cell.imageView.contentMode = UIViewContentModeScaleToFill;
                    cell.clipsToBounds = YES;
                    cell.onlyDisplayText = NO;
                }
            }
        } else if (cycleScrollView == self.cycleScrollView3) {
            cell.onlyDisplayText = YES;
            cell.title = self.titles[index];
        }
        
        return cell;
    } else {
        CustomCollectionViewCell *cell = [cycleScrollView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(CustomCollectionViewCell.class) forIndex:index];
        [cell.imageView sd_setImageWithURL:self.imagesURLStrings[index]];
        return cell;
    }
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(AyCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"---点击了第%ld张图片", (long)index);
    
//    [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
}


/*
 
// 滚动到第几张图回调
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index
{
    NSLog(@">>>>>> 滚动到第%ld张图", (long)index);
}
 
 */

- (void)cycleScrollViewDidScroll:(AyCycleScrollView *)cycleScrollView {
    
}

- (void)cycleScrollViewWillBeginDragging:(AyCycleScrollView *)cycleScrollView {
    [self stopTimer];
}

- (void)cycleScrollViewDidEndDragging:(AyCycleScrollView *)cycleScrollView willDecelerate:(BOOL)decelerate {
    [self startTimer];
}


// 不需要自定义轮播cell的请忽略下面的代理方法

// 如果要实现自定义cell的轮播图，必须先实现customCollectionViewCellClassForCycleScrollView:和setupCustomCell:forIndex:代理方法

- (Class)customCollectionViewCellClassForCycleScrollView:(AyCycleScrollView *)view
{
    if (view != self.cycleScrollView4) {
        return nil;
    }
    return [CustomCollectionViewCell class];
}

- (void)setupCustomCell:(UICollectionViewCell *)cell forIndex:(NSInteger)index cycleScrollView:(AyCycleScrollView *)view
{
    CustomCollectionViewCell *myCell = (CustomCollectionViewCell *)cell;
    [myCell.imageView sd_setImageWithURL:self.imagesURLStrings[index]];
}

- (void)startTimer {
    // 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
    [self stopTimer];
    
    // 会有timer释放的问题，这里只作示例用。
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(scrollToNextIndex) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)stopTimer {
    if ([_timer isValid]) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)scrollToNextIndex {
    [_scrollViews enumerateObjectsUsingBlock:^(AyCycleScrollView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj scrollToNextIndex];
    }];
}

@end
