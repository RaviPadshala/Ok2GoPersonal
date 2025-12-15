//
//  UnderLineLable.swift
//  Panchangam
//
//  Created by Mac on 06/02/25.
//

import Foundation
import UIKit

class UnderlinedLabel: UILabel {
    
    override var text: String? {
        didSet {
            guard let text = text else { return }
            let textRange = NSRange(location: 0, length: text.count)
//            let attributedText = NSMutableAttributedString(string: text)
//            attributedText.addAttribute(.underlineStyle,
//                                        value: NSUnderlineStyle.single.rawValue,
//                                        range: textRange)
            
            
            let attributes: [NSAttributedString.Key: Any] = [
                .underlineStyle: NSUnderlineStyle.single.rawValue, // Apply underline
                
                // Set the paragraph style for line spacing
                    .paragraphStyle: {
                        let paragraphStyle = NSMutableParagraphStyle()
                        paragraphStyle.lineSpacing = 10 // Adjust line spacing between lines
                        return paragraphStyle
                    }()
            ]
            
            let attributedString = NSAttributedString(string: text, attributes: attributes)
            
            // Add other attributes if needed
            self.attributedText = attributedString
        }
    }
}
