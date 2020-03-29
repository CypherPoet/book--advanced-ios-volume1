//
//  EventDate.swift
//  TimePoll
//
//  Created by CypherPoet on 3/28/20.
// ✌️
//

import Foundation


struct EventDate {
    let id = UUID()
    
    var date: Date
    var recipientVoteCount: Int = 0
    var hasBeenVotedForByUser: Bool = false
}


extension EventDate: Identifiable {}
extension EventDate: Hashable {}
