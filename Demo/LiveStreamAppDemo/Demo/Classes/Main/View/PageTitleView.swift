//
//  PageTitleView.swift
//  DouYuLive
//
//  Created by Shaw on 2017/2/3.
//  Copyright © 2017年 Shaw. All rights reserved.
//

import UIKit

private let kNormalColor: (CGFloat, CGFloat, CGFloat) = (85, 85, 85)
private let kSelectedColor: (CGFloat, CGFloat, CGFloat) = (255, 120, 0)


protocol PageTitleViewDelegate: AnyObject {
    func pageTitleView(_ titleView: PageTitleView, selectedIndex: Int)
}

private let kScrollLineH: CGFloat = 3.5

class PageTitleView: UIView {
    
    weak var delegate: PageTitleViewDelegate?
    
    fileprivate var currentIndex: Int = 0
    fileprivate var titles: [String]
    fileprivate var labels: [UILabel] = [UILabel]()
    
    lazy fileprivate var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    
    lazy fileprivate var scrollLine: UIView = {
        let scrollLine = UIView()
        scrollLine.backgroundColor = UIColor.orange
        return scrollLine
    }()
    
    init(frame: CGRect, titles: [String]) {
        self.titles = titles
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// 初始UI
extension PageTitleView {
    
    fileprivate func setupUI() {
        addSubview(scrollView)
        scrollView.frame = bounds
        
        // 添加title对应的label
        setupTitleLabels()
        
        // 设置滚动条和底线
        setupScrollLineAndBottomLine()
    }
    
    fileprivate func setupTitleLabels() {
        let labelW: CGFloat = frame.width / CGFloat(titles.count)
        let labelH: CGFloat = frame.height - kScrollLineH
        let labelY: CGFloat = 0
        
        for (index, title) in titles.enumerated() {
            let label = UILabel()
            label.tag = index
            label.text = title
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
            
            let labelX: CGFloat = labelW * CGFloat(index)
            let labelFrame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            label.frame = labelFrame
            
            label.isUserInteractionEnabled = true
            label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(labelClicked(_:))))
            labels.append(label)
            scrollView.addSubview(label)
        }
        
        guard let firstLabel = labels.first else { return }
        firstLabel.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)
    }
    
    fileprivate func setupScrollLineAndBottomLine() {
        let labelW: CGFloat = frame.width / CGFloat(titles.count)
        let labelH: CGFloat = frame.height - kScrollLineH
        let scrollLineW: CGFloat = labelW - 2 * kLineOffset
        let bottomLineH: CGFloat = 0.5
        
        let bottomLine = UIView()
        bottomLine.backgroundColor = UIColor.lightGray
        bottomLine.frame = CGRect(x: 0, y: frame.height, width: kScreenW, height: bottomLineH)
        addSubview(bottomLine)
        
        scrollLine.frame = CGRect(x: kLineOffset, y: labelH, width: scrollLineW, height: kScrollLineH)
        scrollView.addSubview(scrollLine)
        
    }
    
}

// MARK: - 监听label事件

// 由于点击事件也会触发scrollViewDidScroll 点击事件的情况下执行scrollViewDidScroll的代码会造成意外情况 其中包括scrollViewWillBeginDragging不会被调用 即startOffset一直为0 比如 从2点击到3 最终返回的source为3 target为3 progress为0 progress为0是因为在点击的情况下contentOffset瞬间被设为目标值 而不是慢慢变化 而且在跳跃点击的情况下 progress设为1的条件也会不满足
// 所以 在返回的source为3 target为3 progress为0的情况下 调用setScrollLineAndTitle 滑块不会有问题 但处理颜色变化 由于progress为0 所以source的颜色依然为selected target颜色依然为normal 首先label点击事件处理一次 这可以保证将之前的label颜色清掉 并将被点击的label设置颜色 但这里还不是最终结果 然后scroll又处理一次 一旦点击了第3个 会出现特殊情况 即source与target都会是3 然后先将3设成selected接着又将3设成normal 所以始终不会有颜色 除非再点击一次 点击后不会调用scroll 只调用label点击事件

// 如果点击的是除3以外的任意 最终结果和预想一样 但是中间的经历和预想是不一样的
// 比如从1到2或2到1 source target progress分别为(2,3,0),(1,1,1) 

// 从2到1会被判断成左滑因为startOffset不会被设置 且progress因为1与0的间距刚好为scrollViewW 所以为1 于是source会被赋给target 所以都变成了1 progress带入 最终颜色变成selected

extension PageTitleView {
    @objc fileprivate func labelClicked(_ recognizer: UITapGestureRecognizer) {
        
        guard let currentLabel = recognizer.view as? UILabel else { return }
        
        // 改变文字颜色
        let lastLabel = labels[currentIndex]
        
        // 如果点击同一个label 直接返回 否则颜色会被设置成normal
        if currentLabel.tag == lastLabel.tag { return }
        
        lastLabel.textColor = UIColor(r: kNormalColor.0, g: kNormalColor.1, b: kNormalColor.2)
        currentLabel.textColor = UIColor(r: kSelectedColor.0, g: kSelectedColor.1, b: kSelectedColor.2)
        
        // 改变滚动条
        let labelW: CGFloat = currentLabel.bounds.width
        let scrollLineX = CGFloat(currentLabel.tag) * labelW + kLineOffset
        UIView.animate(withDuration: 0.2) {
            self.scrollLine.frame.origin.x = scrollLineX
        }
        
        // 设置currentIndex为当前index, 提供给下一次点击事件
        currentIndex = currentLabel.tag
        
        // 通知代理 让PageContentView处理偏移
        delegate?.pageTitleView(self, selectedIndex: currentIndex)
    }
}

// 暴露给代理
extension PageTitleView {
    func setScrollLineAndTitle(_ progress: CGFloat, source: Int, target: Int) {
        let sourceLabel = labels[source]
        let targetLabel = labels[target]
        // 处理滑块
        let moveX: CGFloat = progress * (targetLabel.frame.origin.x - sourceLabel.frame.origin.x)
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + kLineOffset + moveX
        
        // 处理title变化以及颜色渐变
        let colorDelta = (kSelectedColor.0 - kNormalColor.0, kSelectedColor.1 - kNormalColor.1, kSelectedColor.2 - kNormalColor.2)
        
        sourceLabel.textColor = UIColor(r: kSelectedColor.0 - progress * colorDelta.0, g: kSelectedColor.1 - progress * colorDelta.1, b: kSelectedColor.2 - progress * colorDelta.2)
        
        targetLabel.textColor = UIColor(r: kNormalColor.0 + progress * colorDelta.0, g: kNormalColor.1 + progress * colorDelta.1, b: kNormalColor.2 + progress * colorDelta.2)
        
        // 当滚动后 再点击 此时应该实时更新lastIndex 不然第一次点击 lastIndex都是0 
        // 如： 当从2滚到3 此时点击1 那么点击事件会正常将当前设为selected 但是lastIndex最初为0 所以不会将3设为normal
        currentIndex = target
    }
}

