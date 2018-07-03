//
//  LZSegmentControl.swift
//  LZSegmentControl
//
//  Created by Ray on 2017/5/8.
//  Copyright © 2017年 ray. All rights reserved.
//

import UIKit

class LZSegmentControl: UIControl, LZSegmentSliderDelegate, LZSegmentContentDelegate {

    var headerView : LZSegmentSlider!
    var segmentContent : LZSegmentContent!
    

    init(_ headframe: CGRect, _ scrollViewFrame: CGRect, _ titles:[String]) {
        super.init(frame: .zero)
        
        headerView = LZSegmentSlider(frame: headframe, titles: titles)
        headerView.segmentDelegate = self
        segmentContent = LZSegmentContent(frame: scrollViewFrame)
        segmentContent.contentDelegate = self
        segmentContent.segment = headerView
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
       
    }

    public func setUpSubView( child: [UIViewController],
                              _ block: ( _ segment: LZSegmentSlider, _ scorllView: LZSegmentContent) -> Void) {
        
        block(headerView, segmentContent)
        
        let contentWidth = segmentContent.bounds.size.width * CGFloat(child.count)
        segmentContent.contentSize = CGSize(width: contentWidth, height: 0.0)
        
        var x = CGFloat(0.0)
        
        for sub in child {
            let subView = sub.view
            let size = segmentContent.bounds.size
            
            subView?.frame = CGRect(x: x,
                                    y: CGFloat(0.0),
                                    width: size.width,
                                    height: size.height)
            
            segmentContent.addSubview(subView!)
            x += size.width
        }
    
    }
    
    func segmentSlider(segment: LZSegmentSlider, didSelectedIndex: Int) {
        let x = CGFloat(didSelectedIndex) * segmentContent.bounds.size.width
        segmentContent.setContentOffset(CGPoint(x: x, y: 0.0), animated: segmentContent.isAnimation)
    }

    func contentDidScroll(_ offSetX: Float) {
        if headerView.isAnimation { return }
        
        let contentW = Float(segmentContent.bounds.size.width)
        
        
        let leftIndex =  Int(offSetX / contentW)
        let rightIndex = leftIndex + 1
        let leftScale = offSetX / contentW - Float(leftIndex)
        
        headerView.setUpSegmentScroll(leftScale, leftIndex, rightIndex)
        
    }
    
    func contentDidEndDecelerating(_ offSetX: Float, _ selectIndex: Int) {
        headerView.selectedScrollViewAction(index: selectIndex)
        print("contentDidEndScrollingAnimation")
    }
    
    func contentDidEndScrollingAnimation() {
        headerView.isAnimation = false
        print("contentDidEndScrollingAnimation")
    }
    
}
