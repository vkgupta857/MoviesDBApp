//
//  Extensions.swift
//  MoviesDBApp
//
//  Created by Vinod Gupta on 01/06/24.
//

import Foundation

extension Date {
    func getYear() -> Int? {
        return Calendar.current.dateComponents(Set([.year]), from: self).year
    }
}

extension String {
    func getDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD"
        return formatter.date(from: self)
    }
}
