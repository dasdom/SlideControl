//
//  DHSlideControl.swift
//  SlideControlDemo
//
//  Created by dasdom on 11.09.15.
//  Copyright © 2015 Dominik Hauser. All rights reserved.
//

import UIKit

class DHSlideControl: UIControl {

  var selectedIndex: Int
  var titles = [String]()
  
  var color: UIColor? {
    didSet {
      backgroundColor = color
      if let color = color {
        rightGradientLayer.colors = [color.colorWithAlphaComponent(0.1).CGColor, color.CGColor]
        leftGradientLayer.colors = [color.colorWithAlphaComponent(0.1).CGColor, color.CGColor]
      }
      tintColor = color
    }
  }
  
  private let scrollView: UIScrollView
  private let labelHostView: UIView
  private var rightBlendView: UIView
  private let leftBlendView: UIView
  private let leftGradientLayer: CAGradientLayer
  private let rightGradientLayer: CAGradientLayer
  
  private var xOffsetAtStart: CGFloat?
  
  init(titles: [String]) {
    scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.pagingEnabled = true
    scrollView.clipsToBounds = false
    scrollView.decelerationRate = UIScrollViewDecelerationRateFast
    scrollView.showsHorizontalScrollIndicator = false
    
    labelHostView = UIView()
    labelHostView.translatesAutoresizingMaskIntoConstraints = false
    
    let controllColor = UIColor(hue: 0.6, saturation: 0.5, brightness: 0.7, alpha: 1.0)
    rightBlendView = UIView()
    rightBlendView.translatesAutoresizingMaskIntoConstraints = false
    rightGradientLayer = CAGradientLayer()
    rightGradientLayer.colors = [controllColor.colorWithAlphaComponent(0.1).CGColor, controllColor.CGColor]
    rightGradientLayer.startPoint = CGPoint(x: 1.0, y: 0.5)
    rightGradientLayer.endPoint = CGPoint(x: 0.2, y: 0.5)
    rightBlendView.layer.addSublayer(rightGradientLayer)
    
    leftBlendView = UIView()
    leftBlendView.translatesAutoresizingMaskIntoConstraints = false
    leftGradientLayer = CAGradientLayer()
    leftGradientLayer.colors = [controllColor.colorWithAlphaComponent(0.1).CGColor, controllColor.CGColor]
    leftGradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
    leftGradientLayer.endPoint = CGPoint(x: 0.8, y: 0.5)
    leftBlendView.layer.addSublayer(leftGradientLayer)
    
    selectedIndex = 0
    
    super.init(frame: .zero)
    backgroundColor = controllColor
    tintColor = controllColor
    clipsToBounds = true
    
    self.titles = titles
    scrollView.delegate = self
    addGestureRecognizer(UIPanGestureRecognizer(target: self, action: "didPan:"))

    let imageView = UIImageView(image: triangleImage(controllColor))
    imageView.translatesAutoresizingMaskIntoConstraints = false
    
    addSubview(scrollView)
    scrollView.addSubview(labelHostView)
    addSubview(rightBlendView)
    addSubview(leftBlendView)
    addSubview(imageView)
    
    var layoutConstraints = [NSLayoutConstraint]()

    var previousLabel: UILabel?
    for (index, string) in titles.enumerate() {
      let label = UILabel()
      label.translatesAutoresizingMaskIntoConstraints = false
      labelHostView.addSubview(label)
      label.text = string
      label.textAlignment = .Center
      label.backgroundColor = .whiteColor()
      
      layoutConstraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[label]-20-|", options: [], metrics: nil, views: ["label": label])
      
      if previousLabel == nil {
        layoutConstraints.append(label.leadingAnchor.constraintEqualToAnchor(labelHostView.leadingAnchor))
      } else {
        layoutConstraints.append(label.leadingAnchor.constraintEqualToAnchor(previousLabel?.trailingAnchor))
        layoutConstraints.append(label.widthAnchor.constraintEqualToAnchor(previousLabel?.widthAnchor))
      }
      previousLabel = label
      
      if index == titles.count-1 {
        layoutConstraints.append(label.trailingAnchor.constraintEqualToAnchor(labelHostView.trailingAnchor))
      }
    }
    
    let views = ["scrollView": scrollView, "host": labelHostView, "right": rightBlendView, "left": leftBlendView]
    layoutConstraints += NSLayoutConstraint.constraintsWithVisualFormat("|[right(70)][scrollView][left(70)]|", options: [.AlignAllTop, .AlignAllBottom], metrics: nil, views: views)
    layoutConstraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollView]|", options: [], metrics: nil, views: views)
    layoutConstraints += NSLayoutConstraint.constraintsWithVisualFormat("|[host]|", options: [], metrics: nil, views: views)
    layoutConstraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|[host]|", options: [], metrics: nil, views: views)
    layoutConstraints.append(imageView.centerXAnchor.constraintEqualToAnchor(centerXAnchor))
    layoutConstraints.append(imageView.centerYAnchor.constraintEqualToAnchor(centerYAnchor, constant: 20))
    NSLayoutConstraint.activateConstraints(layoutConstraints)
    
  }
  
  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()
    
//    print(scrollView.frame)
    labelHostView.widthAnchor.constraintEqualToConstant(CGFloat(titles.count)*scrollView.frame.size.width).active = true
    labelHostView.heightAnchor.constraintEqualToConstant(scrollView.frame.size.height).active = true
    
    leftGradientLayer.frame = leftBlendView.bounds
    rightGradientLayer.frame = rightBlendView.bounds
  }
  
  func didPan(sender: UIPanGestureRecognizer) {
    let xTranslation = sender.translationInView(self).x
    
    switch sender.state {
    case .Began:
      xOffsetAtStart = scrollView.contentOffset.x
    case .Changed:
      if let xOffsetAtStart = xOffsetAtStart {
        scrollView.setContentOffset(CGPoint(x: -xTranslation + xOffsetAtStart, y: 0), animated: false)
      }
    case .Ended:
      xOffsetAtStart = nil
      let widthOfLabel = floor(scrollView.contentSize.width/CGFloat(titles.count))
//      print(scrollView.contentOffset.x/widthOfLabel)
      let offset = max(min(round(scrollView.contentOffset.x/widthOfLabel), CGFloat(titles.count-1)), 0.0)*widthOfLabel
      
//      scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: true)
//      let xVelocity = sender.velocityInView(self).x
//      
//      print(offset-scrollView.contentOffset.x)
////      Double(abs(offset-scrollView.contentOffset.x)/50.0)
//      UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: xVelocity/30, options: [], animations: { () -> Void in
//        self.scrollView.contentOffset.x = offset
//        }, completion: nil)
      
      UIView.animateWithDuration(0.5, animations: { () -> Void in
        self.scrollView.setContentOffset(CGPoint(x: offset, y: 0), animated: false)
        }, completion: { (_) -> Void in
          self.scrollViewDidEndDecelerating(self.scrollView)
      })
      
    default:
      break
    }
  }
  
  func triangleImage(color: UIColor) -> UIImage {
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(240, 120), false, 0)
    let polygonPath = UIBezierPath()
    polygonPath.moveToPoint(CGPointMake(118, 55))
    polygonPath.addLineToPoint(CGPointMake(152, 77))
    polygonPath.addLineToPoint(CGPointMake(84, 77))
    polygonPath.closePath()
    color.setFill()
    polygonPath.fill()
    
    let image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    
    return image.imageWithRenderingMode(.AlwaysTemplate)
  }

}

extension DHSlideControl : UIScrollViewDelegate {
  func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
    let widthOfLabel = floor(scrollView.contentSize.width/CGFloat(titles.count))
    selectedIndex = Int(round(scrollView.contentOffset.x/widthOfLabel))
    sendActionsForControlEvents(.ValueChanged)
  }
  
  func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    if !decelerate {
      let widthOfLabel = floor(scrollView.contentSize.width/CGFloat(titles.count))
      selectedIndex = Int(round(scrollView.contentOffset.x/widthOfLabel))
      sendActionsForControlEvents(.ValueChanged)
    }
  }
}
