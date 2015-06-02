//
//  AccountViewController.m
//  FreeLiving
//
//  Created by 岳宗申 on 15/6/1.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import "AccountViewController.h"
#import "DBManager.h"
#import "AccountModel.h"
#import "InputTextView.h"
#import "AccountDetailViewController.h"

@interface AccountViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UIActionSheetDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UITableView *tableView;

@property (strong,nonatomic) NSMutableArray  *dataList;
@property (strong,nonatomic) NSMutableArray  *searchList;

@property (nonatomic, strong) InputTextView *inputView;
@end

@implementation AccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号密码";
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAccountModel)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    if ([DBManager createAccount_Table]) {
        self.dataList = [DBManager getAllAccountModel];
    }
    else
    {
        NSLog(@"创建账号密码表失败");
    }
    [self searchController];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
#pragma mark -private methods-
//添加数据
- (void)addAccountModel
{
    [self.view addSubview:self.inputView];
    [self.inputView createInputView];
}
#pragma mark -UITableViewDataSource-

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    if (self.searchController.active) {
        return [self.searchList count];
    }else{
        return [self.dataList count];
    }
}
- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"mycell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
    }
    AccountModel *aModel = nil;
    if (self.searchController.active) {
        aModel = self.searchList[indexPath.row];
    }
    else{
        aModel = self.dataList[indexPath.row];
    }
    [cell.textLabel setText:aModel.accountString];
    [cell.detailTextLabel setText:aModel.createTime];
    if ([aModel.isImportant integerValue] == 1) {
        cell.imageView.image = [UIImage imageNamed:@"hw_fore_stars"];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"hw_fore_space"];
    }
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确定要删除此分类下的所有账户信息么" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil,nil];
        [actionSheet showInView:self.view];
        actionSheet.tag = indexPath.row;
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
#pragma mark -UITableViewDelegate-

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.searchController.active) {
        self.searchController.active = NO;
    }
    AccountModel *aModel = nil;
    if (self.searchController.active) {
        aModel = self.searchList[indexPath.row];
    }
    else{
        aModel = self.dataList[indexPath.row];
    }
    AccountDetailViewController *detailVC = [[AccountDetailViewController alloc] init];
    detailVC.detailModel = aModel;
    [self.navigationController pushViewController:detailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -UIActionSheetDelegate-
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self setEditing:NO];
    if (buttonIndex == 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:actionSheet.tag inSection:0];
        AccountModel *aModel = self.dataList[indexPath.row];
        if ([DBManager deleteAccountModel:aModel.createTime]) {
            [self.dataList removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        else
        {
            UIAlertView *alerV = [[UIAlertView alloc] initWithTitle:@"提示" message:@"删除数据失败" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alerV show];
        }
    }
}
#pragma mark -UISearchResultsUpdating-

-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    NSString *searchString = [self.searchController.searchBar text];
    
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"accountString CONTAINS[c] %@", searchString];
    
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    //过滤数据
    self.searchList= [NSMutableArray arrayWithArray:[_dataList filteredArrayUsingPredicate:preicate]];
    //刷新表格
    
    [self.tableView reloadData];
}
#pragma mark -getters and setters-
- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = UITableView.new;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 60;
    }
    return _tableView;
}
- (UISearchController *)searchController
{
    if (_searchController == nil) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        
        _searchController.searchResultsUpdater = self;
        
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
        _searchController.searchBar.placeholder = @"输入账号";
        self.tableView.tableHeaderView = _searchController.searchBar;
    }
    return _searchController;
}
- (InputTextView *)inputView
{
    if (_inputView == nil) {
        _inputView = [[InputTextView alloc] initWithFrame:self.view.frame];
        _inputView.backgroundColor = [UIColor colorWithRed:0x20/255.0 green:0x1d/255.0 blue:0x1e/255.0 alpha:0.4];
        _inputView.removeInputViewAcion = ^(void)
        {
            _inputView = nil;
        };
        __weak AccountViewController *weakSelf = self;
        _inputView.addAccountModelAction = ^(AccountModel *aModel)
        {
            [weakSelf.dataList insertObject:aModel atIndex:0];
            [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [DBManager saveAccountModel:aModel];
        };
    }
    return _inputView;
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
