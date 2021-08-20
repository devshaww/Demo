//
//  RecommendCycle.swift
//  DouYuLive
//
//  Created by Shaw on 2017/2/10.
//  Copyright © 2017年 Shaw. All rights reserved.
//

import UIKit

private let CycleViewCellID = "CycleViewCell"

class RecommendCycleView: UIView {

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var timer: Timer?
    
    var models: [CycleModel]? {
        didSet {
            collectionView.reloadData()
            pageControl.numberOfPages = models?.count ?? 0
            
            // 默认滚到某个index较大的位置 便于向前滑
            let indexPath = IndexPath(item: (models?.count ?? 0) * 10, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .left, animated: false)
            
            removeTimer()
            addTimer()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        autoresizingMask = UIView.AutoresizingMask(rawValue: 0)
        
        let nib = UINib(nibName: "CollectionCycleCell", bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: CycleViewCellID)
    }
    
    override func layoutSubviews() {
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = collectionView.bounds.size  // 拿到的是在xib里的尺寸 而不是适配屏幕后的尺寸 所以需要在layoutSubviews里调用
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        print("layout.itemSize: \(layout.itemSize)")
        print("Window: \(UIApplication.shared.windows.filter {$0.isKeyWindow}.first?.frame.size ?? CGSize(width: 0, height: 0))")
    }
    
    class func cycleView() -> RecommendCycleView {
        return Bundle.main.loadNibNamed("RecommendCycleView", owner: nil, options: nil)?.first as! RecommendCycleView
    }

}

extension RecommendCycleView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 此处cycleModel为nil
        return (models?.count ?? 0) * 100
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CycleViewCellID, for: indexPath) as! CollectionCycleCell

        cell.model = models![indexPath.item % (models?.count)!]
        
        return cell
    }
}

extension RecommendCycleView: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x + scrollView.bounds.width / 2
        pageControl.currentPage = Int(offsetX / scrollView.bounds.width) % (models?.count ?? 1)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        removeTimer()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        addTimer()
    }
}


extension RecommendCycleView {
    fileprivate func addTimer() {
        timer = Timer(timeInterval: 3, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    fileprivate func removeTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func updateTimer() {
        let offsetX = collectionView.contentOffset.x
        let targetOffsetX = offsetX + collectionView.bounds.width
        
        collectionView.setContentOffset(CGPoint(x: targetOffsetX, y: 0), animated: true)
    }
}


