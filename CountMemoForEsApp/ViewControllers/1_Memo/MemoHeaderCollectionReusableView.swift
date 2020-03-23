//
//  MemoHeaderCollectionReusableView.swift
//  CountMemoForEsApp
//
//  Created by ADV on 2020/03/22.
//  Copyright © 2020 Yoko Ishikawa. All rights reserved.
//

import UIKit

class MemoHeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var mainBg: UIView!
    @IBOutlet weak var markBg: UIView!
    @IBOutlet weak var markLb: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        mainBg.layer.cornerRadius = 15
        markBg.layer.cornerRadius = 14
        mainBg.layer.borderColor = UIColor.gray.cgColor
        mainBg.layer.borderWidth = 0.5
    }
    
    internal func initData(markNum: Int, groupTitle: String) {
        markLb.text = String(markNum)
        titleLb.text = groupTitle
        markBg.backgroundColor = Common.getRandomColor(value: markNum-1)
    }
    
}
