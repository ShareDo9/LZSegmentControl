//
//  LZSegmentSlider.swift
//  LZSegmentControl
//
//  Created by Ray on 2017/5/8.
//  Copyright © 2017年 ray. All rights reserved.
//

import UIKit

protocol LZSegmentSliderDelegate: class {
    
    func segmentSlider(segment: LZSegmentSlider, didSelectedIndex:Int)
    
}

/// 分段按钮样式
///
/// - defult: 默认样式
/// - line: 线条样式
enum LZSegmentSliderStyle: Int {

    case defult
    
    case line
}

/// 分段按钮宽度类型
///
/// - equallyWidth: 均分
/// - titleLengthWith: 根据按钮标题长度
/// - fixedWidth: 固定宽度
enum LZSegmentSliderLayoutStyle {
    
    case equallyWidth
    
    case titleLengthWith
    
    case fixedWidth
}

/// 分段按钮线条宽度类型
///
/// - equallyScale: 等比例
/// - equallyTitleWith: 等于标题长度
/// - fixedWidth: 固定宽度
enum LZSegmentSliderIndicatorStyle {
    
    case equallyScale
    
    case equallyTitleWith
    
    case fixedWidth
}

fileprivate let defultSelectedIndex = 0


class LZSegmentSlider: UIScrollView {

    weak var segmentDelegate: LZSegmentSliderDelegate?
    
    var selectIndex: Int = defultSelectedIndex
    
    var curIndex: Int = defultSelectedIndex
    
    var titlesArray: [String]?
    
    lazy var segmentBtns: [UIButton] = {
    
        let btn = Array<UIButton>()
        return btn
    }()
    
    lazy var segmentWidths: [CGFloat] = {
        
        let btn = Array<CGFloat>()
        return btn
    }()
    
    var segmentTatolWidth: CGFloat = 0.0
    
    var isAnimation = false
    
    var indicatorView: UIView = UIView()
    
    
    // MARK: 属性设置
    
    /// 选中时按钮颜色 ---- 默认为black
    var titleSelColor = UIColor.black {
        didSet {
            self.setUp(selColor: titleSelColor)
        }
    }
    
    /// 未选中时按钮颜色 ---- 默认为darkText
    var titleNorColor = UIColor.darkGray {
        didSet {
            self.setUp(nomalColor: titleNorColor)
        }
    }
    
    /// 选中时按钮字体大小 ---- 默认为16.0
    private var titleSelFont: CGFloat = 16.0
    
    /// 未选中时按钮字体大小 ---- 默认为14.0
    var titleNorFont: CGFloat = 14.0 {
        didSet {
            titleScale = titleSelFont / titleNorFont
        }
    }
    
    /// 选中时按钮字体比例
    var titleScale: CGFloat = 16.0/14.0 {
        didSet {
            titleSelFont = titleScale * titleNorFont
        }
    }
    
    /// 按钮标题边距大小 ---- 只有在titleLengthWith类型下才有效。默认为10.0
    var titleContentOffSet: CGFloat = 10.0
    
    /// 线条颜色 ---- 默认为black
    var indicatorColor: UIColor = UIColor.black
    
    /// 线条高度 ---- 默认为5.0
    var indicatorheight: CGFloat = 2.0
    
    /// 线条的固定宽度 ---- 类型为fixedWidth，默认20.0
    var indicatorFixedWidth: CGFloat = 20.0
    
    /// 线条宽度比例 ---- 类型为equallyScale，默认为0.5
    var indicatorWidthScale: CGFloat = 0.5
    
    /// 线条宽度样式
    var segmentIndicatorSytle: LZSegmentSliderIndicatorStyle = .equallyScale
    
    ///分段按钮样式 ---- 默认为defult
    var segmentSytle: LZSegmentSliderStyle = .defult

    ///分段按钮宽度类型 ---- 默认equallyWidth
    var segmentLayoutSytle: LZSegmentSliderLayoutStyle = .equallyWidth
    
    ///单个分段按钮的固定宽度 ---- 类型为fixedWidth，默认为60.0
    var segmentWidth: CGFloat = 80.0
    
    ///延迟效果 ---- 等滚动完成后
    var isDelay = false
    
    /// 无特效 ---- 无动画
    var noEffect = false
    
    
    var startR: CGFloat = 0.0
    var startG: CGFloat = 0.0
    var startB: CGFloat = 0.0
    
    var endR: CGFloat = 0.0
    var endG: CGFloat = 0.0
    var endB: CGFloat = 0.0
    
    init(frame: CGRect, titles:[String]) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.titlesArray = titles
        
        initCustomView()

        setUp(selColor: titleSelColor)
        setUp(nomalColor: titleNorColor)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        UIColor.white.setFill()
        UIRectFill(self.bounds)
        
        initSegmentBtn()
        
        initIndicatorView()
        
    }
    
    fileprivate func initCustomView() {
        
        self.bounces = true
        self.contentSize = self.bounds.size
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        
    }
    
    fileprivate func initSegmentBtn() {
        
        guard let titles = titlesArray, titles.count > 0  else {
            return
        }
        
        var btnX: CGFloat = 0.0
        let btnY: CGFloat = 0.0
        let btnH: CGFloat = self.frame.size.height
        var btnW: CGFloat = 0.0
        
        for title in titles {
            
            switch segmentLayoutSytle {
            case .equallyWidth:
                
                btnW = self.bounds.size.width / CGFloat(titles.count)
                
            case .fixedWidth:
                
                btnW = CGFloat(segmentWidth)
                
            case .titleLengthWith:

                btnW = textWidth(string: title, height: btnH, font: titleSelFont) + titleContentOffSet * 2
            }
            
            let index = (titles.index(of: title))!
            let titleColor  = index == curIndex ? titleSelColor : titleNorColor
            let titleFont   = index == curIndex ? titleSelFont : titleNorFont
            
            let btn = UIButton(frame: CGRect(x: btnX, y: btnY, width: btnW, height: btnH))
            btn.addTarget(self, action: #selector(selectedAction(_:)), for: .touchUpInside)
            btn.setTitle(title, for: .normal)
            btn.setTitleColor(titleColor, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: titleFont)
            
            segmentBtns.append(btn)
            segmentWidths.append(btnW)
            
            addSubview(btn)
            
            btnX += btnW
            if index < titles.count {
                segmentTatolWidth += btnW
            }
        }
        
        self.contentSize = CGSize(width: segmentTatolWidth, height: self.contentSize.height)
        
    }
    
    fileprivate func initIndicatorView() {
        
        guard segmentWidths.count > 0, segmentSytle == .line else {
            return
        }
        
        indicatorView.backgroundColor = indicatorColor
        
        let btnW: CGFloat = segmentWidths[curIndex]
        
        var indicatorW: CGFloat = btnW * indicatorWidthScale
        let indicatorH: CGFloat = indicatorheight
        let indicatorX: CGFloat = 0
        let indicatorY: CGFloat = self.bounds.size.height - indicatorH
        
        if segmentIndicatorSytle == .equallyTitleWith {
            
            if (titlesArray?.count)! > curIndex {
                
                let title = titlesArray![curIndex]
     
                indicatorW = textWidth(string: title, height: self.frame.size.height, font: titleSelFont)
            }
        }else if segmentIndicatorSytle == .fixedWidth {
            
            indicatorW = indicatorFixedWidth
        }
        
        indicatorView.frame = CGRect(x: indicatorX, y: indicatorY, width: indicatorW, height: indicatorH)
        
        if segmentBtns.count > curIndex {
            
            let btn = segmentBtns[curIndex]
            
            indicatorView.center = CGPoint(x: btn.center.x, y: indicatorView.center.y)
        }
        
        addSubview(indicatorView)
    }
    
    func selectedScrollViewAction(index: Int) {
        
        selectIndex = index
        
        if segmentLayoutSytle != .equallyWidth &&
            segmentTatolWidth > self.bounds.size.width {
            
            let indexBtn = segmentBtns[index]
            
            let left = indexBtn.center.x
            
            let right = segmentTatolWidth - left
            
            if left < self.bounds.size.width/2.0 {
                
                self.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                
            }else if right < self.bounds.size.width/2.0 {
                
                self.setContentOffset(CGPoint(x: segmentTatolWidth - self.bounds.size.width, y: 0), animated: true)
                
            }else {
                
                self.setContentOffset(CGPoint(x: left - self.bounds.size.width/2.0, y: 0), animated: true)
            }
            
            
        }
        curIndex = index
    }
    
    @objc private func selectedAction(_ sender: UIButton) {
        guard !isAnimation else { return }
        
        let selectBtn = sender
        
        let currentBtn = segmentBtns[curIndex]
        
        let selectIndex = segmentBtns.index(of: sender)
        
        if selectIndex == curIndex { return }

        let scaleNor = titleNorFont/titleSelFont
        
        if noEffect {
            isAnimation = true
            
            selectBtn.titleLabel?.font = UIFont.systemFont(ofSize: self.titleSelFont)
            currentBtn.titleLabel?.font = UIFont.systemFont(ofSize: self.titleNorFont)
            
            selectBtn.setTitleColor(self.titleSelColor, for: .normal)
            currentBtn.setTitleColor(self.titleNorColor, for: .normal)
            
            if self.segmentSytle == .line {
                
                var indicatorFrame = self.indicatorView.frame
                
                
                if self.segmentIndicatorSytle == .equallyScale {
                    
                    indicatorFrame.size.width = self.segmentWidths[selectIndex!] * self.indicatorWidthScale
                    
                }else if self.segmentIndicatorSytle == .equallyTitleWith {
                    
                    let title = self.titlesArray![selectIndex!]
                    
                    indicatorFrame.size.width = textWidth(string: title, height: self.frame.size.height, font: self.titleSelFont)
                    
                }else {
                    
                    
                    
                }
                
                self.indicatorView.frame = indicatorFrame
                self.indicatorView.center = CGPoint(x: selectBtn.center.x, y: self.indicatorView.center.y)
            }
            
            self.selectedScrollViewAction(index: selectIndex!)
            
        }else {
            
            isAnimation = true
            UIView.animate(withDuration: 0.3, animations: {
                
                if self.titleScale != 1.0 {
                    selectBtn.transform = CGAffineTransform(scaleX: self.titleScale, y: self.titleScale)
                    currentBtn.transform = CGAffineTransform(scaleX: scaleNor, y: scaleNor)
                }
                
                selectBtn.setTitleColor(self.titleSelColor, for: .normal)
                currentBtn.setTitleColor(self.titleNorColor, for: .normal)
                
                if self.segmentSytle == .line {
                    
                    var indicatorFrame = self.indicatorView.frame
                    
                    
                    if self.segmentIndicatorSytle == .equallyScale {
                        
                        indicatorFrame.size.width = self.segmentWidths[selectIndex!] * self.indicatorWidthScale
                        
                    }else if self.segmentIndicatorSytle == .equallyTitleWith {
                        
                        let title = self.titlesArray![selectIndex!]
                        
                        indicatorFrame.size.width = textWidth(string: title, height: self.frame.size.height, font: self.titleSelFont)
                        
                    }else {
                        
                        
                        
                    }
                    
                    self.indicatorView.frame = indicatorFrame
                    self.indicatorView.center = CGPoint(x: selectBtn.center.x, y: self.indicatorView.center.y)
                }
                
                
            }) { (completion) in
                
                if self.titleScale != 1.0 {
                    selectBtn.transform = CGAffineTransform.identity
                    currentBtn.transform = CGAffineTransform.identity
                    
                    selectBtn.titleLabel?.font = UIFont.systemFont(ofSize: self.titleSelFont)
                    currentBtn.titleLabel?.font = UIFont.systemFont(ofSize: self.titleNorFont)
                }
                
                self.selectedScrollViewAction(index: selectIndex!)
                
                self.isAnimation = false
            }
            
        }
    
        let index = segmentBtns.index(of: sender)
        
        if let delegate = segmentDelegate {
            delegate.segmentSlider(segment: self, didSelectedIndex: index!)
        }
    }
    
    public func setUpSegmentScroll(_ scale: Float, _ leftIndex: Int, _ rightIndex: Int) {
        
        let leftBtn = segmentBtns[leftIndex]
        let rightBtn = rightIndex < segmentBtns.count ? segmentBtns[rightIndex] : nil
        
        if noEffect {
            
            if scale > 0.5 {
                
                leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: self.titleNorFont)
                rightBtn?.titleLabel?.font = UIFont.systemFont(ofSize: self.titleSelFont)
                
                leftBtn.setTitleColor(self.titleNorColor, for: .normal)
                rightBtn?.setTitleColor(self.titleSelColor, for: .normal)
                
                if self.segmentSytle == .line {
                    if self.segmentLayoutSytle == .titleLengthWith {
                        
                        self.indicatorView.frame = CGRect(x: self.indicatorView.frame.origin.x,
                                                          y: self.indicatorView.frame.origin.y,
                                                          width: self.segmentWidths[self.selectIndex] * self.indicatorWidthScale,
                                                          height: self.indicatorView.frame.size.height)
                    }
                    
                    if rightBtn != nil {
                        self.indicatorView.center = CGPoint(x: (rightBtn?.center.x)!, y: self.indicatorView.center.y)
                    }
                }
                
            }else {
                
                leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: self.titleSelFont)
                rightBtn?.titleLabel?.font = UIFont.systemFont(ofSize: self.titleNorFont)
                
                leftBtn.setTitleColor(self.titleSelColor, for: .normal)
                rightBtn?.setTitleColor(self.titleNorColor, for: .normal)
                
                if self.segmentSytle == .line {
                    if self.segmentLayoutSytle == .titleLengthWith {
                        
                        self.indicatorView.frame = CGRect(x: self.indicatorView.frame.origin.x,
                                                          y: self.indicatorView.frame.origin.y,
                                                          width: self.segmentWidths[self.selectIndex] * self.indicatorWidthScale,
                                                          height: self.indicatorView.frame.size.height)
                    }
                    
                    self.indicatorView.center = CGPoint(x: leftBtn.center.x, y: self.indicatorView.center.y)
                }
                
            }
        
        }else {
            
            titleFontChange(scale, leftBtn, rightBtn)
            
            titleColor(scale, leftBtn, rightBtn)
            
            setUpIndicatorView(scale, leftBtn, rightBtn)
        }
    }
    
    private func titleFontChange(_ scale: Float, _ leftBtn: UIButton, _ rightBtn: UIButton? ) {
        if titleNorFont == titleSelFont { return }
        let font = titleSelFont - titleNorFont
        
        let leftFont = titleNorFont + CGFloat(1 - scale) * font
        let rightFont = titleNorFont + CGFloat(scale) * font
        
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: leftFont)
        if let btn = rightBtn {
            btn.titleLabel?.font = UIFont.systemFont(ofSize: rightFont)
        }
    }
    
    
    private func titleColor(_ scale: Float, _ leftBtn: UIButton, _ rightBtn: UIButton?) {
        if  endR == startR &&
            endG == startG &&
            endB == startB {
            return
        }
        
        let r = endR - startR
        let g = endG - startG
        let b = endB - startB
        
        let leftScale = CGFloat(1 - scale)
        let rightScale = CGFloat(scale)
        
        leftBtn.setTitleColor(UIColor(red: startR + leftScale * r,
                                      green: startG + leftScale * g,
                                      blue: startB + leftScale * b,
                                      alpha: 1.0), for: .normal)
        if let btn = rightBtn {
            btn.setTitleColor(UIColor(red: startR + rightScale * r,
                                      green: startG + rightScale * g,
                                      blue: startB + rightScale * b,
                                      alpha: 1.0), for: .normal)
        }
        
    }
    
    private func setUpIndicatorView(_ scale: Float, _ leftBtn: UIButton, _ rightBtn: UIButton?) {
        guard segmentSytle == .line else {
            return
        }
        
        let cornerX = leftBtn.center.x

        guard let btn = rightBtn else {
            return
        }
        
        let diff = btn.center.x - cornerX
        
        var centerP = indicatorView.center
        centerP.x = cornerX + diff * CGFloat(scale)
        
        indicatorView.center = centerP
        
        if segmentIndicatorSytle == .equallyTitleWith {
            let leftTextW = textWidth(string: (leftBtn.titleLabel?.text)!, height: self.frame.size.height, font: titleSelFont)
            let rightTextW = textWidth(string: (rightBtn?.titleLabel?.text)!, height: self.frame.size.height, font: titleSelFont)
            
            let diffW = rightTextW - leftTextW
            let indicatorW = leftTextW + diffW * CGFloat(scale)
            var indicatorFrame = indicatorView.frame
            indicatorFrame.size.width = indicatorW
            indicatorView.frame = indicatorFrame
        }
        
    }
    
    private func setUp(nomalColor color: UIColor) {
        let components = fetchRGB(forColor: color)
        guard components.count >= 3 else {
            return
        }
        startR = CGFloat(components[0])
        startG = CGFloat(components[1])
        startB = CGFloat(components[2])
    }
    
    private func setUp(selColor color:UIColor) {
        let components = fetchRGB(forColor: color)
        guard components.count >= 3 else {
            return
        }
        endR = CGFloat(components[0])
        endG = CGFloat(components[1])
        endB = CGFloat(components[2])
    }
    
}

extension LZSegmentSlider {

    
    
}

fileprivate func textWidth(string: String, height: CGFloat, font: CGFloat) -> CGFloat {
    
    let text = string as NSString
    
    return text.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: height),
                             options: [.usesLineFragmentOrigin],
                             attributes: [kCTFontAttributeName as NSAttributedStringKey : UIFont.systemFont(ofSize: font)],
                             context: nil).size.width
}

fileprivate func fetchRGB(forColor color: UIColor) -> [Float] {
    
    let rgbColorSpace = CGColorSpaceCreateDeviceRGB()

    let resultingPixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 3)
    
    let context = CGContext(data: resultingPixel,
                            width: 1,
                            height: 1,
                            bitsPerComponent: 8,
                            bytesPerRow: 4,
                            space: rgbColorSpace,
                            bitmapInfo: 1)
    context!.setFillColor(color.cgColor)
    context!.fill(CGRect.init(x: 0, y: 0, width: 1, height: 1))
//    CGContextRelease(context!)
//    CGColorSpaceRelease(rgbColorSpace)
    
    var components: [Float] = Array<Float>()
    
    for i in 0...2 {
        let component = Float(resultingPixel[i])/255.0
        components.append(component)
    }
    
    return components
}
