//
//  YPayViewController.h
//  shopsN
//
//  Created by imac on 2016/12/23.
//  Copyright © 2016年 联系QQ:1084356436. All rights reserved.
//

#import "BaseViewController.h"

@interface YPayViewController : BaseViewController

/**支付json*/
@property (strong,nonatomic) NSDictionary *payJson;
/**订单id*/
@property (strong,nonatomic) NSString *orderId;
/**金额*/
@property (strong,nonatomic) NSString *payMoney;
/**订单名称*/
@property (strong,nonatomic) NSString *orderName;

//@property (strong,nonatomic) YAddressModel *addressModel;

@end
