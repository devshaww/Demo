//
//  RecommendGamaView.swift
//  DouYuLive
//
//  Created by Shaw on 2017/2/12.
//  Copyright © 2017年 Shaw. All rights reserved.
//

import UIKit

private let GameCellID = "GameCell"
private let kEdgeInsetMargin: CGFloat = 15

class RecommendGameView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var groups: [AnchorGroup]? {
        didSet {
//            // 这样写会导致remove数据的是局部变量groups 而不是实例对象groups
//            guard var groups = groups else { return }
            
            groups?.removeFirst()
            
            let moreGroup = AnchorGroup()
            moreGroup.tag_name = "更多"
            groups?.append(moreGroup)
            
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        autoresizingMask = .init(rawValue: 0)
        
        let nib = UINib(nibName: "CollectionGameCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: GameCellID)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: kEdgeInsetMargin, bottom: 0, right: 0)
    }
    
    class func gameView() -> RecommendGameView {
        return Bundle.main.loadNibNamed("RecommendGameView", owner: nil, options: nil)?.first as! RecommendGameView
    }
}


extension RecommendGameView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GameCellID, for: indexPath) as! CollectionGameCell
        
        let group = groups![indexPath.item]
        cell.group = group
        
        return cell
    }
}
