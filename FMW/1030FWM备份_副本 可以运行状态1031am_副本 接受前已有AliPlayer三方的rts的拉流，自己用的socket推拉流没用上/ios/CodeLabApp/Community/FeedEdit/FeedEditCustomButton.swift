//
//  FeedEditDraftButton.swift
//  Genz
//
//  Created by Sera on 2021/5/22.
//

import Foundation
import UIKit

final class FeedEditLocationButton: UIButton {
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        let imageRect = self.imageRect(forContentRect: contentRect)
        return CGRect(x: imageRect.maxX + 5, y: 0, width: contentRect.width - imageRect.maxX - 5 - 100, height: contentRect.height)
    }
    
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        return CGRect(x: 20, y: contentRect.height/2.0 - 24/2.0, width: 24, height: 24)
    }
}
