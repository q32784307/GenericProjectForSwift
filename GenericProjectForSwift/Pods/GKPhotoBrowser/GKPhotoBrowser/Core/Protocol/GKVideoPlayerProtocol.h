//
//  GKVideoPlayerProtocol.h
//  GKPhotoBrowser
//
//  Created by QuintGao on 2023/3/1.
//  Copyright © 2023 QuintGao. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, GKVideoPlayerStatus) {
    GKVideoPlayerStatusPrepared,   // 准备中
    GKVideoPlayerStatusBuffering,  // 缓冲
    GKVideoPlayerStatusPlaying,    // 播放
    GKVideoPlayerStatusPaused,     // 暂停
    GKVideoPlayerStatusEnded,      // 播放结束
    GKVideoPlayerStatusFailed      // 播放失败
};

@class GKPhotoBrowser, GKPhoto;

@protocol GKVideoPlayerProtocol <NSObject>

@property (nonatomic, weak, nullable) GKPhotoBrowser *browser;

@property (nonatomic, strong, nullable) UIView *videoPlayView;

@property (nonatomic, weak) UIImage *coverImage;

@property (nonatomic, strong, nullable) NSURL *assetURL;

@property (nonatomic, readonly) BOOL isPlaying;

@property (nonatomic, readonly) NSTimeInterval currentTime;

@property (nonatomic, readonly) NSTimeInterval totalTime;

@property (nonatomic, readonly) GKVideoPlayerStatus status;

@property (nonatomic, copy) void(^playerStatusChange)(id<GKVideoPlayerProtocol> mgr, GKVideoPlayerStatus status);

@property (nonatomic, copy) void(^playerPlayTimeChange)(id<GKVideoPlayerProtocol> mgr, NSTimeInterval currentTime, NSTimeInterval totalTime);

@property (nonatomic, copy) void(^playerGetVideoSize)(id<GKVideoPlayerProtocol> mgr, CGSize size);

@property (nonatomic, strong, nullable) NSError *error;

// 准备视频资源
- (void)gk_prepareToPlay;

// 播放
- (void)gk_play;

// 重播
- (void)gk_replay;

// 暂停
- (void)gk_pause;

// 停止
- (void)gk_stop;

// seek
- (void)gk_seekToTime:(NSTimeInterval)time completionHandler:(nullable void (^)(BOOL finished))completionHandler;

// 更新布局
- (void)gk_updateFrame:(CGRect)frame;

// 静音
- (void)gk_setMute:(BOOL)mute;

@optional
/// 当前对应的数据模型
@property (nonatomic, weak, nullable) GKPhoto *photo;

@end

NS_ASSUME_NONNULL_END
