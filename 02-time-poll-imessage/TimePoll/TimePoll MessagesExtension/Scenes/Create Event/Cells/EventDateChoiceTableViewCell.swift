//
//  EventDateChoiceTableViewCell.swift
//  TimePoll MessagesExtension
//
//  Created by Brian Sipple on 3/28/20.
//  Copyright © 2020 CypherPoet. All rights reserved.
//

import UIKit

class EventDateChoiceTableViewCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    
    
    var eventDate: EventDate? {
        didSet {
            guard let eventDate = eventDate else { return }
            DispatchQueue.main.async { self.render(with: eventDate) }
        }
    }
    
    var showsTotalVoteCount: Bool = false
}


// MARK: - Computeds
extension EventDateChoiceTableViewCell {
    static var nib: UINib {
        UINib(nibName: "EventDateChoiceTableViewCell", bundle: nil)
    }
}


// MARK: - Lifecycle
extension EventDateChoiceTableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}


// MARK: - Private Helpers
private extension EventDateChoiceTableViewCell {
    
    func render(with eventDate: EventDate) {
        titleLabel.text = eventDate.tableCellDateString
        
        if showsTotalVoteCount {
            subtitleLabel.text = "Total Votes: \(eventDate.totalVoteCount)"
        } else {
            subtitleLabel.text = ""
        }
        
        accessoryType = (eventDate.hasBeenVotedForByUser || eventDate.hasBeenVotedForByRecipient) ? .checkmark : .none
    }
}

