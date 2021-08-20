//
//  CollectionHeaderView.swift
//  DouYuLive
//
//  Created by Shaw on 2017/2/5.
//  Copyright © 2017年 Shaw. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {

    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var group: AnchorGroup? {
        didSet {
            // 此处用iconImageView = UIImageView(image: UIImage(named: ""))会使图片全部显示为xib上的图片
            iconImageView.image = UIImage(named: group?.icon_name ?? "home_header_normal")
            titleLabel.text = group?.tag_name
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
