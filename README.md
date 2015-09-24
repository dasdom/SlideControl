# SlideControl
Vertical slide control build with Swift 2.0

![](https://raw.githubusercontent.com/dasdom/SlideControl/master/what.gif)

## How to use

Add DHSlideControl.swift to your project. Use it in your project like this:

```swift
let titles = ["1st Option", "2nd Option", "3rd Option", "4th Option"]
  
let slideControl = DHSlideControl(titles: titles)
slideControl.translatesAutoresizingMaskIntoConstraints = false
slideControl.addTarget(self, action: "didChange:", forControlEvents: .ValueChanged)
slideControl.color = UIColor(hue: 0.6, saturation: 0.9, brightness: 0.65, alpha: 1.0)
slideControl.layer.cornerRadius = 10
```

## Licence

This code is released unter MIT licence. See licence file for details.
