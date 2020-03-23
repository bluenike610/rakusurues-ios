//
//  TodoItemTableViewCell.swift
//  CountMemoForEsApp
//
//  Created by ADV on 2020/03/23.
//  Copyright © 2020 Yoko Ishikawa. All rights reserved.
//

import UIKit

@objc protocol TodoItemTableViewCellDelegate {
    func checkBtnClicked(ind: Int)
}

class TodoItemTableViewCell: UITableViewCell {

    @IBOutlet weak var markView: UIView!
    
    @IBOutlet weak var timeLb: UILabel!
    
    @IBOutlet weak var monthLb: ScaledLabel!
    @IBOutlet weak var titleLb: ScaledLabel!
    
    @IBOutlet weak var dateLb: ScaledLabel!
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var checkImg: UIImageView!
    internal weak var delegate : TodoItemTableViewCellDelegate? = nil;

    var currentIndex: Int?
    var selectedFlag: Bool?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.mainView.layer.cornerRadius = 10
        self.markView.layer.cornerRadius = 20
        self.markView.layer.borderColor = UIColor.gray.cgColor
        self.markView.layer.borderWidth = 1
        self.markView.layer.masksToBounds = false
        self.markView.layer.shadowRadius = 2
        self.markView.layer.shadowOpacity = 1
        self.markView.layer.shadowColor = UIColor.gray.cgColor
        self.markView.layer.shadowOffset = CGSize(width: 0 , height:2)

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    internal func initData(todoData: Todo, ind: Int) {
        self.currentIndex = ind
        titleLb.text = todoData.name
        
        mainView.backgroundColor = UIColor(hexString: todoData.bgColor!)
        if todoData.completedFlag {
            checkImg.image = UIImage(named: "check")
        }else {
            checkImg.image = UIImage(named: "uncheck")
        }
        selectedFlag = todoData.completedFlag

        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        formatter.dateFormat = "yyyy年MM月dd日HH時"
        self.dateLb.text = formatter.string(from: todoData.createdAt!)

        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "M月"
        monthLb.text = formatter.string(from:todoData.alertTime!)
        formatter.dateFormat = "d"
        timeLb.text = formatter.string(from: todoData.alertTime!)

        let timeInterval = todoData.alertTime?.timeIntervalSince(Date())
        if timeInterval != nil {
            if timeInterval! <= 0 {
                markView.backgroundColor = .lightGray
                selectedFlag = true
            }
        }
    }

    @IBAction func checkBtnClicked(_ sender: Any) {
        if !selectedFlag! {
            delegate?.checkBtnClicked(ind: currentIndex!)
        }
    }
    
    
    
    
}
