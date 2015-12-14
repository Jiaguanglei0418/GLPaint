//
//  ViewController.m
//  GLPaint
//
//  Created by jiaguanglei on 15/12/14.
//  Copyright © 2015年 roseonly. All rights reserved.
//

#import "ViewController.h"
#import "ColorPicker.h"
#import "PaintView.h"
#import "Masonry.h"

@interface ViewController ()<ColorPickerDelegate>
{
    ColorPicker *_piker;
    PaintView *_paintView;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    // 1. 创建colorPiker
    [self setupColorPiker];
    
    // 2. 创建画板
    [self setupPaintView];
    
    // 3. 撤销
    [self setupNavigationItem];
}

- (void)setupNavigationItem
{
//    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(undoMethod)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRedo target:self action:@selector(redoMethod)];
    
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [titleBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    titleBtn.frame = CGRectMake(0, 0, 60, 44);
    [titleBtn setTitle:@"保存到相册" forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(saveImage) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = titleBtn;
}

#pragma mark - 保存图片到相册
// 监听点击
- (void)saveImage
{
    // 获取照片
    UIImage *paintImage = [_paintView paintImage];
    LogRed(@"%@", paintImage);
    
    UIImageWriteToSavedPhotosAlbum(paintImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"";
    if (!error) {
        message = @"成功保存到相册";
    }else
    {
        message = [error description];
    }
    LogRed(@"message is %@",message);
}


#pragma mark - 监听undo
- (void)undoMethod
{
    [_paintView undo];
}

- (void)redoMethod
{
    [_paintView redo];
}


#pragma mark - 创建colorPiker
- (void)setupColorPiker
{
    _piker = [ColorPicker colorPickerWithFrame:CGRectMake(0, 64, PP_SCREEN_WIDTH, 130)];
    _piker.delegate = self;
    [self.view addSubview:_piker];
    
}


#pragma mark - 创建PaintView
- (void)setupPaintView
{
    _paintView = [PaintView paintView];
    _paintView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:.95];

    // 设置线宽
    _paintView.lineWidth = 8.0f;
    [self.view addSubview:_paintView];
    
    // 约束
    [_paintView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(CGRectGetMaxY(_piker.frame) , 5, 0, 5));
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - ColorPickerDelegate
- (void)aColorPickerDidSelected:(UIColor *)color
{
    [_paintView setPaintColor:color];
    
}


@end
