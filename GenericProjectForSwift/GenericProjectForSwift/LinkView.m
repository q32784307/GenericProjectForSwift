//
//  LinkView.m
//  GenericProjectForSwift
//
//  Created by 皮蛋菌 on 2024/5/28.
//

#import "LinkView.h"
#import "GenericProjectForSwift-Swift.h"

@implementation LinkView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [self initWithFrame:frame];
    
    ChildView *child = [[ChildView alloc]init];
    
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
