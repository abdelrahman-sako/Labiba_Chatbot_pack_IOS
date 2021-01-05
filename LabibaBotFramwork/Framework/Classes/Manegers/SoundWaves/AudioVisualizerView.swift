//
//  AudioVisualizerView.swift
//  LabibaBotFramwork
//
//  Created by Abdulrahman on 7/13/20.
//  Copyright © 2020 Abdul Rahman. All rights reserved.
//


import UIKit

class AudioVisualizerView: UIView {
    
    // Bar width
    var barWidth: CGFloat = 2.0
    var barsNumber: Int = 30
    var barTopBottomInset: CGFloat = 2
    var isRounded:Bool = true
    var gapWidth:CGFloat = 60
    
    public private(set) var animating = false
    fileprivate var displayLink: CADisplayLink?
    fileprivate var animatingStart = false
    fileprivate var animatingStop = false
    var workItem:DispatchWorkItem?
    var speed:Int = 60
    // Colors for bars
    var colors:[CGColor] = [UIColor.red.cgColor, UIColor.yellow.cgColor]//[UIColor(argb: 0xffffbc47).cgColor, UIColor(argb: 0xff8C232A).cgColor]
    // Given waveforms
    lazy var targetWaveforms: [Int] = Array(repeating: 0, count: barsNumber)
    lazy  private var waveforms: [Int] = Array(repeating: 0, count: barsNumber)
    
    // MARK: - Init
    override init (frame : CGRect) {
        super.init(frame : frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
        self.backgroundColor = UIColor.clear
    }
    
    func reload() {
        setNeedsDisplay()
    }
    
    func deg2rad(_ number: Double) -> Double {
        return number * .pi / 180
    }
    
    // MARK: Control Methods
    
    public func start() {
        if (animating) {
            
            return
        }
        
        invalidate()
        animating = true
        animatingStop = false
        animatingStart = true
        displayLink = CADisplayLink(target: self, selector: #selector(drawBars))
        displayLink!.preferredFramesPerSecond = speed // control the speed
        displayLink!.add(to: RunLoop.main, forMode: RunLoop.Mode.common)
        
       
    }
    
    public func stop() {
        invalidate()
        animating = false
        animatingStart = false
        animatingStop = true
    }
    
    
    // MARK: Private Methods
    
    private func invalidate() {
        
        displayLink?.isPaused = true
        displayLink?.remove(from: RunLoop.main, forMode: RunLoop.Mode.common)
        displayLink = nil
        DispatchQueue.main.async {
            self.workItem?.cancel()
        }
    }
    @objc private func drawBars() {
        waveforms = waveforms.enumerated().map({ (index , item)  in
            //print("index " , index , "item " , item)
            var dif = abs(targetWaveforms[index] - item)/3
            if dif < 1 {
                dif = 1
            }
           // print(dif)
            if targetWaveforms[index] > item {
                return item + dif
            }else if targetWaveforms[index] < item{
                return item - dif
            }
            return targetWaveforms[index]//item
        })
        setNeedsDisplay()
    }
    // MARK: - Draw bars
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        
        
        context.clear(rect)
        context.setFillColor(red: 0, green: 0, blue: 0, alpha: 0)
        context.fill(rect)
        //context.setLineWidth(2)
        //context.setLineCap(.round)
        //context.setStrokeColor(UIColor.black.withAlphaComponent(0.3).cgColor)
        
        let rightPath = UIBezierPath()
        let leftPath = UIBezierPath()
        
        let w = rect.size.width/2
        let h = rect.size.height //- barWidth
        let mid = h / 2
        let radius = self.barWidth / 2
        let maxValue = h - radius - barTopBottomInset
        let barOffset = (w - gapWidth/2)/CGFloat(self.waveforms.count)
        var bar: CGFloat = 0
        for i in 0 ..< self.waveforms.count {
            var value = h * CGFloat(self.waveforms[i]) / 30.0
            value = value - 7
            if value > maxValue {
                value = maxValue
            }
            else if value < 1 {
                value = 1
            }
            
            let oneX = bar * barOffset //bar * self.barWidth
            var oneY: CGFloat = 0
            
            
            oneY = mid - value/2
            leftPath.move(to: CGPoint(x: oneX, y: oneY ))
            leftPath.addLine(to: CGPoint(x: oneX, y: oneY + value))
            if isRounded {
                leftPath.addArc(withCenter: CGPoint(x: oneX + barWidth/2, y: oneY + value), radius: barWidth/2 , startAngle: CGFloat(deg2rad(180)), endAngle: 0, clockwise: false)
            }else{
                leftPath.addLine(to: CGPoint(x: oneX + barWidth, y: oneY + value))
            }
            
            leftPath.addLine(to: CGPoint(x: oneX + barWidth, y: oneY))
            if isRounded {
                leftPath.addArc(withCenter: CGPoint(x: oneX + barWidth/2, y:  oneY), radius: barWidth/2 , startAngle: 0, endAngle: CGFloat(deg2rad(180)), clockwise: false)
            }else{
                leftPath.addLine(to: CGPoint(x: oneX , y: oneY))
            }
            
            let refletedOneX = self.bounds.width/2  - oneX + 1
            
            rightPath.move(to: CGPoint(x: refletedOneX, y: oneY ))
            rightPath.addLine(to: CGPoint(x: refletedOneX, y: oneY + value))
            if isRounded {
                rightPath.addArc(withCenter: CGPoint(x: refletedOneX + barWidth/2, y: oneY + value), radius: barWidth/2 , startAngle: CGFloat(deg2rad(180)), endAngle: 0, clockwise: false)
            }else{
                rightPath.addLine(to: CGPoint(x: refletedOneX + barWidth, y: oneY + value))
            }
            
            rightPath.addLine(to: CGPoint(x: refletedOneX + barWidth, y: oneY))
            if isRounded {
                rightPath.addArc(withCenter: CGPoint(x: refletedOneX + barWidth/2, y:  oneY), radius: barWidth/2 , startAngle: 0, endAngle: CGFloat(deg2rad(180)), clockwise: false)
            }else{
                rightPath.addLine(to: CGPoint(x: refletedOneX , y: oneY))
            }
           // if bar == 2 {break}
            bar += 1
        }
        
//        rightPath.addClip()
//        leftPath.addClip()
        let offsets = [ CGFloat(0.0), CGFloat(1.0) ]
//        let grad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: offsets)
//        context.drawLinearGradient(grad!, start: CGPoint(x: 0, y: 0), end:  CGPoint(x: 0, y: h), options: [])
        
        self.layer.sublayers?.forEach({$0.removeFromSuperlayer()})
        
       
        
        let gradientLayer1 = CAGradientLayer()
        gradientLayer1.colors = colors
        gradientLayer1.locations = offsets as [NSNumber]
        gradientLayer1.startPoint  = CGPoint(x: 0, y: 0)
        gradientLayer1.endPoint  = CGPoint(x: 0, y: 1)
        gradientLayer1.frame = CGRect(x: 0, y: 0, width: bounds.width/2 + 10 , height: bounds.height)
        
        self.layer.addSublayer(gradientLayer1)
        let mask = CAShapeLayer()
        mask.path = leftPath.cgPath
        gradientLayer1.mask = mask
        
        let gradientLayer2 = CAGradientLayer()
        gradientLayer2.colors = colors.reversed()
        gradientLayer2.locations = offsets as [NSNumber]
        gradientLayer2.startPoint  = CGPoint(x: 0, y: 0)
        gradientLayer2.endPoint  = CGPoint(x: 0, y: 1)
        gradientLayer2.frame = CGRect(x: bounds.width/2, y: 0, width: bounds.width/2 + 10 , height: bounds.height)
        
        self.layer.addSublayer(gradientLayer2)
        let mask2 = CAShapeLayer()
        mask2.path = rightPath.cgPath
        gradientLayer2.mask = mask2
        
        
        
        
        
    }
    
}



//import UIKit
//
//class AudioVisualizerView: UIView {
//
//    // Bar width
//    var barWidth: CGFloat = 2.0
//    var barTopBottomInset: CGFloat = 2
//    var isRounded:Bool = true
//    var gapWidth:CGFloat = 60
//
//    // Colors for bars
//    var colors:[CGColor] = [UIColor.red.cgColor, UIColor.yellow.cgColor]//[UIColor(argb: 0xffffbc47).cgColor, UIColor(argb: 0xff8C232A).cgColor]
//    // Given waveforms
//    var waveforms: [Int] = Array(repeating: 0, count: 20)
//
//    // MARK: - Init
//    override init (frame : CGRect) {
//        super.init(frame : frame)
//        self.backgroundColor = UIColor.clear
//    }
//
//    required init?(coder decoder: NSCoder) {
//        super.init(coder: decoder)
//        self.backgroundColor = UIColor.clear
//    }
//
//    func reload() {
//        setNeedsDisplay()
//    }
//
//    func deg2rad(_ number: Double) -> Double {
//        return number * .pi / 180
//    }
//    // MARK: - Draw bars
//
//    override func draw(_ rect: CGRect) {
//        guard let context = UIGraphicsGetCurrentContext() else {
//            return
//        }
//
//
//        context.clear(rect)
//        context.setFillColor(red: 0, green: 0, blue: 0, alpha: 0)
//        context.fill(rect)
//        //context.setLineWidth(2)
//        //context.setLineCap(.round)
//        //context.setStrokeColor(UIColor.black.withAlphaComponent(0.3).cgColor)
//
//        let rightPath = UIBezierPath()
//        let leftPath = UIBezierPath()
//
//        let w = rect.size.width/2
//        let h = rect.size.height //- barWidth
//        let mid = h / 2
//        let radius = self.barWidth / 2
//        let maxValue = h - radius - barTopBottomInset
//        let barOffset = (w - gapWidth/2)/CGFloat(self.waveforms.count)
//        var bar: CGFloat = 0
//        for i in 0 ..< self.waveforms.count {
//            var value = h * CGFloat(self.waveforms[i]) / 50.0
//            if value > maxValue {
//                value = maxValue
//            }
//            else if value < 3 {
//                value = 3
//            }
//            let oneX = bar * barOffset//bar * self.barWidth
//            var oneY: CGFloat = 0
//
//
//            oneY = mid - value/2
//            leftPath.move(to: CGPoint(x: oneX, y: oneY ))
//            leftPath.addLine(to: CGPoint(x: oneX, y: oneY + value))
//            if isRounded {
//                leftPath.addArc(withCenter: CGPoint(x: oneX + barWidth/2, y: oneY + value), radius: barWidth/2 , startAngle: CGFloat(deg2rad(180)), endAngle: 0, clockwise: false)
//            }else{
//                leftPath.addLine(to: CGPoint(x: oneX + barWidth, y: oneY + value))
//            }
//
//            leftPath.addLine(to: CGPoint(x: oneX + barWidth, y: oneY))
//            if isRounded {
//                leftPath.addArc(withCenter: CGPoint(x: oneX + barWidth/2, y:  oneY), radius: barWidth/2 , startAngle: 0, endAngle: CGFloat(deg2rad(180)), clockwise: false)
//            }else{
//                leftPath.addLine(to: CGPoint(x: oneX , y: oneY))
//            }
//
//            let refletedOneX = self.bounds.width/2  - oneX
//
//            rightPath.move(to: CGPoint(x: refletedOneX, y: oneY ))
//            rightPath.addLine(to: CGPoint(x: refletedOneX, y: oneY + value))
//            if isRounded {
//                rightPath.addArc(withCenter: CGPoint(x: refletedOneX + barWidth/2, y: oneY + value), radius: barWidth/2 , startAngle: CGFloat(deg2rad(180)), endAngle: 0, clockwise: false)
//            }else{
//                rightPath.addLine(to: CGPoint(x: refletedOneX + barWidth, y: oneY + value))
//            }
//
//            rightPath.addLine(to: CGPoint(x: refletedOneX + barWidth, y: oneY))
//            if isRounded {
//                rightPath.addArc(withCenter: CGPoint(x: refletedOneX + barWidth/2, y:  oneY), radius: barWidth/2 , startAngle: 0, endAngle: CGFloat(deg2rad(180)), clockwise: false)
//            }else{
//                rightPath.addLine(to: CGPoint(x: refletedOneX , y: oneY))
//            }
//
//            bar += 1
//        }
//
////        rightPath.addClip()
////        leftPath.addClip()
//        let offsets = [ CGFloat(0.0), CGFloat(1.0) ]
////        let grad = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: colors as CFArray, locations: offsets)
////        context.drawLinearGradient(grad!, start: CGPoint(x: 0, y: 0), end:  CGPoint(x: 0, y: h), options: [])
//
//        self.layer.sublayers?.forEach({$0.removeFromSuperlayer()})
//
//
//
//        let gradientLayer1 = CAGradientLayer()
//        gradientLayer1.colors = colors
//        gradientLayer1.locations = offsets as [NSNumber]
//        gradientLayer1.startPoint  = CGPoint(x: 0, y: 0)
//        gradientLayer1.endPoint  = CGPoint(x: 0, y: 1)
//        gradientLayer1.frame = CGRect(x: 0, y: 0, width: bounds.width/2, height: bounds.height)
//
//        self.layer.addSublayer(gradientLayer1)
//        let mask = CAShapeLayer()
//        mask.path = leftPath.cgPath
//        gradientLayer1.mask = mask
//
//        let gradientLayer2 = CAGradientLayer()
//        gradientLayer2.colors = colors.reversed()
//        gradientLayer2.locations = offsets as [NSNumber]
//        gradientLayer2.startPoint  = CGPoint(x: 0, y: 0)
//        gradientLayer2.endPoint  = CGPoint(x: 0, y: 1)
//        gradientLayer2.frame = CGRect(x: bounds.width/2, y: 0, width: bounds.width/2, height: bounds.height)
//
//        self.layer.addSublayer(gradientLayer2)
//        let mask2 = CAShapeLayer()
//        mask2.path = rightPath.cgPath
//        gradientLayer2.mask = mask2
//
//
//
//
//
//    }
//
//}
