//
//  PageContentView.swift
//  DouYuLive
//
//  Created by Shaw on 2017/2/4.
//  Copyright © 2017年 Shaw. All rights reserved.
//

import UIKit

protocol PageContentViewDelegate: AnyObject {
    func pageContentView(_ pageContentView: PageContentView, source: Int, target: Int, progress: CGFloat)
}

private let CollectionCellID = "CollectionCell"

class PageContentView: UIView {
    
    weak var delegate: PageContentViewDelegate?
    fileprivate var childVCs: [UIViewController]
    fileprivate weak var parentVC: UIViewController?
    fileprivate var startOffsetX: CGFloat = 0
    fileprivate var isScrollViewDelegateForbidden = false
    
    fileprivate lazy var collectionView: UICollectionView = { [weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: CollectionCellID)
        
        return collectionView
    }()
    
    init(frame: CGRect, childVCs: [UIViewController], parentVC: UIViewController?) {
        self.childVCs = childVCs
        self.parentVC = parentVC
        
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension PageContentView {
    fileprivate func setupUI() {
        for vc in childVCs {
            parentVC?.addChild(vc)
        }
        collectionView.frame = bounds
        addSubview(collectionView)
    }
}

extension PageContentView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVCs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionCellID, for: indexPath)
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        let vc = childVCs[indexPath.item]
        vc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(vc.view)
        return cell
    }
}

// 暴露给代理
extension PageContentView {
    func setCurrentContentOffset(_ index: Int) {
        isScrollViewDelegateForbidden = true
        let offsetX: CGFloat = CGFloat(index) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y:0), animated: false)
    }
}

extension PageContentView: UICollectionViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isScrollViewDelegateForbidden = false
        startOffsetX = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isScrollViewDelegateForbidden {
            return
        }
        var sourceIndex: Int = 0
        var targetIndex: Int = 0
        var progress: CGFloat = 0
        
        // 判断左滑还是右滑
        let currentOffsetX: CGFloat = scrollView.contentOffset.x
        let scrollViewW: CGFloat = scrollView.bounds.width
        if startOffsetX < currentOffsetX {  // 左滑
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            sourceIndex = Int(currentOffsetX / scrollViewW)
            targetIndex = Int(sourceIndex) + 1
            
            if targetIndex >= childVCs.count {
                targetIndex = childVCs.count - 1
            }
            
            // 滑动距离达到一个scrollViewW时, progress会变成0, 这里进行处理
            if currentOffsetX - startOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
                // 这句容易出错 如果赋值赋反了 由于在左滑时是target大 所以会出现到达极限状态时 source已经变成之前的target(比如测试从0到1，那么此时source从0变成了1), 而target又在此基础上加1, 并且赋给source， 测试时就会出现 想从0滑到1的时候 滑块到了2的地方 就是因为那时的target和source都为2
                // 右滑同理
            }
            
        } else {  // 右滑
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            targetIndex = Int(currentOffsetX / scrollViewW)
            sourceIndex = targetIndex + 1
            
            if sourceIndex >= childVCs.count {
                sourceIndex = childVCs.count - 1
            }
            
            // 滑动距离达到一个scrollViewW时, progress会变成0, 这里进行处理
            if startOffsetX - currentOffsetX == scrollViewW {
                progress = 1
                sourceIndex = targetIndex
            }
        }
        
//        print("source: \(sourceIndex)", "target: \(targetIndex)", "progress: \(progress)")
        
        // 通知代理
        delegate?.pageContentView(self, source: sourceIndex, target: targetIndex, progress: progress)
        
    }
}




