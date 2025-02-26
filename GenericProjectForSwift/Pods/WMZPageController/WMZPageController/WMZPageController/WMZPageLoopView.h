//
//  WMZPageLoopView.h
//  WMZPageController
//
//  Created by wmz on 2019/9/22.
//  Copyright © 2019 wmz. All rights reserved.
//

#import "WMZPageConfig.h"
#import "WMZPageDataView.h"
#import "WMZPageMenuView.h"
#import "WMZPageTitleDataModel.h"
#import "WMZPageScroller.h"

@class WMZPageController;

NS_ASSUME_NONNULL_BEGIN

@protocol WMZPageLoopDelegate <NSObject>

@optional
/// 选中按钮
- (void)selectBtnWithIndex:(NSInteger)index;
/// 底部左滑的代理
- (void)pageWithScrollView:(UIScrollView*)scrollView left:(BOOL)left;
/// 底部左滑结束的代理
- (void)pageScrollEndWithScrollView:(UIScrollView*)scrollView;
/// 获取子tableview
- (void)setUpSuspension:(UIResponder*)newVC index:(NSInteger)index end:(BOOL)end;

@end

@interface WMZPageLoopView : UIView
/// 下划线 此列属性和pageMenuView中的是同个
@property (nonatomic, strong) UIButton *lineView;
/// 标题按钮
@property (nonatomic, strong) NSMutableArray <WMZPageNaviBtn*>*btnArr;
/// 固定按钮
@property (nonatomic, strong) NSMutableArray <WMZPageNaviBtn*>*fixBtnArr;
/// 菜单视图
@property (nonatomic, strong) WMZPageMenuView *mainView;
/// 底部视图
@property (nonatomic, strong) WMZPageDataView *dataView;
/// 添加的视图 和mainView 同级
@property (nonatomic, strong) UIView *insertView;
/// 当前index
@property (nonatomic, assign) NSInteger currentTitleIndex;
/// 可能的下一个视图
@property (nonatomic, assign) NSInteger nextPageIndex;
/// 上一个视图
@property (nonatomic, assign) NSInteger lastPageIndex;
/// 是否已经处理了生命周期
@property (nonatomic, assign, getter=isHasDealAppearance) BOOL hasDealAppearance;
/// 是否已经运行了完整的生命周期
@property (nonatomic, assign, getter=isHasEndAppearance) BOOL hasEndAppearance;
/// 是否往相反方向滑动
@property (nonatomic, assign, getter=isHasDifferenrDirection) BOOL hasDifferenrDirection;
/// 屏幕旋转
@property (nonatomic, assign, getter=isChangeDevice) BOOL changeDevice;
/// 当前显示VC
@property (nonatomic, strong, nullable) UIViewController *currentVC;
/// 代理
@property (nonatomic, weak) id <WMZPageLoopDelegate> loopDelegate;
/// 父类 实现协议WMZPageScrollProcotol
@property (nonatomic, weak) UIResponder *parentResponder;
/// 缓存
@property (nonatomic, strong) NSMutableDictionary<NSNumber*, UIResponder*> *cache;

@property (nonatomic, assign) CGFloat pageWidth;
/// 初始化
- (instancetype)initWithFrame:(CGRect)frame
                        param:(WMZPageParam*)param
               parentReponder:(UIResponder*)parentReponder;
///loadUI
- (void)loadUI:(CGFloat)width clear:(BOOL)clear;
@end

NS_ASSUME_NONNULL_END
