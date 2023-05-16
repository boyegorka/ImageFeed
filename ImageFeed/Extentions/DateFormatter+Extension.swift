//
//  DateFormatter+Extension.swift
//  ImageFeed
//
//  Created by Егор Свистушкин on 16.05.2023.
//

import Foundation

extension ISO8601DateFormatter {
    
    //static var dateFormat = ISO8601DateFormatter().date(from: (( let dattta: String )-> String) )
    
    func formattedPictureDate(from pictureDate: String) -> Date? {
        return ISO8601DateFormatter().date(from: pictureDate)
    }
    
}
