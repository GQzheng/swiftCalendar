//
//  ZGSScalendarViewCell.swift
//  swiftCalendar
//
//  Created by zheng on 2019/2/15.
//  Copyright © 2019 jing99. All rights reserved.
//

import UIKit

class ZGSScalendarViewCell: UICollectionViewCell {
    
    var imageView : UIImageView!
    var dataLabel : UILabel!
    var subLabel : UILabel!
    var lineView : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func createCell(){
        imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        self.contentView.addSubview(imageView)
        
        dataLabel = UILabel.init(frame: CGRect.init(x: 0, y: 10, width: self.frame.size.width, height: self.frame.size.height / 2 - 10))
        dataLabel.textAlignment = .center
        dataLabel.font = UIFont.systemFont(ofSize: 13)
        self.contentView.addSubview(dataLabel)
        
        subLabel = UILabel.init(frame:CGRect.init(x: 0, y: 10, width: self.frame.size.width, height: self.frame.size.height))
        subLabel.textAlignment = .center
        subLabel.font = UIFont.systemFont(ofSize: 10)
        self.contentView.addSubview(subLabel)
        
        lineView = UILabel.init(frame: CGRect.init(x: 0, y: self.frame.size.height - 1, width: self.frame.size.width, height: 1))
        lineView.backgroundColor = UIColor.init(red: 242/255, green: 242/255, blue: 242/255, alpha: 1.0)//UIColor(0xF2F2F2)
        self.contentView.addSubview(lineView)
    }
}
