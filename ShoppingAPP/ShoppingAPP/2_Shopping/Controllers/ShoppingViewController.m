//
//  ShoppingViewController.m
//  ShoppingAPP
//
//  Created by qianfeng on 16/1/22.
//  Copyright (c) 2016年 JC. All rights reserved.
//

#import "ShoppingViewController.h"
#import "BaseTableViewController.h"
#import "Masonry.h"
#import "CommonUtil.h"
#import "BaseNavigationController.h"


@interface ShoppingViewController ()<UIScrollViewDelegate>
{
    UIScrollView *_contentView; //用来显示每一个子控制器的view
    UIViewController *_currentViewController;
    NSArray *_titleArray;//存放主题名
    UIScrollView *_titleBar;//显示标题按钮
    UIView *_myBar;
    UILabel *_titleLabel;
    NSArray *_tabID;
    BOOL _btnClick;
    UIButton *_oldBtn;
}
@end

@implementation ShoppingViewController

- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self createTitleBar];
    [self loadViewControllers];
    [self creatContentView];
}
#pragma mark - 创建滑动标题
- (void)createTitleBar{

    //不自动调整scrollview 
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.frame = CGRectMake(0, BAR_NAV_HEIGHT, SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT-BAR_NAV_HEIGHT);
    
    //标题数据
    _titleArray = @[@"最新上架",@"臭美妞",@"生活家",@"骚包男",@"吃不胖",@"魔法镜",@"爱运动",@"熊孩子",@"数码控"];
    _tabID = @[@0,@5,@2,@4,@3,@7,@6,@8,@1];
    //设置标题的scrollview
    _titleBar = [[UIScrollView alloc] initWithFrame:CGRectMake(0, BAR_NAV_HEIGHT, SCREEN_SIZE_WIDTH, TITLE_BAR_HEIGHT)];
    _titleBar.backgroundColor = [UIColor whiteColor];
    _titleBar.autoresizingMask = NO;
    _titleBar.bounces=NO;
    _titleBar.showsHorizontalScrollIndicator = NO;
    [_titleBar setContentSize:CGSizeMake(_titleArray.count*(BUTTON_WIDTH+5) , 0)];
    [self.view addSubview:_titleBar];
    //创建标题按钮
    for (int i = 0; i<_titleArray.count; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i*(BUTTON_WIDTH+5), 0, BUTTON_WIDTH, TITLE_BAR_HEIGHT);
        [btn setTitle:_titleArray[i] forState:UIControlStateNormal];
        if(i==0)
        {
            _oldBtn = btn;
            [self changeColorForButton:btn red:1];
            btn.titleLabel.font = [UIFont systemFontOfSize:MAX_MENU_FONT];
        }else
        {
            btn.titleLabel.font = [UIFont systemFontOfSize:MIN_MENU_FONT];
            [self changeColorForButton:btn red:0];
        }
        btn.tag = i+1;
        [btn addTarget:self action:@selector(actionbtn:) forControlEvents:UIControlEventTouchUpInside];
        [_titleBar addSubview:btn];
    }
}
#pragma mark -  改变 Button 字体颜色
- (void)changeColorForButton:(UIButton *)btn red:(float)nRedPercent
{
    float value = [CommonUtil lerp:nRedPercent min:0 max:253];
    [btn setTitleColor:RGBA(value,20,20,1) forState:UIControlStateNormal];
}
#pragma mark - 滚动标题点击事件
- (void)actionbtn:(UIButton *)btn
{
    _btnClick = YES;
    [_contentView setContentOffset:CGPointMake(_contentView.frame.size.width * (btn.tag - 1), 0) animated:YES];
    float xx = _contentView.frame.size.width * (btn.tag - 1) * (BUTTON_WIDTH / SCREEN_SIZE_WIDTH) - 2*BUTTON_WIDTH;
    if (xx<=-70) {
        [_titleBar setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if (xx>=_titleBar.contentSize.width - SCREEN_SIZE_WIDTH) {
        [_titleBar setContentOffset:CGPointMake(_titleBar.contentSize.width - SCREEN_SIZE_WIDTH, 0) animated:YES];
    }
    else{
        [_titleBar setContentOffset:CGPointMake(xx, 0) animated:YES];
    }
    [UIView animateWithDuration:0.5 animations:^{
        [self changeBtn:_oldBtn ColorAndFontSize:NO];
        [self changeBtn:btn ColorAndFontSize:YES];
    }];
    _oldBtn = btn;
  
    
}
#pragma mark - 改变 Button字体和颜色
- (void)changeBtn:(UIButton *)btn ColorAndFontSize :(BOOL) isBig{
    if (isBig) {
        [self changeColorForButton:btn red:1];
        btn.titleLabel.font = [UIFont systemFontOfSize:MAX_MENU_FONT];
    }else{
        [self changeColorForButton:btn red:0];
        btn.titleLabel.font = [UIFont systemFontOfSize:MIN_MENU_FONT];
    }
}
#pragma mark - titleBar动画
- (void)changeView:(float)x
{
    if (!_btnClick) {
        //titleBar 偏移量
        float xx = x * (BUTTON_WIDTH / SCREEN_SIZE_WIDTH);
        
        float startX = xx;
        //    float endX = xx + MENU_BUTTON_WIDTH;
        
        //目标btn Tag值
        int sTag = (x)/_contentView.frame.size.width + 1;
        if (sTag <= 0)
        {
            return;
        }
        //目标btn
        UIButton *btn = (UIButton *)[_titleBar viewWithTag:sTag];
        float percent = (startX - BUTTON_WIDTH * (sTag - 1))/BUTTON_WIDTH;
        float value = [CommonUtil lerp:(1 - percent) min:MIN_MENU_FONT max:MAX_MENU_FONT];
        btn.titleLabel.font = [UIFont systemFontOfSize:value];
        [self changeColorForButton:btn red:(1 - percent)];
        
        if((int)xx%BUTTON_WIDTH == 0)
            return;
        UIButton *btn2 = (UIButton *)[_titleBar viewWithTag:sTag + 1];
        float value2 = [CommonUtil lerp:percent min:MIN_MENU_FONT max:MAX_MENU_FONT];
        btn2.titleLabel.font = [UIFont systemFontOfSize:value2];
        [self changeColorForButton:btn2 red:percent];
        if (percent>0.5) {
            _oldBtn = btn2;
        }else{
            _oldBtn = btn;
        }
    }
}
#pragma mark - 创建子视图
- (void)loadViewControllers{
    NSMutableArray *mArr = [NSMutableArray array];
    for (int i = 0; i<9; i++) {
        BaseTableViewController *base = [[BaseTableViewController alloc] initWithStyle:UITableViewStylePlain];
        
        base.tabID = _tabID[i];
        //第一个直接加载并显示数据,其他页面只做tabID设置,页面将要出现时加载并显示数据
        if(i==0){
            [base loadDataBy:_tabID[0]];
        }
        [mArr addObject:base];
        
        [self addChildViewController:base];
    }
    self.viewControllers = [NSArray arrayWithArray:mArr];
    
//    [self addChildViewController:BASE];
    
}
#pragma mark - scroll结束拖拽
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float xx = scrollView.contentOffset.x * (BUTTON_WIDTH / self.view.frame.size.width) - 2*BUTTON_WIDTH;
    if (xx<=0) {
         [_titleBar setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else if (xx>=_titleBar.contentSize.width - SCREEN_SIZE_WIDTH) {
         [_titleBar setContentOffset:CGPointMake(_titleBar.contentSize.width - SCREEN_SIZE_WIDTH, 0) animated:YES];
    }
    else{
         [_titleBar setContentOffset:CGPointMake(xx, 0) animated:YES];
    }
//    NSLog(@"scrollViewDidEndDecelerating:%lg",xx);
//    [_titleBar setContentOffset:CGPointMake([self getTitleBarSetByScrollView:scrollView], 0) animated:YES];
//    
    NSInteger index = scrollView.contentOffset.x / SCREEN_SIZE_WIDTH;
    self.navigationItem.title = _titleArray[index];
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / SCREEN_SIZE_WIDTH;
    self.navigationItem.title = _titleArray[index];
     _btnClick = NO;

}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
      _btnClick = NO;
}


#pragma mark - 得到titleBar偏移坐标
- (float)getTitleBarSetByScrollView:(UIScrollView *)scrollView{
    float xx = scrollView.contentOffset.x * (BUTTON_WIDTH / self.view.frame.size.width) - BUTTON_WIDTH;
    if (xx<=0) {
        return 0;
    }
    else if (xx>=SCREEN_SIZE_WIDTH) {
        return _titleBar.contentOffset.x;
    }
    else{
        return xx;
    }
}
#pragma mark - 显示当前view
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{

    NSInteger index = scrollView.contentOffset.x / SCREEN_SIZE_WIDTH;
//    UIViewController *vc = self.viewControllers[index];
    UIViewController *vc = self.childViewControllers[index];
    if (_currentViewController != vc)
    {
      
        [vc beginAppearanceTransition:YES animated:YES];
        [vc endAppearanceTransition];
        _currentViewController = vc;
    }
    
    //细节变化
    [self changeView:scrollView.contentOffset.x];
    
}
- (BOOL)shouldAutomaticallyForwardAppearanceMethods
{
    return NO;
}
#pragma mark - 设置contentView
- (void)creatContentView{
    _contentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,TITLE_BAR_HEIGHT+BAR_NAV_HEIGHT, SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT-TITLE_BAR_HEIGHT-BAR_NAV_HEIGHT)];
    [self.viewControllers enumerateObjectsUsingBlock:^(UITableViewController *obj, NSUInteger idx, BOOL *stop) {
        
        UIView *v = obj.tableView;

        v.frame = CGRectMake(SCREEN_SIZE_WIDTH*idx, 0, SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT);

        [_contentView addSubview:v];
        [obj didMoveToParentViewController:self];
    }];

    //设置contentSize_
    _contentView.contentSize = CGSizeMake(self.viewControllers.count * SCREEN_SIZE_WIDTH, 0);
    self.view.frame =CGRectMake(0, 0, SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT);
    
    [self.view addSubview:_contentView];
    
    //通过代理方法来监听当前_contentView的滚动位置
    _contentView.delegate = self;
    _contentView.pagingEnabled = YES;
    _contentView.showsHorizontalScrollIndicator = NO;
    _contentView.showsVerticalScrollIndicator = NO;
    
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
