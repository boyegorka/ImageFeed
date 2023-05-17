//
//  String+Extension.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 16.05.2023.
//

import Foundation

extension String {
    
    private static let formatterDate = ISO8601DateFormatter()
    
    func dateFromISO8601() -> Date? {
        return Self.formatterDate.date(from: self)
    }
}
