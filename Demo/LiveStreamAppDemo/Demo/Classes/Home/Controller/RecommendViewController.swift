//
//  RecommendViewController.swift
//  DouYuLive
//
//  Created by Shaw on 2017/2/5.
//  Copyright © 2017年 Shaw. All rights reserved.
//

import UIKit

private let kItemMargin: CGFloat = 10
private let kItemW: CGFloat = (kScreenW - 3 * kItemMargin) / 2
private let kNormalItemH: CGFloat = kItemW * 3 / 4
private let kSpecialItemH: CGFloat = kItemW * 4 / 3
private let kHeaderViewH: CGFloat = 50

private let kNormalCellID = "NormalCell"
private let kHeaderViewID = "HeaderView"
private let kSpecialCellID = "SpecialCell"

private let kCycleViewH: CGFloat =  kScreenW * 3 / 8
private let kGameViewH: CGFloat = 90

class RecommendViewController: UIViewController {
    
    fileprivate lazy var gameView: RecommendGameView = {
        let gameView = RecommendGameView.gameView()
        gameView.backgroundColor = UIColor.lightGray
        gameView.frame = CGRect(x: 0, y: -kGameViewH, width: kScreenW, height: kGameViewH)
        return gameView
    }()
    
    fileprivate lazy var viewModel: RecommendViewModel = RecommendViewModel()
    fileprivate lazy var collectionView: UICollectionView = { [unowned self] in
        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: kItemW, height: kNormalItemH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = kItemMargin
        layout.headerReferenceSize = CGSize(width: kScreenW, height: kHeaderViewH)
        layout.sectionInset = UIEdgeInsets(top: 0, left: kItemMargin, bottom: 0, right: kItemMargin)
    
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        // determines how it resizes itself when its superview's bounds change

        collectionView.register(UINib(nibName: "CollectionNormalCell", bundle: nil), forCellWithReuseIdentifier: kNormalCellID)

        collectionView.register(UINib(nibName: "CollectionSpecialCell", bundle: nil), forCellWithReuseIdentifier: kSpecialCellID)
        
        collectionView.register(UINib(nibName: "CollectionHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: kHeaderViewID)
        

        collectionView.backgroundColor = UIColor.white
        collectionView.dataSource = self
        collectionView.delegate = self
        
        return collectionView
    }()
    
    fileprivate lazy var cycleView: RecommendCycleView = {
        let cycleView = RecommendCycleView.cycleView()
        cycleView.frame = CGRect(x: 0, y: -(kCycleViewH + kGameViewH), width: kScreenW, height: kCycleViewH)
        print("cycleView: \(cycleView.frame)")
        return cycleView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadData()
    }
    
}

extension RecommendViewController {
    fileprivate func loadData() {
        viewModel.requestData { 
            self.collectionView.reloadData()
            
            // 传递数据给gameview
            self.gameView.groups = self.viewModel.anchorGroups
        }
        
        viewModel.requestCycleData {
            self.cycleView.models = self.viewModel.cycleModels
        }
    }
}

extension RecommendViewController {
    fileprivate func setupUI() {
        collectionView.addSubview(cycleView)
        view.addSubview(collectionView)
        collectionView.contentInset = UIEdgeInsets(top: kCycleViewH + kGameViewH, left: 0, bottom: 0, right: 0)
        // scrollView距scrollView边距的距离
        
        collectionView.addSubview(gameView)
    }
}

extension RecommendViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    // MARK: - Data Source
    // 1
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.viewModel.anchorGroups.count
    }
    
    // 2
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let group = viewModel.anchorGroups[section]
        return group.anchors.count
    }
    // 4
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let group = viewModel.anchorGroups[indexPath.section]
        let anchor = group.anchors[indexPath.item]
        
        var cell: CollectionBaseCell!
        
//        if indexPath.section == 1 {
//            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kSpecialCellID, for: indexPath) as! CollectionSpecialCell
//            cell.anchor = anchor
//        } else {
//            cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath) as! CollectionNormalCell
//            cell.anchor = anchor
//        }
        cell = collectionView.dequeueReusableCell(withReuseIdentifier: kNormalCellID, for: indexPath) as! CollectionNormalCell
        cell.anchor = anchor
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: kHeaderViewID, for: indexPath) as! CollectionHeaderView
        
        headerView.group = viewModel.anchorGroups[indexPath.section]
        
        return headerView
    }
    
    // MARK: - Delegate
    // 3
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
//        if indexPath.section == 1 {
//            return CGSize(width: kItemW, height: kSpecialItemH)
//        }
        
        return CGSize(width: kItemW, height: kNormalItemH)
    }
    
}
