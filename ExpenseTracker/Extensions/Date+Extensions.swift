//
// Date+Extensions.swift
//
// Created by Enrique Poyato Ortiz.
// Linkedin: https://www.linkedin.com/in/enrique-poyato-ortiz-%EF%A3%BF-7447b3200/
// Copyright © 2024 Enrique P. Ortiz. All rights reserved
//

import SwiftUI

extension Date {
    var startOnMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        
        return calendar.date(from: components) ?? self
    }
    
    var endOnMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        
        return calendar.date(byAdding: .init(month: 1, minute: -1) , to: startOnMonth) ?? self
    }
}
