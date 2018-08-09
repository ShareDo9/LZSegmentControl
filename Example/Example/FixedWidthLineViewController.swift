

//
//  FixedWidthLineViewController.swift
//  LZSegmentControl
//
//  Created by Ray on 2018/7/3.
//  Copyright © 2018年 wangrui. All rights reserved.
//

import UIKit

class FixedWidthLineViewController: UIViewController {

    let control = LZSegmentControl(CGRect(x: 0, y: 20, width: SCREEN_WIDTH, height: 44),
                                   CGRect(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64.0),
                                   ["个性推荐", "歌单", "主播电台", "排行榜"])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let array = [ViewController(), ViewController(), ViewController(), ViewController()]
        
        control.setUpSubView(child: array) { [weak self] (slider, contentView) in
            
            slider.segmentLayoutSytle = .titleLengthWith
            slider.segmentIndicatorSytle = .fixedWidth
            slider.segmentSytle = .line
            slider.indicatorFixedWidth = 50.0
            slider.titleSelColor = .red
            
            self?.view.addSubview(slider)
            self?.view.addSubview(contentView)
        }
        
    }

}
