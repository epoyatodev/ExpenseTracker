//
// CustomNumberPad.swift
//
// Created by Enrique Poyato Ortiz.
// Linkedin: https://www.linkedin.com/in/enrique-poyato-ortiz-%EF%A3%BF-7447b32$
// Copyright © 2024 Enrique P. Ortiz. All rights reserved
//

import SwiftUI

struct CustomNumberPad: View {
    @State private var animateField: Bool = false
    @Binding var pin: String
    @Binding var isUnlocked: Bool
    @Binding var noBiometricAccess: Bool
    var lockType: LoockType
    var lockPin: String
    var forgotPin: () -> Void
    var isBiometricAvailable: Bool
    var body: some View {
        VStack(spacing: 15) {
            Text("Introduce un Codigo de desbloqueo")
                .font(.title)
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    if lockType == .both && noBiometricAccess {
                        Button {
                            pin = ""
                            self.noBiometricAccess = false
                        } label: {
                            Image(systemName: "arrow.left")
                                .font(.title)
                                .contentShape(.rect)
                        }
                        .tint(.white)
                        .padding(.leading)
                    }
                }
            
            HStack(spacing: 10) {
                ForEach(0..<4, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .frame(width: 50, height: 55)
                        .overlay {
                            if pin.count > index {
                                let index = pin.index(pin.startIndex, offsetBy: index)
                                let string = String(pin[index])
                                
                                Text(string)
                                    .foregroundStyle(.black)
                                    .font(.title)
                            }
                        }
                }
            }
            .keyframeAnimator(initialValue: CGFloat.zero, trigger: animateField, content: { content, value in
                content
                    .offset(x: value)
            }, keyframes: { value in
                KeyframeTrack {
                    CubicKeyframe(30, duration: 0.07)
                    CubicKeyframe(-30, duration: 0.07)
                    CubicKeyframe(20, duration: 0.07)
                    CubicKeyframe(-20, duration: 0.07)
                    CubicKeyframe(0, duration: 0.07)

                }
            })
            .padding(.top, 15)
            .overlay(alignment: .bottomTrailing) {
                Button("He olvidado el pin") {
                    forgotPin()
                }
                .foregroundStyle(.white)
                .font(.callout)
                .offset(y: 40)
            }
            .vSpacing()
            
            GeometryReader { _ in
                LazyVGrid(columns: Array(repeating: .init(), count: 3)) {
                    ForEach(1...9, id: \.self) { number in
                        Button {
                            if pin.count < 4 {
                                pin.append("\(number)")
                            }
                        } label: {
                            Text(number.formatted())
                                .font(.title)
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 20)
                                .contentShape(.rect)
                        }
                        .tint(.white)
                    }
                    Button {
                        if !pin.isEmpty {
                            pin.removeLast()
                        }
                    } label: {
                        Image(systemName: "delete.backward")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .contentShape(.rect)
                    }
                    .tint(.white)
                    
                    Button {
                        if pin.count < 4 {
                            pin.append("0")
                        }
                    } label: {
                        Text("0")
                            .font(.title)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 20)
                            .contentShape(.rect)
                    }
                    .tint(.white)
                }
                .vSpacing(.bottom)
            }
            .onChange(of: pin) { oldValue, newValue in
                if newValue.count == 4 {
                    if lockPin == pin {
                        withAnimation(.snappy, completionCriteria: .logicallyComplete) {
                            self.isUnlocked = true

                        } completion: {
                            pin = ""
                            noBiometricAccess = !isBiometricAvailable
                        }
                    } else {
                        pin = ""
                        animateField.toggle()
                    }
                }
            }
        }
        .padding()
    }
}

#Preview {
    CustomNumberPad(pin: .constant("1234"), isUnlocked: .constant(false), noBiometricAccess: .constant(false), lockType: .both , lockPin: "1234", forgotPin: {}, isBiometricAvailable: false)
}
