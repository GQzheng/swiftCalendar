//
//  ZGSectionScalendarViewController.swift
//  swiftCalendar
//
//  Created by jing99 on 2019/1/16.
//  Copyright © 2019 jing99. All rights reserved.
//

import UIKit
enum ZGSenctionScalendarType{ //日历显示的类型 可选过去/可选将来
    case ZGSenctionScalendarPastType
    case ZGSenctionScalendarMidType
    case ZGSenctionScalendarFutureType
}
enum ZGSenctionSelectType{ //日历选择的类型 可选一天日期/可选一个日期区间
    case ZGSenctionSelectTypeOneDate
    case ZGSenctionSelectTypeAreaDate
}
protocol ScalendarProtocol:NSObjectProtocol {
    func callBack(beginTime:Int,endTime:Int?)
    func onleSelectOneDateCallBack(selectTime:Int?)
}

extension ScalendarProtocol{
    func callBack(beginTime:Int,endTime:Int?) {}
    func onleSelectOneDateCallBack(selectTime:Int?) {}
}
public let defaultTextColor =  UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)//默认字体颜色
public let selectDateBackGroundColor =  UIColor(red: 0.84, green: 0, blue: 0.14, alpha: 1)//选中日期背景色
public let failureDateTextColor =  UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)//过期日期字体颜色

class ZGSectionScalendarViewController: UIViewController {
    let cellHeaderViewHight = 50
    var startDate : Int? = 0
    var endDate   : Int? = 0
    var limitMonth: NSInteger?
    
    var type : ZGSenctionScalendarType!
    var selectType : ZGSenctionSelectType!
    var afterTodayCanTouch : Bool = true
    var BeforeTodayCanTouch: Bool = false
    var showChineseHoliday :Bool = true
    var ShowChineseCalendar:Bool = true
    var ShowHolidayColor   :Bool = true
    var showAlertView      :Bool = true
    
    var dataArray=[Any]()
    var collectionView : UICollectionView!
    var dataCell:ZGSScalendarViewCell!
    let weekArray = ["日","一","二","三","四","五","六"]
    
    weak var endDelegate:ScalendarProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDataSource()
        creatUi()
        
    }
    func addWeakView() {
        let weekView = UIView.init(frame: CGRect.init(x: 0, y: STATUS_NAV_BAR_Y, width: UIScreen.main.bounds.size.height, height: 40))
        weekView.backgroundColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1)
        self.view.addSubview(weekView)
        let weekWidth = UIScreen.main.bounds.size.width / 7
        for i in 0 ..< 7 {
            let weekLabel = UILabel.init(frame: CGRect.init(x: Int(Float(i)*Float(weekWidth)) , y: 0, width: Int(weekWidth), height: 40))
            weekLabel.backgroundColor = UIColor.clear
            weekLabel.text = weekArray[i]
            weekLabel.font = UIFont.systemFont(ofSize: 15)
            weekLabel.textAlignment = .center
            weekLabel.textColor = defaultTextColor
            weekView.addSubview(weekLabel)
        }
        
    }
    func initDataSource() {
        DispatchQueue.global().async {
            let manager = ZGSScalendarManager.init(showChineseHoliday: self.showChineseHoliday, showChineseCalendar: self.ShowChineseCalendar, startDate: self.startDate!)
            let tempDataArray = manager.getCalendarDataSoruce(limitMonth: self.limitMonth!, type: self.type!)
            
            DispatchQueue.main.async {
                self.dataArray += tempDataArray
                self.showCollectionViewWithStartIndexPath(startIndexPath: manager.startIndexpath ?? NSIndexPath.init(row: 0, section: 0))
            }
        }
        
    }
    
    func showCollectionViewWithStartIndexPath(startIndexPath:NSIndexPath) {

        collectionView.reloadData()
        if startIndexPath.row != 99{
            collectionView.scrollToItem(at: startIndexPath as IndexPath, at: .top, animated: false)
            collectionView.contentOffset = CGPoint.init(x: 0, y: collectionView.contentOffset.y - 50)
        }else{
            if type == ZGSenctionScalendarType.ZGSenctionScalendarPastType {
                if dataArray.count > 0 {
                    collectionView.scrollToItem(at: IndexPath.init(row: 0, section: dataArray.count - 1), at: .top, animated: false)
                }
            }else if type == ZGSenctionScalendarType.ZGSenctionScalendarMidType{
                if dataArray.count > 0 {
                    collectionView.scrollToItem(at: IndexPath.init(row: 0, section: (dataArray.count - 1)/2), at: .top, animated: false)
                    collectionView.contentOffset = CGPoint.init(x: 0, y: collectionView.contentOffset.y - 50)
                }
            }
            
        }
    }
    
    func creatUi()  {
        addWeakView()
        
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.itemSize=CGSize.init(width: 55, height: 60)
        flowLayout.headerReferenceSize=CGSize.init(width: UIScreen.main.bounds.size.width, height: CGFloat(cellHeaderViewHight))
        flowLayout.sectionInset=UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        flowLayout.minimumLineSpacing=0
        flowLayout.minimumInteritemSpacing=0

        collectionView=UICollectionView.init(frame: CGRect.init(x: 0, y: STATUS_NAV_BAR_Y + 40, width: 55*7, height: UIScreen.main.bounds.size.height-STATUS_NAV_BAR_Y-40), collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor=UIColor.white
        collectionView.register(ZGSScalendarViewCell.self, forCellWithReuseIdentifier: "ZGSScalendarViewCell")
        collectionView.register(ZGScalendarReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ZGScalendarReusableView")
        self.view.addSubview(self.collectionView!)
//
        
    }

}
extension ZGSectionScalendarViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let headerItem = dataArray[section] as! ZGSectionCalendarHeaderModel
        return headerItem.calendarItemArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        dataCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZGSScalendarViewCell", for: indexPath) as? ZGSScalendarViewCell
        let headerItem = dataArray[indexPath.section] as! ZGSectionCalendarHeaderModel
        let calendarItem = headerItem.calendarItemArray[indexPath.row] as! ZGSectionCalendarModel
        dataCell.dataLabel.text = ""
        dataCell.dataLabel.textColor = defaultTextColor
        dataCell.subLabel.text = ""
        dataCell.subLabel.textColor = defaultTextColor
        dataCell.backgroundColor = UIColor.white
        dataCell.isSelected = false
        dataCell.isUserInteractionEnabled = false
        dataCell.lineView.isHidden = true
        if calendarItem.day! > 0 {
            dataCell.lineView.isHidden = false
            dataCell.dataLabel.text = (calendarItem.day! as NSNumber).stringValue
            dataCell.isUserInteractionEnabled = true
        }
        if ShowChineseCalendar == true {
                dataCell.subLabel.text = calendarItem.chineseCalendar
        }else{
                dataCell.subLabel.text = ""
        }
        if calendarItem.holiday != "" && calendarItem.holiday?.isEmpty != true && calendarItem.holiday != nil{
            dataCell.subLabel.text = calendarItem.holiday
            if ShowHolidayColor {
                dataCell.subLabel.textColor = selectDateBackGroundColor
            }
        }
        
        if self.selectType == ZGSenctionSelectType.ZGSenctionSelectTypeOneDate{
            if calendarItem.dateInterval == startDate{//开始日期
                dataCell.isSelected = true
                dataCell.dataLabel.textColor = UIColor.white
                dataCell.subLabel.textColor = UIColor.white
                dataCell.backgroundColor = selectDateBackGroundColor
            }
        }else{
            if calendarItem.dateInterval == startDate{//开始日期
                dataCell.isSelected = true
                dataCell.dataLabel.textColor = UIColor.white
                dataCell.subLabel.textColor = UIColor.white
                dataCell.backgroundColor = selectDateBackGroundColor
            }else if calendarItem.dateInterval == endDate {//结束日期
                dataCell.isSelected = true
                dataCell.dataLabel.textColor = UIColor.white
                dataCell.subLabel.textColor = UIColor.white
                dataCell.backgroundColor = selectDateBackGroundColor
            }else if calendarItem.dateInterval! > startDate! && calendarItem.dateInterval!  < endDate! {//中间日期
                dataCell.isSelected = true
                dataCell.dataLabel.textColor = defaultTextColor
                dataCell.subLabel.textColor = defaultTextColor
                dataCell.backgroundColor = UIColor(red: 0.84, green: 0, blue: 0.14, alpha: 0.1)
            }else{
                
            }
        }
        if afterTodayCanTouch == false {
            if calendarItem.type == ZGSectionScalendType.ZGSNextType {
                dataCell.dataLabel.textColor = failureDateTextColor
                dataCell.subLabel.textColor = failureDateTextColor
                dataCell.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
                dataCell.isUserInteractionEnabled = false
            }
        }
        if BeforeTodayCanTouch == false {
            if calendarItem.type == ZGSectionScalendType.ZGSLastType {
                dataCell.dataLabel.textColor = failureDateTextColor
                dataCell.subLabel.textColor = failureDateTextColor
                dataCell.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
                dataCell.isUserInteractionEnabled = false
            }
        }
        
//
        return dataCell!
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ZGScalendarReusableView", for: indexPath) as! ZGScalendarReusableView
            let headerItem = dataArray[indexPath.section] as! ZGSectionCalendarHeaderModel
            headerView.headerLabel.text = headerItem.headerText
            return headerView
        }
        return UICollectionReusableView.init(frame: CGRect.zero)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        let headerItem = dataArray[indexPath.section] as! ZGSectionCalendarHeaderModel
        let calendarItem = headerItem.calendarItemArray[indexPath.row] as! ZGSectionCalendarModel
        
        if self.selectType == ZGSenctionSelectType.ZGSenctionSelectTypeOneDate {
                startDate = calendarItem.dateInterval
                if endDelegate != nil {
                    endDelegate?.onleSelectOneDateCallBack(selectTime: startDate)
                }
                 self.navigationController?.dismiss(animated: true, completion: nil)
            return
        }
        
        if startDate == 0{
            startDate = calendarItem.dateInterval
        }else if startDate! > 0 && endDate! < 0 {
            startDate = calendarItem.dateInterval
            endDate = 0
        }else if startDate! > 0 && endDate! > 0 {
            startDate = calendarItem.dateInterval
            endDate = 0
        }else{
            if startDate! < calendarItem.dateInterval! {
                endDate = calendarItem.dateInterval
                if endDelegate != nil {
                    endDelegate?.callBack(beginTime: startDate!, endTime: endDate!)
                }
                self.navigationController?.dismiss(animated: true, completion: nil)
            }else{
                startDate = calendarItem.dateInterval
            }
            
        }
        collectionView.reloadData()
    }
    
}
