//
// LockView.swift
//
// Created by Enrique Poyato Ortiz.
// Linkedin: https://www.linkedin.com/in/enrique-poyato-ortiz-%EF%A3%BF-7447b32$
// Copyright © 2024 Enrique P. Ortiz. All rights reserved
//

import SwiftUI
import LocalAuthentication

struct LockView<Content: View>: View {
    @State private var isUnlocked: Bool = false
    @State private var noBiometricAccess: Bool = false
    @State private var pin: String = ""

    var lockType: LoockType = .biometric
    var lockPin: String
    var isEnabled: Bool
    var lockWhenAppGoesToBackground: Bool = true
    @ViewBuilder var content: Content
    let context = LAContext()
    @Environment(\.scenePhase) var phase
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            content
                .frame(width: size.width, height: size.height)
            
            if isEnabled && !isUnlocked {
                ZStack {
                    Rectangle()
                        .ignoresSafeArea()
                    
                    if (lockType == .both && !noBiometricAccess) || lockType == .biometric {
                        Group {
                            if noBiometricAccess {
                                Text("Habilita Face ID en los ajustes para desbloquear la app")
                                    .font(.callout)
                                    .multilineTextAlignment(.center)
                                    .padding(50)
                                    .foregroundStyle(.white)
                            } else {
                                VStack(spacing: 12) {
                                    VStack(spacing: 6) {
                                        Image(systemName: "faceid")
                                            .font(.largeTitle)
                                        Text("Toca para desbloquear")
                                            .font(.caption2)
                                            .foregroundStyle(.primary.secondary)
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(width: 100, height: 100)
                                    .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                                    .contentShape(.rect)
                                    .onTapGesture {
                                        unlockView()
                                    }
                                    
                                    if lockType == .both {
                                        Text("Código")
                                            .frame(width: 100, height: 40)
                                            .background(.ultraThinMaterial, in: .rect(cornerRadius: 10))
                                            .contentShape(.rect)
                                            .onTapGesture {
                                                noBiometricAccess = true
                                            }
                                    }
                                }
                            }
                        }
                    } else {
                        CustomNumberPad(pin: $pin, isUnlocked: $isUnlocked, noBiometricAccess: $noBiometricAccess, lockType: lockType, lockPin: lockPin, forgotPin: {}, isBiometricAvailable: isBiometricAvailable)
                    }
                        
                }
                .transition(.offset(y: size.height + 100))
            }
        }
        .onChange(of: isEnabled, initial: true) { oldValue, newValue in
            if newValue {
                unlockView()
            }
        }
        .onChange(of: phase) { oldValue, newValue in
            if newValue != .active && lockWhenAppGoesToBackground {
                isUnlocked = false
                pin = ""
            }
        }
    }
    private func unlockView() {
        Task {
            if isBiometricAvailable && lockType != .number {
                if let result = try? await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Desbloquear app"), result {
                    withAnimation(.snappy, completionCriteria: .logicallyComplete) {
                        self.isUnlocked = true
                    } completion: {
                        pin = ""
                    }
                }
            }
            noBiometricAccess = !isBiometricAvailable
        }
    }
    
    private var isBiometricAvailable: Bool {
        return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
    }
}

enum LoockType: String {
    case biometric = "Biometric"
    case number = "Number"
    case both = "Both"
}
