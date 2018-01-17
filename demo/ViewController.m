//
//  ViewController.m
//  demo
//
//  Created by yangzhaokun on 2018/1/13.
//  Copyright © 2018年 yangzhaokun. All rights reserved.
//

#import "ViewController.h"
#import "YXLiveNativeAnswerView.h"
#define ratio 410/355

@interface ViewController ()
@property (nonatomic, strong) YXLiveNativeAnswerView *answerView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
//    _answerView = [[YXLiveNativeAnswerView alloc]initWithFrame:CGRectMake(10, 20, [UIScreen mainScreen].bounds.size.width - 20, ([UIScreen mainScreen].bounds.size.width -20) *ratio)];
//
//    YXLiveMillionModel *model = [[YXLiveMillionModel alloc]init];
//    model.count = 1;
//    model.totalCount = 12;
//    model.topicString = @"这是题目！！！！！！！3232398989899hgjgjhgjhgj898dsadada3";
//    model.watchMode = YES;
//    model.answersStr = @[@"12222121",@"1231231231",@"231314211"].mutableCopy;
//    model.answersNum = @[@(293723),@(3281731),@(8000)].mutableCopy;
//    model.rightAnswer = 1;
//    model.mineAnswer = 1;
//    model.type = YXLiveMillionModelTypeAnswer;
//    [_answerView setModel:model];
//
//    [_answerView showInView:self.view withAnimation:YES];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)btnAction:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择弹窗"
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];
    //取消:style:UIAlertActionStyleCancel
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [_answerView dismissWithAnimation:YES];
    }];
    
    [alertController addAction:cancelAction];
    //了解更多:style:UIAlertActionStyleDestructive
    UIAlertAction *answer = [UIAlertAction actionWithTitle:@"答题" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        YXLiveMillionModel *model = [[YXLiveMillionModel alloc]init];
        model.count = 1;
        model.totalCount = 12;
        model.topicString = @"这是题目！！！！！！！3232398989899hgjgjhgjhgj898dsadada3";
        model.watchMode = NO;
        model.answersStr = @[@"12222121",@"1231231231",@"231314211"].mutableCopy;
        model.answersNum = @[@(293723),@(3281731),@(8000)].mutableCopy;
        model.rightAnswer = 1;
        model.mineAnswer = 1;
        model.type = YXLiveMillionModelTypeAnswer;
        [self.answerView setModel:model];
        [self.answerView showInView:self.view withAnimation:YES];
    }];
    
    [alertController addAction:answer];
    //原来如此:style:UIAlertActionStyleDefault
    UIAlertAction *result1 = [UIAlertAction actionWithTitle:@"公布答案(对)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        YXLiveMillionModel *model = [[YXLiveMillionModel alloc]init];
        model.count = 1;
        model.totalCount = 12;
        model.topicString = @"这是题目！！！！！！！3232398989899hgjgjhgjhgj898dsadada3";
        model.watchMode = NO;
        model.answersStr = @[@"12222121",@"1231231231",@"231314211",@"232179821"].mutableCopy;
        model.answersNum = @[@(293723),@(3281731),@(8000),@(5676744)].mutableCopy;
        model.rightAnswer = 1;
        model.mineAnswer = 1;
        model.type = YXLiveMillionModelTypeResult;
        [self.answerView setModel:model];
        [self.answerView showInView:self.view withAnimation:YES];
    }];
    [alertController addAction:result1];
    
    UIAlertAction *result2 = [UIAlertAction actionWithTitle:@"公布答案(错)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        YXLiveMillionModel *model = [[YXLiveMillionModel alloc]init];
        model.count = 1;
        model.totalCount = 12;
        model.topicString = @"这是题目！！！！！！！3232398989899hgjgjhgjhgj898dsadada3";
        model.watchMode = NO;
        model.answersStr = @[@"12222121",@"1231231231",@"231314211"].mutableCopy;
        model.answersNum = @[@(293723),@(3281731),@(8000)].mutableCopy;
        model.rightAnswer = 1;
        model.mineAnswer = 0;
        model.type = YXLiveMillionModelTypeResult;
        [self.answerView setModel:model];
        [self.answerView showInView:self.view withAnimation:YES];
    }];
    [alertController addAction:result2];
    
    UIAlertAction *watchAnswer = [UIAlertAction actionWithTitle:@"观战答题" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        YXLiveMillionModel *model = [[YXLiveMillionModel alloc]init];
        model.count = 1;
        model.totalCount = 12;
        model.topicString = @"这是题目！！！！！！！3232398989899hgjgjhgjhgj898dsadada3";
        model.watchMode = YES;
        model.answersStr = @[@"12222121",@"1231231231",@"231314211",@"s9889"].mutableCopy;
        model.type = YXLiveMillionModelTypeAnswer;
        [self.answerView setModel:model];
        [self.answerView showInView:self.view withAnimation:YES];
    }];
    [alertController addAction:watchAnswer];
    
    UIAlertAction *watchResult = [UIAlertAction actionWithTitle:@"观战公布" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        YXLiveMillionModel *model = [[YXLiveMillionModel alloc]init];
        model.count = 1;
        model.totalCount = 12;
        model.topicString = @"这是题目！！！！！！！3232398989899hgjgjhgjhgj898dsadada3";
        model.watchMode = YES;
        model.answersStr = @[@"12222121",@"1231231231",@"231314211"].mutableCopy;
        model.answersNum = @[@(293723),@(3281731),@(8000)].mutableCopy;
        model.type = YXLiveMillionModelTypeResult;
        model.rightAnswer = 1;
        [self.answerView setModel:model];
        [self.answerView showInView:self.view withAnimation:YES];
    }];
    [alertController addAction:watchResult];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (YXLiveNativeAnswerView *)answerView
{
    if (!_answerView) {
        _answerView = [[YXLiveNativeAnswerView alloc]initWithFrame:CGRectMake(10, 20 + 24, [UIScreen mainScreen].bounds.size.width - 20, ([UIScreen mainScreen].bounds.size.width -20) *ratio)];
    }
    return _answerView;
}


@end
