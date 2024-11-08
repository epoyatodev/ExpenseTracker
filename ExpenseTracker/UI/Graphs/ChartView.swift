//
// ChartView.swift
//
// Created by Enrique Poyato Ortiz.
// Linkedin: https://www.linkedin.com/in/enrique-poyato-ortiz-%EF%A3%BF-7447b32$
// Copyright © 2024 Enrique P. Ortiz. All rights reserved
//

import SwiftUI
import Charts

struct ChartView: View {
    var chartGroups: [ChartGroup]
    var body: some View {
        Chart {
            ForEach(chartGroups) { chartGroup in
                ForEach(chartGroup.categories) { chart in
                    BarMark(x: .value("Mes", format(date: chartGroup.date, format: "MMM yy")),
                            y: .value(chart.category.rawValue, chart.totalValue), width: 20)
                    .position(by: .value("Categoría", chart.category.rawValue), axis: .horizontal)
                    .foregroundStyle(by: .value("Categoría", chart.category.rawValue))
                }
            }
        }
        .chartScrollableAxes(.horizontal)
        .chartXVisibleDomain(length: 4)
        .chartLegend(position: .bottom, alignment: .trailing)
        .chartYAxis {
            AxisMarks(position: .leading) { value in
                let doubleValue = value.as(Double.self) ?? 0
                AxisGridLine()
                AxisTick()
                AxisValueLabel {
                    Text(axisLabel(doubleValue))
                }
            }
        }
        .chartForegroundStyleScale(range: [Color.green.gradient, Color.red.gradient, Color.blue.gradient])
    }
    
    func axisLabel(_ value: Double) -> String {
        let intValue = Int(value)
        let kValue = intValue / 1000
        return intValue < 1000 ? "\(intValue)" : "\(kValue)k"
    }
}

#Preview {
    ChartView(chartGroups: [])
}
