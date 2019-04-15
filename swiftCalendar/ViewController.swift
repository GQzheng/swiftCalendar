//
//  ViewController.swift
//  swiftCalendar
//
//  Created by jing99 on 2019/1/16.
//  Copyright © 2019 jing99. All rights reserved.
//

import UIKit

//设备物理尺寸
let ScreenHeight = UIScreen.main.bounds.size.height
let ScreenWidth = UIScreen.main.bounds.size.width

let ScreenProportion = ScreenWidth / 375

let IS_IPHONE_X: Bool = ScreenHeight == 812 || ScreenHeight == 896 ?true:false

let STATUS_NAV_BAR_Y:CGFloat = IS_IPHONE_X == true ? 88.0 : 64.0

class ViewController: UIViewController {

    var startDate:Int? = 0
    var endDate:Int? = 0
    
    var startLabel:UILabel!
    var endLabel:UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor=UIColor.white
        
        creatUI()
        
    }
    func creatUI() {
        
        
        let btn = UIButton.init(frame: CGRect.init(x: 55, y: 80, width: 110, height: 50))
        btn.setTitle("打开日历", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.backgroundColor=UIColor.green
        btn.addTarget(self, action: #selector(calendarClick), for: .touchUpInside)
        view.addSubview(btn)
        
        startLabel = UILabel.init(frame: CGRect.init(x: 55, y: 180, width: 150, height: 40))
        startLabel.backgroundColor = UIColor.gray
        startLabel.textColor = UIColor.red
        view.addSubview(startLabel)
        
        endLabel = UILabel.init(frame: CGRect.init(x: 55, y: 230, width: 150, height: 40))
        endLabel.backgroundColor = UIColor.gray
        endLabel.textColor = UIColor.red
        view.addSubview(endLabel)
        
    }

    @objc func calendarClick() {
        let zg = ZGSectionScalendarViewController()
        zg.limitMonth = 12 * 15
        zg.type = ZGSenctionScalendarType.ZGSenctionScalendarFutureType
        zg.BeforeTodayCanTouch = false
        zg.afterTodayCanTouch = true
        zg.endDelegate = self
        zg.startDate = startDate
        zg.endDate = endDate
//        zg.selectType = ZGSenctionSelectType.ZGSenctionSelectTypeOneDate
        
        let nav = UINavigationController.init(rootViewController: zg)
        zg.title = "入住离店日期"
        self.present(nav, animated: true, completion: nil)
    }
}

extension ViewController:ScalendarProtocol{
    func callBack(beginTime: Int, endTime: Int?) {
        startDate = beginTime;
        endDate = endTime;
    
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        startLabel.text = dateFormatter.string(from: Date.init(timeIntervalSince1970: TimeInterval(beginTime)))
        endLabel.text = endTime! > 0 ? dateFormatter.string(from: Date.init(timeIntervalSince1970: TimeInterval(endTime!))) : ""
    }
    
    
}
