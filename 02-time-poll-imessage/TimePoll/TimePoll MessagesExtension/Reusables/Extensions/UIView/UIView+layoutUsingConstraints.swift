//
//  UIView+layoutUsingConstraints.swift
//  TimePoll
//
//  Created by CypherPoet on 3/28/20.
// ✌️
//


#if os(iOS)

import UIKit


extension UIView {
    
    func layout(using constraints: [NSLayoutConstraint]) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(constraints)
    }
}

#endif

