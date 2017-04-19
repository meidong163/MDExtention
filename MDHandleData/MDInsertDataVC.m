//
//  MDInsertDataVC.m
//  MDHandleData
//
//  Created by 没懂 on 17/3/30.
//  Copyright © 2017年 com.infomacro. All rights reserved.
//

#import "MDInsertDataVC.h"
#import "Model.h"
#import "NSObject+Property.h"
#import "DbHelper.h"
#import "SDWebImageManager.h"
#import "MDHead.h"
#import "MDModel.h"
@interface MDInsertDataVC()
@property (nonatomic, strong)NSMutableArray *dataArray;
@end

@implementation MDInsertDataVC

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return  _dataArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initButton:@"插入数据" sel:@selector(insertData:) frame:CGRectMake(10,100,100,40)];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)insertData:(id)vender
{
    NSArray *arr = @[
                     @{
                         @"imageUrl":@"http://imgcdn.zhibo8.cc/2017/03/28/c3f488ffdc7cf9ee55f76715b5310501.jpg",
                         @"name":@"美女",
                         @"inde":@"1"
                         },
                     @{
                         @"imageUrl":@"http://imgcdn.zhibo8.cc/2017/03/28/5621bd492d1fb676a10e262bcf49b1c5.jpg",
                         @"name":@"伊巴卡",
                         @"inde":@"2"
                         },
                     @{
                         @"imageUrl":@"http://imgcdn.zhibo8.cc/2017/03/27/dbe852b33eb7c9c848645d20743fdff5.png",
                         @"name":@"哈哈",
                         @"inde":@"3"
                         }
                     ];
    // 使用方法，目标业务层不关心写sql语句的问题。需要做的就是把数据扔到数据库中。
    SDWebImageDownloader *downloader = [[SDWebImageDownloader alloc]init];
    for (NSDictionary *dict in arr) {
        MDModel *model = [MDModel objectWithKeyValues:dict];
        //  图片down下来,
        [downloader downloadImageWithURL:[NSURL URLWithString:model.imageUrl] options:SDWebImageDownloaderContinueInBackground progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            if (data) {
                model.image = data;
                model.price = @"免费的";
                // model 扔进数据库中。
                [model modelEnterDatabase];

            }
        }];
    }
}

- (void)initButton:(NSString *)buttontitle sel:(SEL)action frame:(CGRect)frame
{
    UIButton *btn = [[UIButton alloc]initWithFrame:frame];
    btn.autoresizingMask = UIViewContentModeBottom |UIViewContentModeBottomLeft | UIViewContentModeBottomRight;
    btn.backgroundColor = [UIColor grayColor];
    [btn setTitle:buttontitle forState:UIControlStateNormal];
    [btn addTarget:self action:action forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
}
@end
