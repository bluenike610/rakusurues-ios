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
        markBg.layer.cornerRadius = 15
    }
    
    internal func initData(markNum: String, groupTitle: String) {
        markLb.text = markNum
        titleLb.text = groupTitle
        markBg.backgroundColor = Common.getRandomColor()
        mainBg.backgroundColor = Common.getRandomColor()
    }
    
}
