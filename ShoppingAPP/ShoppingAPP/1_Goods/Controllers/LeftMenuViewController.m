//
//  LeftMenuViewController.m
//  ShoppingAPP
//
//  Created by qianfeng on 16/1/25.
//  Copyright (c) 2016年 JC. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "GoodsViewController.h"
#import "UIImage+RTTint.h"


static NSString * const CellReuseId = @"JC_Cell";

@interface LeftMenuViewController ()
@property(nonatomic,strong)NSArray *tabArr; //菜单选项
@property (nonatomic,strong) UITableView *tabelView;
@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createMenu];
    [self.view addSubview:self.tabelView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)creatBGImg{
    
}
#pragma mark - 建立菜单
- (void)createMenu{
    
    self.tabArr = @[@"数码控",@"丽人街",@"男人装",@"生活家",@"妈妈说",@"鞋包汇",@"爱运动",@"聚美妆",@"文娱馆"];
    
}

#pragma mark - tableView协议
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tabArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseId];
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.textLabel.text = self.tabArr[indexPath.row];
//    cell.textLabel.textAlignment = NSTextAlignmentCenter;
//    cell.textLabel.textColor = COLOR;
//    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"a%ld",(long)indexPath.row]];
    [cell.imageView setImage:img];
    return cell;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 250;
//}

/**
 *  点击事件
 *
 *  @param tableView tableview
 *  @param indexPath 传递菜单mark
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.drawer reloadCenterViewControllerUsingBlock:^{
        
        
        GoodsViewController *goodsVC = [GoodsViewController defaultGoodsViewController];
        if(indexPath.row == 8){
            goodsVC.cid = @10;
        }else{
            goodsVC.cid = [NSNumber numberWithInteger:indexPath.row+1];
        }
        goodsVC.titleLabel.text = self.tabArr[indexPath.row];
        [goodsVC turnToTop];
    }];
}


#pragma mark - tableView 懒加载
- (UITableView *)tabelView{
    if (!_tabelView) {
       
        _tabelView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tabelView.delegate = self;
        _tabelView.dataSource = self;
        [_tabelView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellReuseId];
        UIView *view = [UIView new];
        _tabelView.tableFooterView = view;
        _tabelView.backgroundColor = COLOR;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_SIZE_WIDTH, 22)];
        _tabelView.tableHeaderView = imgView;
        _tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;

    }
    return _tabelView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

#pragma mark - ICSDrawerControllerPresenting

- (void)drawerControllerWillOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidOpen:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
}

- (void)drawerControllerWillClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = NO;
}

- (void)drawerControllerDidClose:(ICSDrawerController *)drawerController
{
    self.view.userInteractionEnabled = YES;
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
