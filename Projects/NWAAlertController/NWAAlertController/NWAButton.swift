//
//  NWAButton.swift
//  Pods
//
//  Created by Bruno Scheele on 15/07/15.
//
//

import UIKit
import CoreGraphics

@IBDesignable class NWAButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable var normalBackgroundColor: UIColor? {
        didSet {
            setBackgroundColor(normalBackgroundColor, forState: .Normal)
        }
    }
    
    @IBInspectable var selectedBackgroundColor: UIColor? {
        didSet {
            setBackgroundColor(selectedBackgroundColor, forState: .Selected)
        }
    }
    
    @IBInspectable var highlightedBackgroundColor: UIColor? {
        didSet {
            setBackgroundColor(highlightedBackgroundColor, forState: .Highlighted)
        }
    }
    
    @IBInspectable var disabledBackgroundColor: UIColor? {
        didSet {
            setBackgroundColor(disabledBackgroundColor, forState: .Disabled)
        }
    }
    
    private func setBackgroundColor(color: UIColor?, forState state: UIControlState)
    {
        if let color = color {
            let colorImage = UIImage.imageWithColor(color)
            setBackgroundImage(colorImage, forState: state)
        }
        else {
            setBackgroundImage(nil, forState: state)
        }
    }
}

public extension UIImage
{
    public class func imageWithColor(color: UIColor) -> UIImage
    {
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(size, false, UIScreen.mainScreen().scale)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
