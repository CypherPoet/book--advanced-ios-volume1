//
//  MessagesViewController.swift
//  TimePoll MessagesExtension
//
//  Created by Brian Sipple on 3/28/20.
//  Copyright © 2020 CypherPoet. All rights reserved.
//

import UIKit
import Messages


class MessagesViewController: MSMessagesAppViewController {
}


// MARK: - Lifecycle
extension MessagesViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
    

// MARK: - Event Handling
extension MessagesViewController {
    
    @IBAction func createNewEventTapped() {
        requestPresentationStyle(.expanded)
    }
    
}


// MARK: - Conversation Handling
extension MessagesViewController {
    
    override func willBecomeActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the inactive to active state.
        // This will happen when the extension is about to present UI.
        
        // Use this method to configure the extension and restore previously stored state.
        
        print("willBecomeActive")
        // 🔑 If we're becoming active in the expanded state, we'll assume that this is because
        // a user has selected a poll that was sent to them
        guard
            presentationStyle == .expanded,
            let selectedMessage = conversation.selectedMessage
        else { return }

        print("willBecomeActive -- expanded state")

        displayDateSelectionViewController(for: selectedMessage)
    }
    
    override func didResignActive(with conversation: MSConversation) {
        // Called when the extension is about to move from the active to inactive state.
        // This will happen when the user dismisses the extension, changes to a different
        // conversation or quits Messages.
        
        // Use this method to release shared resources, save user data, invalidate timers,
        // and store enough state information to restore your extension to its current state
        // in case it is terminated later.
    }
   
    override func didReceive(_ message: MSMessage, conversation: MSConversation) {
        // Called when a message arrives that was generated by another instance of this
        // extension on a remote device.
        
        // Use this method to trigger UI updates in response to the message.
    }
    
    override func didStartSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user taps the send button.
    }
    
    override func didCancelSending(_ message: MSMessage, conversation: MSConversation) {
        // Called when the user deletes the message without sending it.
    
        // Use this to clean up state related to the deleted message.
    }
    
    
    override func willTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        print("willTransition")

        // Called before the extension transitions to a new presentation style.
        // Use this method to prepare for the change in presentation style.
        
        // Before creating any child view controllers, we need to clear out any
        // that already exist, effectively resetting our main controller before we perform any new operations.
        children.forEach { $0.performRemoval() }
        
        guard let activeConversation = activeConversation else { return }
        
        if presentationStyle == .expanded {
            displayCreateEventViewController(during: activeConversation)
        }
    }
    
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        // Called after the extension transitions to a new presentation style.
    
        // Use this method to finalize any behaviors associated with the change in presentation style.
    }

}


// MARK: - Navigation
extension MessagesViewController {

    private func presentViewController(_ viewController: UIViewController) {
        add(child: viewController)
        
        // Add Auto Layout constraints so the child view continues to fill the full view.
        viewController.view.layout(using: [
            viewController.view.topAnchor.constraint(equalTo: view.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            viewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            viewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
    
    
    func displayCreateEventViewController(during conversation: MSConversation) {
        let createEventVC = CreateEventViewController.instantiate(
            dateChoices: [],
            delegate: self
        )
        
        presentViewController(createEventVC)
    }
    
    
    func displayDateSelectionViewController(for selectedMessage: MSMessage) {
        guard
            let messageURL = selectedMessage.url,
            let dateChoices = EventDate.datesFromMessageURL(messageURL)
        else { return }
        
        
        let viewController = DateSelectionViewController.instantiate(
            dateChoices: dateChoices,
            delegate: self
        )

        presentViewController(viewController)
    }
}


// MARK: - CreateEventViewControllerDelegate
extension MessagesViewController: CreateEventViewControllerDelegate {

    func viewController(_ controller: UIViewController, didCreateMessageWith eventDates: [EventDate]) {
        requestPresentationStyle(.compact)
        
        guard
            let activeConversation = activeConversation,
            let messageURL = EventDate.messagesURL(from: eventDates)
        else { return }
        
        let messageSession = activeConversation.selectedMessage?.session ?? MSSession()
        let message = MSMessage(session: messageSession)
        
        let messageLayout = MSMessageTemplateLayout()
        messageLayout.caption = "I voted."
        
        
        message.url = messageURL
        message.layout = messageLayout
        
        
        activeConversation.insert(message) { error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
}


// MARK: - DateSelectionViewControllerDelegate
//extension MessagesViewController: DateSelectionViewControllerDelegate {
//
//    func viewController(_ controller: DateSelectionViewController, didSelect eventDate: EventDate) {
//
//    }
//}
//
