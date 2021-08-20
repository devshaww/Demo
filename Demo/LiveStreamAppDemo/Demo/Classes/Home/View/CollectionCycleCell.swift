//
//  CollectionCycleCell.swift
//  DouYuLive
//
//  Created by Shaw on 2017/2/11.
//  Copyright © 2017年 Shaw. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionCycleCell: UICollectionViewCell {

    @IBOutlet weak var photoView: UIImageView!
    
    var model: CycleModel? {
        didSet {
            guard let model = model else { return }
            
            let url = URL(string: model.pic_url)
//            photoView.layer.borderColor = UIColor.red.cgColor
//            photoView.layer.borderWidth = 1.0
            photoView.kf.setImage(with: url)
        }
    }
    

}
