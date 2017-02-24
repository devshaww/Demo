//
//  CollectionSpecialViewCell.swift
//  DouYuLive
//
//  Created by Shaw on 2017/2/5.
//  Copyright © 2017年 Shaw. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionSpecialCell: CollectionBaseCell {

    override var anchor: AnchorModel? {
        didSet {
            super.anchor = anchor
            locationBtn.setTitle(anchor?.anchor_city, for: .normal)
        }
    }
    
    @IBOutlet weak var locationBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
