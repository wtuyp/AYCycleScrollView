//
//  AyCycleScrollView.h
//
//  Created by alpha yu on 2024/03/05
//


#import "AyCycleScrollView.h"

@interface AyCycleScrollView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *mainView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, assign) NSInteger itemCount;  ///< item数量
@property (nonatomic, assign) NSInteger dataCount;  ///< 数据数量
@property (nonatomic, assign) NSInteger threshold;  ///< 阈值

@end

@implementation AyCycleScrollView

#pragma mark - life

- (void)dealloc {
    self.mainView.delegate = nil;
    self.mainView.dataSource = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupInit];
    }
    return self;
}

- (void)setupInit {
    self.infiniteLoop = YES;
    self.threshold = 10;
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.mainView];
}

#pragma mark - override

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.flowLayout.itemSize = self.frame.size;
    self.mainView.frame = self.bounds;
    
    if (self.mainView.contentOffset.x == 0
        && [self collectionView:self.mainView numberOfItemsInSection:0] > 0) {
        NSInteger itemIndex = self.defaultIndex;
        if (self.infiniteLoop) {
            itemIndex = self.itemCount * 0.5 + self.defaultIndex;
        }
        
        [self.mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:itemIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

#pragma mark - getter

- (UICollectionView *)mainView {
    if (!_mainView) {
        _mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _mainView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _mainView.backgroundColor = [UIColor clearColor];
        _mainView.pagingEnabled = YES;
        _mainView.showsHorizontalScrollIndicator = NO;
        _mainView.showsVerticalScrollIndicator = NO;
        
        _mainView.dataSource = self;
        _mainView.delegate = self;
        _mainView.scrollsToTop = NO;
    }
    return _mainView;
}

- (UICollectionViewFlowLayout *)flowLayout {
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _flowLayout;
}

#pragma mark - setter

- (void)setInfiniteLoop:(BOOL)infiniteLoop {
    _infiniteLoop = infiniteLoop;
    [self.mainView reloadData];
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection {
    _scrollDirection = scrollDirection;
    self.flowLayout.scrollDirection = scrollDirection;
}

#pragma mark - public

- (void)adjustWhenControllerViewWillAppear {
    NSInteger currentItemIndex = [self currentItemIndex];
    if (currentItemIndex < self.itemCount) {
        [self.mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentItemIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

- (void)disableScrollGesture {
    self.mainView.canCancelContentTouches = NO;
    for (UIGestureRecognizer *gesture in self.mainView.gestureRecognizers) {
        if ([gesture isKindOfClass:[UIPanGestureRecognizer class]]) {
            [self.mainView removeGestureRecognizer:gesture];
        }
    }
}

- (void)scrollToNextIndex {
    if (0 == self.itemCount) return;
    NSInteger currentIndex = [self currentItemIndex];
    [self scrollToItemIndex:currentIndex + 1];
}

- (void)scrollToPreviousIndex {
    if (0 == self.itemCount) return;
    NSInteger currentIndex = [self currentItemIndex];
    [self scrollToItemIndex:currentIndex - 1];
}

- (void)scrollToIndex:(NSInteger)index {
    [self scrollToIndex:index animated:YES];
}

- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated {
    if (0 == self.itemCount) return;
    if (index > self.dataCount - 1 || index < 0) {
        return;
    }
    
    NSInteger itemIndex = index;
    if (self.infiniteLoop) {
        NSInteger currentItemIndex = [self currentItemIndex];
        NSInteger multiple = currentItemIndex / self.dataCount;
        itemIndex = multiple * self.dataCount + index;
    }
    
    [self scrollToItemIndex:itemIndex animated:animated];
}

- (void)registerClass:(nullable Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    [self.mainView registerClass:cellClass forCellWithReuseIdentifier:identifier];
}

- (__kindof UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)identifier forIndex:(NSInteger)index {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    return [self.mainView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
}

#pragma mark - private

/// item序号
- (NSInteger)currentItemIndex {
    NSInteger index = 0;
    if (self.flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (self.mainView.contentOffset.x + self.flowLayout.itemSize.width * 0.5) / self.flowLayout.itemSize.width;
    } else {
        index = (self.mainView.contentOffset.y + self.flowLayout.itemSize.height * 0.5) / self.flowLayout.itemSize.height;
    }
    
    return MAX(0, index);
}

/// item序号 转 数据序号
- (NSInteger)currentIndexWithCurrentItemIndex:(NSInteger)index {
    return index % self.dataCount;
}

/// 数据序号
- (NSInteger)currentIndex {
    return self.currentItemIndex % self.dataCount;
}

/// 滚动到某个item序号，有动画
- (void)scrollToItemIndex:(NSInteger)index {
    [self scrollToItemIndex:index animated:YES];
}

/// 滚动到某个item序号
- (void)scrollToItemIndex:(NSInteger)index animated:(BOOL)animated {
    if (0 == self.itemCount) return;
    if (index > self.itemCount - 1 || index < 0) {
        return;
    }
    
    [self.mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    self.dataCount = 0;
    if ([self.dataSource respondsToSelector:@selector(numberOfItemsInCycleScrollView:)]) {
        self.dataCount = [self.dataSource numberOfItemsInCycleScrollView:self];
    }
    
    self.itemCount = self.infiniteLoop ? self.dataCount * 10000 : self.dataCount;
    return self.itemCount;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger currentIndex = [self currentIndexWithCurrentItemIndex:indexPath.item];
    
    if ([self.dataSource respondsToSelector:@selector(cycleScrollView:cellForItemAtIndex:)]) {
        return [self.dataSource cycleScrollView:self cellForItemAtIndex:currentIndex];
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger currentIndex = [self currentIndexWithCurrentItemIndex:indexPath.item];
    
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectItemAtIndex:currentIndex];
    }
    if (self.clickItemOperationBlock) {
        self.clickItemOperationBlock(currentIndex);
    }
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(cycleScrollViewDidScroll:)]) {
        [self.delegate cycleScrollViewDidScroll:self];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.delegate respondsToSelector:@selector(cycleScrollViewWillBeginDragging:)]) {
        [self.delegate cycleScrollViewWillBeginDragging:self];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if ([self.delegate respondsToSelector:@selector(cycleScrollViewDidEndDragging:willDecelerate:)]) {
        [self.delegate cycleScrollViewDidEndDragging:self willDecelerate:decelerate];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:self.mainView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    if (!self.dataCount) return;
    
    NSInteger currentItemIndex = self.currentItemIndex;
    NSInteger currentIndex = [self currentIndexWithCurrentItemIndex:currentItemIndex];
    
    if (self.infiniteLoop) {
        if (currentItemIndex >= self.itemCount - self.threshold || currentItemIndex < self.threshold) {
            NSInteger itemIndex = self.itemCount * 0.5 + currentIndex;
            [self.mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:itemIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        }
    }

    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didScrollToIndex:)]) {
        [self.delegate cycleScrollView:self didScrollToIndex:currentIndex];
    }
    if (self.itemDidScrollOperationBlock) {
        self.itemDidScrollOperationBlock(currentIndex);
    }
}

@end
