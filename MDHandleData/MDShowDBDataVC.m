//
//  MDShowDBDataVC.m
//  MDHandleData
//
//  Created by 没懂 on 17/3/30.
//  Copyright © 2017年 com.infomacro. All rights reserved.
//

#import "MDShowDBDataVC.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MDModel.h"
#import "MDHead.h"
@interface MDShowDBDataVC ()
@property (nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation MDShowDBDataVC

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight = 100;
    // 从数据库查数据：缺点是没有做数据的分页。后期更新。
    NSArray *array1 = [MDModel queryDbToObjectArray];
    [self.dataArray addObjectsFromArray:array1];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"MDShowDBDataVCID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.textLabel.text = ((MDModel*)self.dataArray[indexPath.row]).name;
        cell.detailTextLabel.text = ((MDModel*)self.dataArray[indexPath.row]).inde;
        cell.imageView.image = [UIImage imageWithData:((MDModel*)self.dataArray[indexPath.row]).image];
    }
    return cell;
}

@end
