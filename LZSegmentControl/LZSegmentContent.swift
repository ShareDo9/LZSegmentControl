
//
//  LZSegmentContent.swift
//  LZSegmentControl
//
//  Created by Ray on 2017/5/8.
//  Copyright © 2017年 ray. All rights reserved.
//

import UIKit

@objc protocol LZSegmentContentDelegate: NSObjectProtocol {
    
    @objc optional func contentDidScroll(_ offSetX: Float)
    @objc optional func contentDidEndDecelerating(_ offSetX: Float, _ selectIndex: Int)
    @objc optional func contentDidEndScrollingAnimation()
}

class LZSegmentContent: UIScrollView, UIScrollViewDelegate {

    weak var contentDelegate: LZSegmentContentDelegate?
    
    var contentW = Float(UIScreen.main.bounds.width)
    
    weak var segment: LZSegmentSlider!
    
    /// 滚动动画
    var isAnimation = true
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self;
        self.isPagingEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offSetX = Float(scrollView.contentOffset.x);
        
        if (contentDelegate?.responds(to: #selector(LZSegmentContentDelegate.contentDidScroll)))! {
            contentDelegate?.contentDidScroll!(offSetX)
        }
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let offSetX = Float(scrollView.contentOffset.x);
        let index =  Int(offSetX / contentW)
        
        if (contentDelegate?.responds(to: #selector(LZSegmentContentDelegate.contentDidEndDecelerating)))! {
            contentDelegate?.contentDidEndDecelerating!(offSetX, index)
        }
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {

        if (contentDelegate?.responds(to: #selector(LZSegmentContentDelegate.contentDidEndScrollingAnimation)))! {
            contentDelegate?.contentDidEndScrollingAnimation!()
        }
        
    }
    
}
