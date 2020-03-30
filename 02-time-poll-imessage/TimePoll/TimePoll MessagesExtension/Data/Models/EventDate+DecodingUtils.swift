//
//  EventDate+DecodingUtils.swift
//  TimePoll
//
//  Created by CypherPoet on 3/30/20.
// ✌️
//

import Foundation


extension EventDate {
    
    enum QueryItemKey {
        static let uuidString = "uuidString"
    }
    
    enum QueryItemKeyPrefix {
        static let date = "date-"
        static let totalVoteCount = "totalVoteCount-"
    }
    
    
    static var queryItemCount = 3
    
    
    var urlQueryItems: [URLQueryItem] {
        [
            .init(name: QueryItemKey.uuidString, value: id.uuidString),
            .init(
                name: "\(QueryItemKeyPrefix.date)-\(id)",
                value: Self.queryItemDateFormatter.string(from: date)
            ),
            .init(
                name: "\(QueryItemKeyPrefix.totalVoteCount)-\(id)",
                value: String(totalVoteCount)
            ),
        ]
    }
    
    
    static func messagesURL(from eventDates: [EventDate]) -> URL? {
        var components = URLComponents()
        
        components.queryItems = eventDates.flatMap(\.urlQueryItems)
        
        return components.url
    }

    
    
    static func datesFromMessageURL(_ url: URL) -> [EventDate]? {
        guard
            let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false),
            var queryItems = urlComponents.queryItems
        else { return nil }
        
        var eventDates: [EventDate] = []
        var dataGroup = Array(queryItems.prefix(queryItemCount))
        
        while
            dataGroup.count == queryItemCount
        {
            if let eventDate = EventDate(dataGroup) {
                eventDates.append(eventDate)
            }
            
            queryItems.removeFirst(queryItemCount)
            dataGroup = Array(queryItems.prefix(queryItemCount))
        }

        return eventDates
    }
}
