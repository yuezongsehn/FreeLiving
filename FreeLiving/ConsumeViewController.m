//
//  ConsumeViewController.m
//  FreeLiving
//
//  Created by 洋景-Yue on 15/6/3.
//  Copyright (c) 2015年 岳宗申. All rights reserved.
//

#import "ConsumeViewController.h"
#import "DBManager.h"
#import "ConsumeModel.h"
#import "InputTextView.h"
#import "KxMenu.h"

@interface ConsumeViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchResultsUpdating,UIActionSheetDelegate>

@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UITableView *tableView;

@property (strong,nonatomic) NSMutableArray  *dataList;
@property (strong,nonatomic) NSMutableArray  *searchList;

@property (nonatomic, strong) InputTextView *inputView;

@property (nonatomic, assign) NSInteger consumeTyple;
@end

@implementation ConsumeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消费记录";
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addConsumeModel:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    if ([DBManager createConsume_Table]) {
        self.dataList = [DBManager getAllConsumeModel];
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
- (void)addInputTextView
{
    [self.view addSubview:self.inputView];
    [self.inputView createInputView];
}
- (void)addConsumeModel:(UIBarButtonItem *)sender
{
    NSArray *menuItems =
    @[
      [KxMenuItem menuItem:@"收入"
                     image:nil
                    target:self
                    action:@selector(consumeStyleValue1)],
      
      [KxMenuItem menuItem:@"支出"
                     image:nil
                    target:self
                    action:@selector(consumeStyleValue2)],
      ];
    [KxMenu showMenuInView:self.view
                  fromRect:CGRectMake(CGRectGetWidth(self.view.frame)-75, 26, 70, 40)
                 menuItems:menuItems];
}
- (void)consumeStyleValue1
{
    self.consumeTyple = 1;
    [self addInputTextView];
}
- (void)consumeStyleValue2
{
   self.consumeTyple = 2;
    [self addInputTextView];
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
    static NSString *cellId = @"myConsumeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellId];
        cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    ConsumeModel *aModel = nil;
    if (self.searchController.active) {
        aModel = self.searchList[indexPath.row];
    }
    else{
        aModel = self.dataList[indexPath.row];
    }
    [cell.textLabel setText:[NSString stringWithFormat:@"%@         %@ 元",aModel.consumeDes,aModel.consumeAmount]];
    [cell.detailTextLabel setText:aModel.consumeTime];

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
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"确定要删除此分类下的所有消费信息么" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil,nil];
        [actionSheet showInView:self.view];
        actionSheet.tag = indexPath.row;
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
#pragma mark -UITableViewDelegate-

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (self.searchController.active) {
//        self.searchController.active = NO;
//    }
//    ConsumeModel *aModel = nil;
//    if (self.searchController.active) {
//        aModel = self.searchList[indexPath.row];
//    }
//    else{
//        aModel = self.dataList[indexPath.row];
//    }
////    AccountDetailViewController *detailVC = [[AccountDetailViewController alloc] init];
////    detailVC.detailModel = aModel;
////    [self.navigationController pushViewController:detailVC animated:YES];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark -UIActionSheetDelegate-
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self setEditing:NO];
    if (buttonIndex == 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:actionSheet.tag inSection:0];
        ConsumeModel *aModel = self.dataList[indexPath.row];
        if ([DBManager deleteConsumeModel:aModel.consumeTime]) {
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
    
    NSPredicate *preicate = [NSPredicate predicateWithFormat:@"consumeDes CONTAINS[c] %@", searchString];
    
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
        _searchController.searchBar.placeholder = @"输入消费关键字";
        self.tableView.tableHeaderView = _searchController.searchBar;
    }
    return _searchController;
}
- (InputTextView *)inputView
{
    if (_inputView == nil) {
        _inputView = [[InputTextView alloc] initWithFrame:self.view.frame inputStyle:self.consumeTyple];
        _inputView.backgroundColor = [UIColor colorWithRed:0x20/255.0 green:0x1d/255.0 blue:0x1e/255.0 alpha:0.4];
        _inputView.removeInputViewAcion = ^(void)
        {
            _inputView = nil;
        };
        __weak ConsumeViewController *weakSelf = self;
        _inputView.addAccountModelAction = ^(ConsumeModel * aModel)
        {
            [weakSelf.dataList insertObject:aModel atIndex:0];
            [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
            [DBManager saveConsumeModel:aModel];
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
