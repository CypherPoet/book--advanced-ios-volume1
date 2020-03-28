//
//  Storyboarded.swift
//  TimePoll
//
//  Created by CypherPoet on 3/28/20.
// ✌️
//


#if os(iOS)

import UIKit


public protocol Storyboarded {
    static var storyboardID: String { get }
    
    static func instantiateFromStoryboard(named storyboardName: String) -> Self
}


extension Storyboarded where Self: UIViewController {

    /// The ID used for instantiating the view controller from the storyboard.
    ///
    /// By default, this returns the class name of the controller. This allows
    /// the `instantiateFromStoryboard` function to merely require the name of
    /// the view controller's storyboard and assume that the matching resuse ID has been set there.
    public static var storyboardID: String { String(describing: self) }
    
    
    public static func instantiateFromStoryboard(named storyboardName: String = "Main") -> Self {
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        
        guard
            let viewController = storyboard.instantiateViewController(withIdentifier: Self.storyboardID) as? Self
        else {
            preconditionFailure("Unable to find view controller for storyboard instantiation")
        }

        return viewController
    }
}

#endif
