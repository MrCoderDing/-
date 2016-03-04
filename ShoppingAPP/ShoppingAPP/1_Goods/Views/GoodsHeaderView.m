//
//  GoodsHeaderView.m
//  ShoppingAPP
//
//  Created by qianfeng on 16/1/27.
//  Copyright (c) 2016年 JC. All rights reserved.
//

#import "GoodsHeaderView.h"
#import "GoodsAddsModel.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"

@interface GoodsHeaderView()<UIScrollViewDelegate>
{
    UIScrollView *_scroll;//广告
    NSArray *_addsArray;//广告数据
    UIPageControl* _pageCtrl;//广告pageControl
    NSUInteger _addsNums;//广告数量
    NSTimer *_timer;
    
}

@end
@implementation GoodsHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //创建广告scrollView
        [self createScrollView];
        //广告自滚动开启
        [self startTimer];
    }
    return self;
}

#pragma mark - 添加广告滚动视图
- (void)createScrollView{
    
    _scroll = [[UIScrollView alloc] initWithFrame:self.frame];
    _scroll.pagingEnabled = YES;
    _scroll.delegate = self;
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.showsVerticalScrollIndicator = NO;
    [self addSubview:_scroll];
    [self loadNetAdds];
    //创建pagecontrol
    _pageCtrl = [[UIPageControl alloc] init];
    // pageControl约束
    [self addSubview:_pageCtrl];
    [_pageCtrl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(50) ;
        make.centerX.equalTo(_scroll.mas_centerX);
        make.bottom.equalTo(_scroll.mas_bottom).offset(10);
    }];
    
}
#pragma mark - 载入滚动广告
- (void)loadNetAdds{

    [GoodsAddsDataModel arrayOfGoodsAddsModels:^(NSArray *arrayOfModels) {
        
        _addsNums = arrayOfModels.count;
        _addsArray = [arrayOfModels copy];
        _scroll.contentSize = CGSizeMake((_addsNums+1)*CGRectGetWidth(_scroll.frame), 0);
        _pageCtrl.numberOfPages = _addsNums;
        
        for (int i = 0; i<arrayOfModels.count+1; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0+_scroll.frame.size.width*i, 0, _scroll.frame.size.width,_scroll.frame.size.height)];
            
            imgView.tag = 200+i;
            imgView.userInteractionEnabled = YES;
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
            [imgView addGestureRecognizer:tap];
            
            NSURL *url = nil;
            AdvModel *model = nil;
            if(i == arrayOfModels.count){
                model = arrayOfModels[0];
            }else{
                model = arrayOfModels[i];
            }
            url = [NSURL URLWithString:model.iphonemimg];
            [imgView setImageWithURL:url];
            [_scroll addSubview:imgView];
            
        }
    }];
}
#pragma mark - 广告点击事件
-(void)tapClick:(UITapGestureRecognizer *)tap{
    AdvModel *model = nil;
    if ((tap.view.tag - 200) == _addsNums) {
        model = _addsArray[0];
    }else{
        model =_addsArray[tap.view.tag - 200];
    }
    if (self.UrlBlock) {
         self.UrlBlock(model.link,model.title);
    }
   
}

#pragma mark - ScrollView 代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    NSUInteger page = scrollView.contentOffset.x/scrollView.frame.size.width;
    
    if (page == _addsNums) {
        page = 0;
    }
    _pageCtrl.currentPage = page;
    if (scrollView.contentOffset.x>_addsNums*scrollView.frame.size.width) {
        [scrollView setContentOffset:CGPointMake(0, 0)];
    }
    if (scrollView.contentOffset.x<0) {
        [scrollView setContentOffset:CGPointMake((_addsNums)*scrollView.frame.size.width, 0) ];
    }
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self stopTimer];
    [self performSelector:@selector(startTimer) withObject:nil afterDelay:5];
    
}
#pragma mark - 定时器方法
-(void)startTimer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(scroll) userInfo:nil repeats:YES];
    }
}
-(void)stopTimer{
 
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
#pragma mark - 自动滚动
-(void)scroll{
    [_scroll setContentOffset:CGPointMake(_scroll.contentOffset.x+_scroll.frame.size.width, 0) animated:YES];
    if (_scroll.contentOffset.x >= _addsNums*_scroll.frame.size.width) {
        [_scroll setContentOffset:CGPointMake(0, 0)];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
