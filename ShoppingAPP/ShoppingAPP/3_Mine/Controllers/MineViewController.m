//
//  MineViewController.m
//  ShoppingAPP
//
//  Created by qianfeng on 16/1/22.
//  Copyright (c) 2016年 JC. All rights reserved.
//

#import "MineViewController.h"
#import "CommonUtil.h"
#import "FavourTableViewController.h"

@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSArray *_dataArray;
}
@end

@implementation MineViewController

- (void)viewDidAppear:(BOOL)animated{
    [_tableView reloadData];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self createDataArrayOfTable];
    [self createTable];
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.tabBarController.tabBar.hidden = NO;
}
#pragma mark - 创建tableView
- (void)createTable{
    self.automaticallyAdjustsScrollViewInsets = NO;
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, BAR_NAV_HEIGHT, SCREEN_SIZE_WIDTH, SCREEN_SIZE_HEIGHT-BAR_NAV_HEIGHT) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    [self.view addSubview:_tableView];
}

#pragma mark - 创建table数据源
- (void)createDataArrayOfTable{
    NSArray *array1 = @[@"我的收藏",@"清理缓存"];
    NSArray *array2 = @[@"意见反馈",@"AppStore评分",@"感谢作者"];
    _dataArray = @[array1,array2];
}

#pragma mark - 清理缓存
- (void)cleanCache{
    
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:CACHES_PATH];
    NSLog(@"files :%lu",(unsigned long)[files count]);
    for (NSString *filePath in files) {
        NSError *error;
        NSString *path = [CACHES_PATH stringByAppendingPathComponent:filePath];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        }
    }
    [_tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - table代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    NSArray *array = _dataArray[indexPath.section];
    
    cell.textLabel.text = array[indexPath.row];
    cell.textLabel.textColor = COLOR;
    if ([array[indexPath.row] isEqualToString:@"清理缓存"]) {
        
        cell.detailTextLabel.text = [NSString stringWithFormat:@"缓存大小:%.2fMB",[CommonUtil folderSizeAtPath:CACHES_PATH]];
    }
    if ([array[indexPath.row] isEqualToString:@"我的收藏"]) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"收藏个数:%ld",[[CommonUtil readLocalFavourite] count]];
    }
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray[section] count];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"我的";
    }
    return @"关于";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = _dataArray[indexPath.section];
    if ([array[indexPath.row] isEqualToString:@"我的收藏"]) {
        FavourTableViewController *fvc = [[FavourTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.navigationController pushViewController:fvc animated:YES];
    }
    if ([array[indexPath.row] isEqualToString:@"清理缓存"]) {
        [self creatAlertView:@"确定要清理内存么?" actionYES:@selector(cleanCache) actionNO:nil];
    }
}
#pragma mark - 提示
-(void)creatAlertView:(NSString *)string actionYES:(SEL)act1 actionNO:(SEL)act2 {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:string preferredStyle:UIAlertControllerStyleAlert];
    
    WeakSelf(weakSelf);
    //UIAlertAction代表具有按钮外观及按钮动作的类型
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        SuppressPerformSelectorLeakWarning( [weakSelf performSelector:act1]);
    }];
    [alert addAction:action1];
    [alert addAction:action2];
    [self  presentViewController:alert animated:YES completion:nil ];
    
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
