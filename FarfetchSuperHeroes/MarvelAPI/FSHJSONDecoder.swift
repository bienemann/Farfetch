//
//  FSHJSONDecoder.swift
//  FarfetchSuperHeroes
//
//  Created by Allan Martins on 27/06/18.
//  Copyright © 2018 Allan Martins. All rights reserved.
//

import Foundation

class FSHJSONDecoder: JSONDecoder {
    
    override init() {
        super.init()
        self.dateDecodingStrategy = .custom({ (decoder) -> Date in

            guard let container = try? decoder.singleValueContainer(),
                let text = try? container.decode(String.self) else {
                    throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: decoder.codingPath,
                                                                            debugDescription: "Could not decode date text"))
            }
            
            if let standardFormat = DateFormatter.marvelDate.date(from: text) {
                return standardFormat
            } else if let eventFormat = DateFormatter.marvelEventDate.date(from: text) {
                return eventFormat
            } else {
                throw DecodingError.dataCorruptedError(in: container,
                                                       debugDescription: "Cannot decode date string \(text)")
            }
            
        })
    }
    
}

extension DateFormatter {
    
    static let marvelDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss-SSSS" //1969-12-31T19:00:00-0500
        formatter.calendar = Calendar.current
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        return formatter
    }()
    
    static let marvelEventDate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss" //2008-06-02 00:00:00
        formatter.calendar = Calendar.current
        formatter.timeZone = TimeZone.current
        formatter.locale = Locale.current
        return formatter
    }()
    
}
