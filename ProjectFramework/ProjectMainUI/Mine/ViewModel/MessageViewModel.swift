//
//  MessageViewModel.swift
//  RepairCar
//
//  Created by 恋康科技 on 2017/9/7.
//  Copyright © 2017年 HCY. All rights reserved.
//

import UIKit

class MessageViewModel: NSObject {
    var ListData = [MessageModel]()
    func GetSystemNotification(UserID:Int ,result:((_ result:Bool? ) -> Void)?) -> Void {
        
        let parameters=["UserID":UserID]
        CommonFunction.Global_Get(entity: MessageModel(), IsListData: true, url: HttpsUrl + "api/System/GetSystemNotification", isHUD: false, isHUDMake: false, parameters: parameters as NSDictionary) { (resultModel) in
            if(resultModel?.Success==true){
                if resultModel?.Content != nil {
                    self.ListData = resultModel?.Content as! [MessageModel]
                }
                result?(true)
            }else{
                result?(false)
            }
        }
    }
}
