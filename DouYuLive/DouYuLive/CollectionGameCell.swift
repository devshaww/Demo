//
//  CollectionGameCell.swift
//  DouYuLive
//
//  Created by Shaw on 2017/2/12.
//  Copyright © 2017年 Shaw. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionGameCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    var group: AnchorGroup? {
        didSet {
            guard let group = group else { return }
            titleLabel.text = group.tag_name
            
            let url = URL(string: group.icon_url)
            iconImageView.kf.setImage(with: url, placeholder: UIImage(named: "home_more_btn"))
        }
    }

}
