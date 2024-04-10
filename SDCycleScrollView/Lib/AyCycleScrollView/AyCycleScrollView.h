//
//  AyCycleScrollView.h
//
//  Created by alpha yu on 2024/03/05
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class AyCycleScrollView;

@protocol AyCycleScrollViewDataSource <NSObject>

@required

- (NSInteger)numberOfItemsInCycleScrollView:(AyCycleScrollView *)cycleScrollView;
- (__kindof UICollectionViewCell *)cycleScrollView:(AyCycleScrollView *)cycleScrollView cellForItemAtIndex:(NSInteger)index;

@end

@protocol AyCycleScrollViewDelegate <NSObject>

@optional

/// 点击
- (void)cycleScrollView:(AyCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

/// 滚动到某一页
- (void)cycleScrollView:(AyCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index;

/// 滚动中
- (void)cycleScrollViewDidScroll:(AyCycleScrollView *)cycleScrollView;

/// 开始滚动
- (void)cycleScrollViewWillBeginDragging:(AyCycleScrollView *)cycleScrollView;

/// 结束滚动
- (void)cycleScrollViewDidEndDragging:(AyCycleScrollView *)cycleScrollView willDecelerate:(BOOL)decelerate;

@end

@interface AyCycleScrollView : UIView

@property (nonatomic, strong, readonly) UICollectionView *mainView;

@property (nonatomic,assign) BOOL infiniteLoop; ///< 是否无限循环, 默认Yes
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;  ///< 图片滚动方向，默认为水平滚动

@property (nonatomic, weak) id<AyCycleScrollViewDelegate> delegate;
@property (nonatomic, weak) id<AyCycleScrollViewDataSource> dataSource;

@property (nonatomic, assign, readonly) NSInteger currentIndex; ///< 当前序号
@property (nonatomic, assign) NSInteger defaultIndex;           ///< 默认序号，默认 0

/// 点击block
@property (nonatomic, copy) void (^clickItemOperationBlock)(NSInteger currentIndex);

/// 滚动block
@property (nonatomic, copy) void (^itemDidScrollOperationBlock)(NSInteger currentIndex);

/// 注册cell
- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier;

/// 获取复用cell
- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index;

/// 解决viewWillAppear时出现时轮播图卡在一半的问题，在控制器viewWillAppear时调用此方法
- (void)adjustWhenControllerViewWillAppear;

/// 滚动手势禁用（可用于文字轮播）
- (void)disableScrollGesture;

/// 滚动到下一页
- (void)scrollToNextIndex;
/// 滚动到上一页
- (void)scrollToPreviousIndex;

/// 滚动到指定页, 有动画
- (void)scrollToIndex:(NSInteger)index;
/// 滚动到指定页
- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
