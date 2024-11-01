//
// CGFloat+Extensions.swift
//
// Created by Enrique Poyato Ortiz.
// Linkedin: https://www.linkedin.com/in/enrique-poyato-ortiz-%EF%A3%BF-7447b32$
// Copyright © 2024 Enrique P. Ortiz. All rights reserved
//

import SwiftUI

extension Double {
    
    static func headerBGOpacity(_ proxy: GeometryProxy, view: any View) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY + view.safeArea.top
        
        return minY > 0 ? 0 : (-minY / 15)
    }
}

