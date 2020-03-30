//
//  Collection+EventDate.swift
//  TimePoll
//
//  Created by CypherPoet on 3/30/20.
// ✌️
//

import UIKit


extension Collection where Element == EventDate {
 
    var messagePreviewAttributedString: NSAttributedString {
        let datesString = map(\.tableCellDateString).joined(separator: "\n")
        
        let attributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.preferredFont(forTextStyle: .body),
            .foregroundColor: UIColor.systemGray5,
        ]
        
        return NSAttributedString(string: datesString, attributes: attributes)
    }
    
    /// - Create a string from all the dates in the input array
    /// - Calculate the size of the string using the system’s recommended font size.
    /// - Add 20 points on each side so the string doesn’t go edge to edge.
    /// - Draw the final string to an image context
    func messagePreviewImage() -> UIImage? {
        let attributedDateString = messagePreviewAttributedString
        let stringSize = attributedDateString.size()
        let padding: CGFloat = 20.0
        
        let outputSize = CGSize(
            width: stringSize.width + (padding * 2),
            height: stringSize.height + (padding * 2)
        )
        
        let format = UIGraphicsImageRendererFormat()
        format.opaque = true
        format.scale = 3
        
        let renderer = UIGraphicsImageRenderer(size: outputSize, format: format)
        
        return renderer.image { (context) in
            // draw a solid white background
            UIColor.white.set()
            context.fill(CGRect(origin: .zero, size: outputSize))
            
            // now render the text on top
            attributedDateString.draw(at: CGPoint(x: padding, y: padding))
        }
    }
}
