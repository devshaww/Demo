//
//  HomeViewController.swift
//  DouYuLive
//
//  Created by Shaw on 2017/2/3.
//  Copyright © 2017年 Shaw. All rights reserved.
//

import UIKit

private let kTitleViewH: CGFloat = 40

class HomeViewController: UIViewController {
    
    fileprivate lazy var titleView: PageTitleView = { [weak self] in
        let titles = ["推荐", "游戏", "娱乐", "趣玩"]
        let frame = CGRect(x: 0, y: kTopPadding, width: kScreenW, height: kTitleViewH)
        let titleView = PageTitleView(frame: frame, titles: titles)
        
        titleView.delegate = self
        
        return titleView
    }()
    
    fileprivate lazy var contentView: PageContentView = { [weak self] in
        var childVCs = [UIViewController]()
        
        childVCs.append(RecommendViewController())
        
        for _ in 0..<3 {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor(r: CGFloat(arc4random_uniform(255)), g: CGFloat(arc4random_uniform(255)), b: CGFloat(arc4random_uniform(255)))
            childVCs.append(vc)
        }
        
        let contentView = PageContentView(frame: CGRect(x: 0, y: kTopPadding + kTitleViewH, width: kScreenW, height: kScreenH - kTopPadding - kTitleViewH - kTabBarH), childVCs: childVCs, parentVC: self)
        
        contentView.delegate = self
        
        return contentView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

}


extension HomeViewController {
    fileprivate func setupUI() {
        setupNavBar()
        automaticallyAdjustsScrollViewInsets = false
        // 否则titleView显示不出来 因为titleView里有个scrollView 会被自动添加64的边距 
        view.addSubview(titleView)
        view.addSubview(contentView)
    }
    
    fileprivate func setupNavBar() {
        let btn = UIButton()
        btn.setImage(UIImage(named: "logo"), for: .normal)
        btn.sizeToFit()
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: btn)
        
        let size = CGSize(width: 40, height: 40)
        let historyItem = UIBarButtonItem(imageName: "image_my_history", hImageName: "Image_my_history_click", size: size)
        let searchItem = UIBarButtonItem(imageName: "btn_search", hImageName: "btn_search_clicked", size: size)
        let qrcodeItem = UIBarButtonItem(imageName: "Image_scan", hImageName: "Image_scan_click", size: size)
        navigationItem.rightBarButtonItems = [searchItem, qrcodeItem, historyItem]
    }
}

extension HomeViewController: PageTitleViewDelegate {
    func pageTitleView(_ titleView: PageTitleView, selectedIndex: Int) {
        contentView.setCurrentContentOffset(selectedIndex)
    }
}

extension HomeViewController: PageContentViewDelegate {
    func pageContentView(_ pageContentView: PageContentView, source: Int, target: Int, progress: CGFloat) {
        titleView.setScrollLineAndTitle(progress, source: source, target: target)
    }
}








