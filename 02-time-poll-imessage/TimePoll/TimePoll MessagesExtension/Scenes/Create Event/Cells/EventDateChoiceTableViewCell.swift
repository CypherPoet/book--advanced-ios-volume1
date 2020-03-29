//
//  EventDateChoiceTableViewCell.swift
//  TimePoll MessagesExtension
//
//  Created by Brian Sipple on 3/28/20.
//  Copyright © 2020 CypherPoet. All rights reserved.
//

import UIKit

class EventDateChoiceTableViewCell: UITableViewCell {
    
    var eventDate: EventDate!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


private extension EventDateChoiceTableViewCell {
    
    func setupView() {
        
    }
}


extension EventDateChoiceTableViewCell {
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        
        return formatter
    }()
}
