//
//  ZGSectionCalendarModel.swift
//  swiftCalendar
//
//  Created by zheng on 2019/1/16.
//  Copyright © 2019 jing99. All rights reserved.
//

import UIKit

enum ZGSectionScalendType: Int {
    case ZGSTodayType = 1
    case ZGSLastType = 2
    case ZGSNextType = 3
}
class ZGSectionCalendarModel: NSObject {

    var year : NSInteger?
    var month : NSInteger?
    var day : NSInteger?
    
    var dateInterval : NSInteger?
    var week : NSInteger?
    var holiday:String?
    var chineseCalendar : String?
    var type : ZGSectionScalendType?
}

class ZGSectionCalendarHeaderModel: NSObject {
    var headerText:String?
    var calendarItemArray=[Any]()
}
