//
//  EventDate.swift
//  TimePoll
//
//  Created by CypherPoet on 3/28/20.
// ✌️
//

import Foundation
import Clamping

struct EventDate {
    var id = UUID()
    
    var date: Date
    
    @Clamping(range: 0...Int.max)
    var totalVoteCount: Int = 0
    
    /// Used to track whether or not a date has been voted for while an event is
    /// being created.
    var hasBeenVotedForByUser: Bool = false
    
    /// Used to track whether or not a date has been voted for while an event is
    /// being viewed and edited by a recipient.
    var hasBeenVotedForByRecipient: Bool = false
    
    init(
        id: UUID = UUID(),
        date: Date,
        totalVoteCount: Int = 0,
        hasBeenVotedForByUser: Bool = false,
        hasBeenVotedForByRecipient: Bool = false
    ) {
        self.id = id
        self.date = date
        self.totalVoteCount = totalVoteCount
        self.hasBeenVotedForByUser = hasBeenVotedForByUser
        self.hasBeenVotedForByRecipient = hasBeenVotedForByRecipient
    }
}


extension EventDate {
    init?(_ urlQueryItems: [URLQueryItem]) {
        guard
            urlQueryItems.count == Self.queryItemCount,
            urlQueryItems[0].name == QueryItemKey.uuidString,
            let id = UUID(uuidString: urlQueryItems[0].value ?? ""),
            urlQueryItems[1].name.hasPrefix(QueryItemKeyPrefix.date),
            let date = Self.queryItemDateFormatter.date(from: urlQueryItems[1].value ?? ""),
            urlQueryItems[2].name.hasPrefix(QueryItemKeyPrefix.totalVoteCount),
            let totalVoteCount = Int(urlQueryItems[2].value ?? "")
        else { return nil }
        
        self.id = id
        self.date = date
        self.totalVoteCount = totalVoteCount
    }

}


extension EventDate: Identifiable {}


// MARK: - Hashable
extension EventDate: Hashable {
    static func == (lhs: EventDate, rhs: EventDate) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


// MARK: - Formatting
extension EventDate {
    
    static let queryItemDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        
        return formatter
    }()
}
