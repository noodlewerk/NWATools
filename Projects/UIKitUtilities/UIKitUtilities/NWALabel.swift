//
//  NWALabel.swift
//  UIKitUtilities
//
//  Created by Bruno Scheele on 29/10/15.
//  Copyright © 2015 Noodlewerk Apps. All rights reserved.
//

import Foundation
import UIKit

class NWALabel: UILabel {
    override func drawTextInRect(rect: CGRect)
    {
        var newRect = rect
        let size = sizeThatFits(rect.size)
        
        if contentMode == .Top {
            newRect.size.height = min(rect.size.height, size.height)
        }
        else if contentMode == .Bottom {
            newRect.origin.y = max(0, rect.size.height - size.height)
            newRect.size.height = min(rect.size.height, size.height)
        }
        super.drawTextInRect(newRect)
    }
}
