//
// SettignsView.swift
//
// Created by Enrique Poyato Ortiz.
// Linkedin: https://www.linkedin.com/in/enrique-poyato-ortiz-%EF%A3%BF-7447b32$
// Copyright © 2024 Enrique P. Ortiz. All rights reserved
//

import SwiftUI

struct SettignsView: View {
    @AppStorage("username") private var username: String = ""
    @AppStorage("isAppLockEnabled") private var isAppLockEnabled: Bool = false
    @AppStorage("isAppLockBackground") private var isAppLockBackground: Bool = false
    var body: some View {
        NavigationStack {
            List {
                Section("Usuario") {
                    TextField("Usuario", text: $username)
                }
                
//                Section("Seguridad") {
//                    Toggle("Habilitar bloqueo de la App", isOn: $isAppLockEnabled)
//                    
//                    if isAppLockEnabled {
//                        Toggle("Bloquear la App cuando esté en segundo plano", isOn: $isAppLockBackground)
//
//                    }
//                }
            }
            .navigationTitle("Ajustes")
//            .onChange(of: isAppLockEnabled) { oldValue, newValue in
//                if !newValue {
//                    self.isAppLockBackground = false
//                }
//            }
        }
    }
}

#Preview {
    SettignsView()
}
