//
//  FavourTableViewController.m
//  ShoppingAPP
//
//  Created by qianfeng on 16/2/22.
//  Copyright © 2016年 JC. All rights reserved.
//

#import "FavourTableViewController.h"
#import "CommonUtil.h"
@interface FavourTableViewController ()
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation FavourTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
}
- (NSMutableArray *)dataArray{
    NSDictionary *dict = [CommonUtil readLocalFavourite] ;
    _dataArray = [NSMutableArray array];
    for (NSString *key in dict) {
        [_dataArray addObject:key];
    }
    return _dataArray;
}
- (void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.tabBarController.tabBar.hidden = NO;
    [self.tableView reloadData];
}
- (void)initUI{
    UIBarButtonItem *rightitem = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(rightClick:)];
    self.navigationItem.rightBarButtonItem = rightitem;
    self.tableView.tableFooterView = [UIView new];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)rightClick:(UIBarButtonItem *)item{
    //通过属性editing来控制tableView是否进入编辑状态
    if(self.tableView.editing==NO){
        self.tableView.editing = YES;
        item.title = @"完成";
    }else{
        self.tableView.editing = NO;
        item.title = @"编辑";
    }
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellid";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [CommonUtil gotoWebView:[CommonUtil readUrlByTitle:self.dataArray[indexPath.row]] andTitle:self.dataArray[indexPath.row] At:self];
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [CommonUtil delectLocalFavouriteByTitle:self.dataArray[indexPath.row]];
//        [self.dataArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
    
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
