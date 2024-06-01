//
//  ContentView.swift
//  UsingColorEffectView
//
//  Created by javi www on 6/1/24.
//

import SwiftUI

struct ContentView: View {
    
    @State private var animStart: Date = .now
    
    var body: some View {
        HStack {
            ForEach(0..<6, id: \.self) { idx in
                TimelineView(.animation) { _ in
                    Rectangle()
                        .frame(width: 40, height: 100)
                        .colorEffect(ShaderLibrary.parallelLines(
                            .float2(40, 100),
                            .color(Color.green),
                            .float(animStart.timeIntervalSinceNow),
                            .float(6 - Float(idx) * 0.8),
                            .float2(0, 0),
                            .float(Float.pi * 0.25 + Float(idx) * 0.24),
                            .float(12),
                            .float(1),
                            .float(0.15 + Float(idx) * 0.0124)
                        ))
                        .shadow(color: .black, radius: 1.1, x: 0, y: 0)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
