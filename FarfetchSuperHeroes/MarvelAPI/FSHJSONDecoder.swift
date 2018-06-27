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
        self.dateDecodingStrategy = .formatted(DateFormatter.marvelDate)
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
}
