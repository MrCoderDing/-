//
//  GoodsViewController.m
//  ShoppingAPP
//
//  Created by qianfeng on 16/1/22.
//  Copyright (c) 2016年 JC. All rights reserved.
//

#import "GoodsViewController.h"
#import "UIImageView+WebCache.h"
#import "Masonry.h"
#import "GoodsHeaderView.h"
#import "GoodsCollectionViewCell.h"
#import "Network.h"
#import "GoodsModel.h"
#import "UIImageView+WebCache.h"
#import "WebViewController.h"
#import "UIImage+ResizeImage.h"
#import "CommonUtil.h"
#import "MJRefresh.h"
#import "SDWebImageManager.h"
#import "RefreshHeader.h"


@interface GoodsViewController ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{
    UICollectionView *_collectionView;
    NSMutableArray *_dataArray;//数据
    NSMutableArray *_dataArrayCopy;
    NSNumber *_pageMark;
    UIView *_myBar;
    float lastContentOffset;//记录滚动位置
}
@end

@implementation GoodsViewController

#pragma mark - 重写sort set方法
-(void)setCid:(NSNumber *)cid{
    _cid = cid;
    if (_dataArrayCopy) {
        [_dataArrayCopy removeAllObjects];
    }
    [self loadNetData];
    [self loading];
}


#pragma mark - 单例
+(instancetype)defaultGoodsViewController{
    
    static GoodsViewController *defaultVC = nil;
    static dispatch_once_t onecToken;
    dispatch_once(&onecToken, ^{
        defaultVC = [[GoodsViewController alloc] init];
    });
    return defaultVC;
}

#pragma mark - UI加载
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数据源
    _dataArray = [[NSMutableArray alloc]init];
    _dataArrayCopy = [[NSMutableArray alloc] init];
    //设置初始页码
    _pageMark = @1;
    //设置初始分类为不分类
    self.cid = @0;
    //隐藏自带navigationBar
    self.navigationController.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    //加载自定义bar
    [self createCustomBar];
    //加载collecionView
    [self createCollectionView];
    //加载等待画面
    [self loading];
}


#pragma mark - 等待动画
/**
 *  主界面加载等待画面
 */
- (void)loading{
    [CommonUtil addLoadingViewOn:self.view];
}
/**
 *  主界面移除等待画面
 */
- (void)loadingOff{
    [CommonUtil removeLoadingViewOn:self.view];
}

#pragma mark - 提示
-(void)creatAlertView:(NSString *)string{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    //UIAlertAction代表具有按钮外观及按钮动作的类型
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    [alert addAction:action1];
    [self  presentViewController:alert animated:YES completion:nil ];
    
}
#pragma mark - 加载网络数据
- (void)loadNetData{
    
    __weak typeof(*&self)weakSelf = self;

   [GoodsModel arrayOfGoodsModels:^(NSArray *arrayOfModels) {
       if (arrayOfModels) {
           [weakSelf loadingOff];
           [_dataArrayCopy addObjectsFromArray:arrayOfModels];
           _dataArray = [_dataArrayCopy mutableCopy];
           [_collectionView reloadData];
           [_collectionView.mj_header endRefreshing];
           [_collectionView.mj_footer endRefreshing];
       }else{
           [self creatAlertView:@"网络连接错误,请检查网络是否开启"];
           [weakSelf loadingOff];
       }
       if (arrayOfModels.count==0) {
           [self creatAlertView:@"无更多数据"];
           [weakSelf loadingOff];
       }
   } andCid:_cid andPage:_pageMark];
    
}

#pragma mark - 刷新与载入更多
- (void)refresh{
    [self loading];
    _pageMark = @1;
    [_dataArrayCopy removeAllObjects];
//     [self loading];
    [self loadNetData];
}
-(void)loadMore{
    [self loading];
    _pageMark = [NSNumber numberWithInt:(_pageMark.intValue + 1)];
//    [self loading];
    [self loadNetData];
}

- (void)turnToTop{
    [_collectionView setContentOffset:CGPointMake(0, 0)];
}


#pragma mark - 添加自定义的navigationBar
- (void)createCustomBar{

    _myBar = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_SIZE.origin.x, SCREEN_SIZE.origin.y, SCREEN_SIZE.size.width, 64)];
    [_myBar setBackgroundColor:COLOR];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *img = [UIImage imageNamed:@"Home_Icon@2x"];
    img = [UIImage reSizeImage:img toSize:CGSizeMake(30, 30)];
   
    [btn setImage:img forState:UIControlStateNormal];
    btn.frame = CGRectMake(5, 20, 40, 40);
    [btn addTarget:self action:@selector(openDrawer:) forControlEvents:UIControlEventTouchUpInside];
    [_myBar addSubview:btn];
    [self.view addSubview:_myBar];
    
    _titleLabel      = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
    _titleLabel.center        = _myBar.center;
    _titleLabel.textColor     = [UIColor whiteColor];
    _titleLabel.text          = @"折扣乐不停";
    _titleLabel.font          = [UIFont boldSystemFontOfSize:18];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_myBar addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_myBar.mas_bottom).offset(-10);
        make.centerX.equalTo(_myBar.mas_centerX);
    }];
    
}
#pragma mark - 创建tableView
- (void)createCollectionView{
   
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize                    = CGSizeMake((SCREEN_SIZE_WIDTH - 25)/2.0, (SCREEN_SIZE_WIDTH - 25)/2.0+60);
    layout.minimumInteritemSpacing     = 5;
    layout.minimumLineSpacing          = 10;
    //设置滚动的方式
    layout.scrollDirection             = UICollectionViewScrollDirectionVertical;
    layout.sectionInset                = UIEdgeInsetsMake(10, 10, 30, 10);
    _collectionView                    = [[UICollectionView alloc] initWithFrame:CGRectMake(0, BAR_HEIGHT, SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT-BAR_HEIGHT) collectionViewLayout:layout];
    _collectionView.delegate           = self;
    _collectionView.dataSource         = self;
    _collectionView.backgroundColor    = [UIColor whiteColor];
    _collectionView.bounces            = YES;
    [self.view addSubview:_collectionView];
   
    //注册cell
    [_collectionView registerNib:[UINib nibWithNibName:@"GoodsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell1"];
    //注册header
    [_collectionView registerClass:[GoodsHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" ];
    
    
    
    
    
    RefreshHeader *refreshHeader = [RefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
    refreshHeader.lastUpdatedTimeLabel.hidden = YES;
    refreshHeader.stateLabel.hidden = YES;
    _collectionView.mj_header = refreshHeader;
    _collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMore)];
    lastContentOffset = _collectionView.contentOffset.y;
    
 }

#pragma mark - CollectionView 代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    GoodsCollectionViewCell *Cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell1" forIndexPath:indexPath];
    if(Cell == nil){
        Cell=[[[NSBundle mainBundle]loadNibNamed:@"GoodsCollectionViewCell" owner:nil options:nil] firstObject];
    }
    GoodsModel *model = _dataArray[indexPath.row];
     [Cell.img setImageWithURL:[NSURL URLWithString:model.pic_url] placeholderImage:[UIImage animatedImageNamed:@"loading" duration:1]];
    Cell.name.text = model.title;
    float nowprice = model.now_price.floatValue;
    float oldprice = model.origin_price.floatValue;
    int deal       = model.deal_num.intValue;
//    NSLog(@"%d",deal);
    Cell.nowPrice.text = [NSString stringWithFormat:@"￥%.2f",nowprice];
    Cell.oldPrice.text = [NSString stringWithFormat:@"原价%.2f",oldprice];
    Cell.dealnum.text  = [NSString stringWithFormat:@"销量%d",deal];
    return Cell;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    __weak GoodsViewController *weakSelf = self;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        GoodsHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        headerView.UrlBlock = ^(NSString *url,NSString *title){
            [weakSelf gotoWebView:url andTitle:title ];
        };
        return headerView;
    }else{
        return nil;
    }
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(SCREEN_SIZE_WIDTH, 150);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
     GoodsModel *model = _dataArray[indexPath.row];
    UIImageView *imgV = [UIImageView new];
    [imgV setImageWithURL:[NSURL URLWithString:model.pic_url]];
    [self gotoWebView:model.item_url andTitle:model.title andimg: imgV.image];
}


#pragma mark - ScrollView 代理方法,实现隐藏动画

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y>64) {
        if (lastContentOffset <= scrollView.contentOffset.y ) {
            //隐藏
            [UIView animateWithDuration:0.5 animations:^{
                self.navigationController.tabBarController.tabBar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame),CGRectGetWidth(self.view.frame) , CGRectGetHeight(self.navigationController.tabBarController.tabBar.frame)) ;
//                _myBar.alpha = 0;
//                 _myBar.frame = CGRectMake(0, 0, SCREEN_SIZE_WIDTH, 22);
                _collectionView.frame = CGRectMake(0, 22, SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT);
                [self.view bringSubviewToFront:_collectionView];
            }];
            lastContentOffset = scrollView.contentOffset.y;
        }else{
            //显示
            [UIView animateWithDuration:0.5 animations:^{
                self.navigationController.tabBarController.tabBar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame)-CGRectGetHeight(self.navigationController.tabBarController.tabBar.frame),CGRectGetWidth(self.view.frame) , CGRectGetHeight(self.navigationController.tabBarController.tabBar.frame)) ;
//                _myBar.alpha = 1;
//                _myBar.frame = CGRectMake(0, 0, SCREEN_SIZE_WIDTH, 64);
                _collectionView.frame = CGRectMake(0, BAR_HEIGHT, SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT-64);
            }];
            lastContentOffset = scrollView.contentOffset.y;
        }
    }
}

#pragma mark - 跳转webview
- (void)gotoWebView:(NSString *)url andTitle:(NSString *)title andimg:(UIImage *)img{
//    [CommonUtil gotoWebView:url andTitle:title At:self];
    [CommonUtil gotoWebView:url andTitle:title andImg:img At:self];
    NSLog(@" gotowebvie:   %@",img);
}
- (void)gotoWebView:(NSString *)url andTitle:(NSString *)title {
        [CommonUtil gotoWebView:url andTitle:title At:self];

}

#pragma mark - 抽屉开启
- (void)openDrawer:(UIButton *)button{
    
    [self.drawer open];

}
#pragma mark ----------------view’s layout behavior--------------------
- (BOOL)prefersStatusBarHidden{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark ----------------ICSDrawerControllerPresenting--------------------
- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController{
    self.view.userInteractionEnabled = NO;
//    self.navigationController.tabBarController.tabBar.hidden = YES;
    [UIView animateWithDuration:0.3 animations:^{
         self.navigationController.tabBarController.tabBar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame),CGRectGetWidth(self.view.frame) , CGRectGetHeight(self.navigationController.tabBarController.tabBar.frame)) ;
    }];
}
-(void)drawerControllerWillClose:(ICSDrawerController *)drawerController{
    [UIView animateWithDuration:0.3 animations:^{
        self.navigationController.tabBarController.tabBar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame)-CGRectGetHeight(self.navigationController.tabBarController.tabBar.frame),CGRectGetWidth(self.view.frame) , CGRectGetHeight(self.navigationController.tabBarController.tabBar.frame)) ;
    }];
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.tabBarController.tabBar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame)-CGRectGetHeight(self.navigationController.tabBarController.tabBar.frame),CGRectGetWidth(self.view.frame) , CGRectGetHeight(self.navigationController.tabBarController.tabBar.frame)) ;
        _myBar.alpha = 1;
        _collectionView.frame = CGRectMake(0, BAR_HEIGHT, SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT-BAR_HEIGHT);
    }];

}

- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController{
    self.view.userInteractionEnabled = YES;
//    self.navigationController.tabBarController.tabBar.hidden = NO;
   
}





































- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
