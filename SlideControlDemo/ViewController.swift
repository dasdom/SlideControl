//
//  ViewController.swift
//  SlideControlDemo
//
//  Created by dasdom on 11.09.15.
//  Copyright © 2015 Dominik Hauser. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let slideControl = DHSlideControl(titles: ["1st Option", "2nd Option", "3rd Optioin", "4th Option"])
    slideControl.translatesAutoresizingMaskIntoConstraints = false
    slideControl.addTarget(self, action: "didChange:", forControlEvents: .ValueChanged)
    slideControl.color = UIColor(hue: 0.6, saturation: 0.9, brightness: 0.65, alpha: 1.0)
    slideControl.layer.cornerRadius = 10
    
    view.addSubview(slideControl)
    
    let views = ["slide": slideControl]
    var layoutConstraints = [NSLayoutConstraint]()
    layoutConstraints += NSLayoutConstraint.constraintsWithVisualFormat("|-20-[slide]-20-|", options: [], metrics: nil, views: views)
    layoutConstraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-50-[slide(80)]", options: [], metrics: nil, views: views)
    NSLayoutConstraint.activateConstraints(layoutConstraints)
    
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  func didChange(sender: DHSlideControl) {
    print(sender.selectedIndex)
  }

}

