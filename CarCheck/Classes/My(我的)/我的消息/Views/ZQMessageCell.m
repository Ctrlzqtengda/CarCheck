//
//  ZQMessageCell.m
//  CarCheck
//
//  Created by 岳宗申 on 2017/11/9.
//  Copyright © 2017年 zhangqiang. All rights reserved.
//

#import "ZQMessageCell.h"

@interface ZQMessageCell ()

@property (strong,nonatomic) UIImageView *logoIV;

@property (strong,nonatomic) UILabel *titleLb;

@property (strong,nonatomic) UILabel *detailLb;

@property (strong,nonatomic) UILabel *timeLb;

@end

@implementation ZQMessageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

-(void)initView{
    _logoIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 16, 50, 50)];
//    _logoIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 16, 0, 0)];
    [self addSubview:_logoIV];
    
    _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(_logoIV)+14, 22, 110, 15)];
    [self addSubview:_titleLb];
    _titleLb.textAlignment = NSTextAlignmentLeft;
    _titleLb.textColor = __DTextColor;
    _titleLb.font = MFont(15);
    
//    _timeLb = [[UILabel  alloc]initWithFrame:CGRectMake(CGRectXW(_titleLb), 22, __kWidth-CGRectXW(_titleLb)-10, 15)];
//    [self addSubview:_timeLb];
//    _timeLb.textAlignment = NSTextAlignmentRight;
//    _timeLb.textColor = LH_RGBCOLOR(170, 170, 170);
//    _timeLb.font = MFont(12);
    
    _detailLb = [[UILabel alloc]initWithFrame:CGRectMake(CGRectXW(_logoIV)+14, CGRectYH(_titleLb)+7, __kWidth-90, 42)];
    [self addSubview:_detailLb];
    _detailLb.numberOfLines = 0;
    _detailLb.textColor = LH_RGBCOLOR(153, 153, 153);
    _detailLb.font = MFont(13);
}

- (void)setModel:(ZQMessageModel *)model {
    _model = model;
    _titleLb.text = _model.title;
    _logoIV.image = MImage(@"appIcon");
    _detailLb.text = _model.t_contentered;
//    if (_model.time) {
//        _timeLb.text = _model.time;
//    }
//    else
//    {
//        _timeLb.text = @"2017-11-01";
//    }
    //    NSDate *dateNow = [NSDate dateWithTimeIntervalSinceNow:0];
    //    NSString *timeSp = [NSString stringWithFormat:@"%ld",(long)[dateNow timeIntervalSince1970]];
    //    NSInteger sendTime = [timeSp integerValue]- [model.time integerValue];
    //    if (sendTime/60<1) {
    //        _timeLb.text = @"刚刚";
    //    }else if (sendTime/3600<1){
    //        _timeLb.text = [NSString stringWithFormat:@"%ld分钟前",sendTime/60];
    //    }else if (sendTime/216000<1){
    //        _timeLb.text = [NSString stringWithFormat:@"%ld小时前",sendTime/3600];
    //    }else{
    //        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //        [dateFormatter setDateFormat:@"MM-dd"];
    //        NSDate *pass = [NSDate dateWithTimeIntervalSince1970:[model.time integerValue]];
    //        NSString*day = [NSString stringWithFormat:@"%@",[dateFormatter stringFromDate:pass]];
    //        _timeLb.text = day;
    //    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
