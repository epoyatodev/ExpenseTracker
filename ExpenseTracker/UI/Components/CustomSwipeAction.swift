//
// CustomSwipeAction.swift
//
// Created by Enrique Poyato Ortiz.
// Linkedin: https://www.linkedin.com/in/enrique-poyato-ortiz-%EF%A3%BF-7447b32$
// Copyright © 2024 Enrique P. Ortiz. All rights reserved
//

import SwiftUI

struct CustomSwipeAction<Content: View>: View {
    var cornerRadius: CGFloat = 0
    var direction: SwipeDirection = .trailing
    @ViewBuilder var content: Content
    @Environment(\.colorScheme) var sheme
    @ActionBuilder var actions: [Action]
    let viewID = UUID()
    @State private var isEnabled: Bool = true
    @State private var scrollOfset: CGFloat = .zero
    var resetPosition: () -> Void = {}
    var body: some View {
        ScrollViewReader { reader in
            ScrollView(.horizontal) {
                LazyHStack(spacing: 0) {
                    content
                        .rotationEffect(.init(degrees: direction == .leading ? -180 : 0))
                        .containerRelativeFrame(.horizontal)
                        .background(sheme == .dark ? .black : .white)
                        .background {
                            if let firstAction = actions.first {
                                Rectangle()
                                    .fill(firstAction.tint)
                                    .opacity(scrollOfset == 0 ? 0 : 1)
                            }
                        }
                        .id(viewID)
                        .transition(.identity)
                        .overlay {
                            GeometryReader {
                                let minX = $0.frame(in: .scrollView(axis: .horizontal)).minX
                                Color.clear
                                    .preference(key: OffsetKey.self, value: minX)
                                    .onPreferenceChange(OffsetKey.self) {
                                        scrollOfset = $0
                                    }
                            }
                        }
                    
                    ActionButtons {
                        withAnimation(.snappy){
                            reader.scrollTo(viewID, anchor: direction == .trailing ? .topLeading : .topTrailing)
                        }
                    }
                    .opacity(scrollOfset == 0 ? 0 : 1)
                    
                }
                .scrollTargetLayout()
                .visualEffect { content, geometryProxy in
                    content
                        .offset(x: scrollOffset(geometryProxy))
                }
            }
            .scrollIndicators(.hidden)
            .scrollTargetBehavior(.viewAligned)
            .background {
                if let lastAction = actions.last {
                    Rectangle()
                        .fill(lastAction.tint)
                        .opacity(scrollOfset == 0 ? 0 : 1)
                }
            }
            .clipShape(.rect(cornerRadius: cornerRadius))
            .rotationEffect(.init(degrees: direction == .leading ? 180 : 0))
            .onReceive(NotificationCenter.default.publisher(for: .init("hola"), object: nil)) { _ in
                withAnimation(.snappy){
                    reader.scrollTo(viewID, anchor: direction == .trailing ? .topLeading : .topTrailing)
                }
            }
        }
        .allowsHitTesting(isEnabled)
    }
    
    @ViewBuilder
    func ActionButtons(resetPosition: @escaping () -> Void) -> some View {
        Rectangle()
            .fill(.clear)
            .frame(width: CGFloat(actions.count) * 100)
            .overlay(alignment: direction.alignment) {
                HStack(spacing: 0) {
                    ForEach(actions) { action in
                        Button {
                            Task {
                                isEnabled = false
                                resetPosition()
                                try? await Task.sleep(for: .seconds(0.25))
                                action.action()
                                try? await Task.sleep(for: .seconds(0.1))
                                isEnabled = true
                            }
                        } label: {
                            Image(systemName: action.icon)
                                .font(action.iconFont)
                                .foregroundStyle(action.iconTint)
                                .frame(width: 100)
                                .frame(maxHeight: .infinity)
                                .contentShape(.rect)
                        }
                        .buttonStyle(.plain)
                        .background(action.tint)
                        .rotationEffect(.init(degrees: direction == .leading ? -180 : 0))
                        .disabled(!action.isEnabled)
                    }
                }
            }
    }
    
    nonisolated func scrollOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minX = proxy.frame(in: .scrollView(axis: .horizontal)).minX
        
        return (minX > 0 ? -minX : 0)
    }
}

struct OffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = .zero
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

enum SwipeDirection {
    case leading
    case trailing
    
    var alignment: Alignment {
        switch self {
        case .leading: return .leading
        case .trailing: return .trailing
        }
    }
}

struct Action: Identifiable {
    private(set) var id: UUID = .init()
    var tint: Color
    var icon: String
    var iconFont: Font = .title
    var iconTint: Color = .white
    var isEnabled: Bool = true
    var action: () -> Void
}

@resultBuilder
struct ActionBuilder {
    static func buildBlock(_ components: Action...) -> [Action] {
        return components
    }
}

#Preview {
    CustomSwipeAction(cornerRadius: 15, direction: .trailing) {
        RoundedRectangle(cornerRadius: 10)
            .fill(Color.green.gradient)
            .frame(height: 90)
    } actions: {
        Action(tint: .red, icon: "trash.fill") {
            
        }
    }
    .frame(height: 90)
    .padding()
}
