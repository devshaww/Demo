//
//  CollectionNormalCell.swift
//  DouYuLive
//
//  Created by Shaw on 2017/2/5.
//  Copyright © 2017年 Shaw. All rights reserved.
//

import UIKit

class CollectionNormalCell: CollectionBaseCell {
    
    override var anchor: AnchorModel? {
        didSet {
            super.anchor = anchor
            roomNameLabel.text = anchor?.room_name
        }
    }

    @IBOutlet weak var roomNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
