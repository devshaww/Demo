//
//  CollectionBaseCell.swift
//  DouYuLive
//
//  Created by Shaw on 2017/2/10.
//  Copyright © 2017年 Shaw. All rights reserved.
//

import UIKit

class CollectionBaseCell: UICollectionViewCell {
    
    @IBOutlet weak var onlineBtn: UIButton!
    
    @IBOutlet weak var photoView: UIImageView!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    
    var anchor: AnchorModel? {
        didSet {
            guard let anchor = anchor else { return }
            nicknameLabel.text = anchor.nickname
            // 此处用locationBtn.titleLabel.text = ... 不行 可能是因为Btn中有图片的原因
            
            var onlineString = ""
            if anchor.online >= 10000 {
                onlineString = "\(anchor.online / 10000)" + "万"
            } else {
                onlineString = "\(anchor.online)"
            }
            onlineBtn.setTitle(onlineString, for: .normal)
            
            guard let imgURL = URL(string: anchor.vertical_src) else { return }
            photoView.kf.setImage(with: imgURL, placeholder: UIImage(named: "Img_default"))
        }
    }
    
}
