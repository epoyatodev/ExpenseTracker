//
// AppInfoView.swift
//
// Created by Enrique Poyato Ortiz.
// Linkedin: https://www.linkedin.com/in/enrique-poyato-ortiz-%EF%A3%BF-7447b32$
// Copyright © 2024 Enrique P. Ortiz. All rights reserved
//

import SwiftUI

struct AppInfoView: View {
    @AppStorage("showResume") var showResume: Bool = true
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Image(.resumeImageApp)
                .resizable()
                .scaledToFit()
            
            VStack(alignment: .leading, spacing: 25) {
                Text("Un espacio para gestionar tus finanzas")
                    .font(.title)
                    .bold()
                
                Text("Todo lo que necesitas está aquí: cuentas, tarjetas e inversiones en un solo lugar.")
                    .font(.callout)
                
                Text("Ahorra sin complicaciones")
                    .font(.title)
                    .bold()
                
                HStack {
                    PointView(image: "chart.line.uptrend.xyaxis", text: "Gestiona tu sueldo")
                    PointView(image: "bell.and.waves.left.and.right", text: "Alertas y recordatorios")
                }
                
                HStack {
                    PointView(image: "eyes", text: "Analisis Visual")
                    PointView(image: "arrow.trianglehead.clockwise", text: "Seguridad de datos")
                }
                
                
            }
            .padding(.horizontal)
            .frame(maxHeight: .infinity, alignment: .top)
            
            
            Button {
                self.showResume = false
            } label: {
                Text("Comenzar")
                    .bold()
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                    .background(.appTint.gradient, in: .rect(cornerRadius: 12))
                    .contentShape(.rect)
                    .padding()
            }
  
        }
    }
 
}

#Preview {
    AppInfoView()
}
