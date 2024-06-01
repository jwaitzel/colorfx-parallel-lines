//
//  ParallelLinesShader.swift
//  VaquitaPayAsGroupOrder
//
//  Created by javi www on 5/30/24.
//

import SwiftUI

extension View {
    func parallelLinesShader(_ color: Color,_ width: Float, _ height: Float, _ lineMult: Float = 18.0, _ offsetX: Float = 0, _ offsetY: Float = 0, _ rot: Float = 0, _ edge: Float = 0, _ idx: Int = 0, _ animF: Float) -> some View {
        modifier(
            ParallelLinesShader(
                color: color,
                width: width,
                height: height,
                lineMult: lineMult,
                offX: offsetX,
                offY: offsetY,
                rot: rot,
                edge: edge,
                idx: idx,
                animF: animF)
        )
    }
}

struct ParallelLinesShader: ViewModifier {
    var color: Color
    var width: Float
    var height: Float
    var lineMult: Float
    var offX: Float
    var offY: Float
    var rot: Float
    var edge: Float
    var idx: Int
    var animF: Float
    
    private let startDate = Date()
    // For global animation time
    static var startDateAll = Date()

    func body(content: Content) -> some View {
        TimelineView(.animation) { _ in
            if #available(iOS 17.0, *) {
                content.visualEffect { content, proxy in
                    content
                        .colorEffect(ShaderLibrary.parallelLines(
                            .float2(proxy.size.width, proxy.size.height),
                            .color(color),
                            .float(Self.startDateAll.timeIntervalSinceNow),
                            .float(lineMult),
                            .float2(offX, offY),
                            .float(rot),
                            .float(edge),
                            .float(Float(idx)),
                            .float(animF)
                        ))
                }
            } else {
                // Fallback on earlier versions
                content
                    .overlay {
                        Rectangle()
                            .foregroundStyle(.black)
                    }
            }
        }
    }
}

struct PLLPreview: View {
    
    @State private var lineMult: Float = 2.0
    @State private var xOffset: Float = 0.0
    @State private var yOffset: Float = 0.0
    @State private var rotVal: Float = -0.6
    @State private var edgeVal: Float = 0.6

    @State private var opt: Bool = true
    
    var body: some View {
        ZStack {
            VStack(spacing: 8) {
                let rowCount = 4
                ForEach(0..<rowCount, id: \.self) { jidx in
                    HStack(spacing: 8) {
                        ForEach(0..<4, id: \.self) { idx in
                            let rowInt = (jidx * rowCount + idx)
                            Rectangle()
                                .fill(Color.blue)
                                .frame(width: 30, height: 100)
                                .parallelLinesShader(
                                    Color(uiColor: .systemBlue).opacity(1.0),
                                    30,
                                    100,
                                    lineMult + Float(idx) * 1.6,
                                    -xOffset,
                                    -yOffset,
                                    rotVal + Float(jidx) * .pi * -0.22,
                                    edgeVal,
                                    1,
                                    0.3
                                )
                                .overlay {
//                                    Text("\(rowInt)")
                                }
                                .scaleEffect(1.0)
                                .border(.black.opacity(0.1))
                                .shadow(color:.black.opacity(0.2), radius: 0.0)
                        }
                    }
                }
            }
        }
        .onTapGesture {
            opt.toggle()
        }
        .sheet(isPresented: $opt, content: {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    VStack { Text("total lines \(String(format:"%.2f", lineMult))"); Slider(value: $lineMult, in: 1...100) }
                    VStack { Text("x off \(String(format:"%.2f", xOffset))"); Slider(value: $xOffset, in: -0.995...0.995) }
                    VStack { Text("y off \(String(format:"%.2f", yOffset))"); Slider(value: $yOffset, in: -0.995...0.995) }
                    VStack { Text("rot \(String(format:"%.2f",  Angle(radians: Double(rotVal)).degrees))"); Slider(value: $rotVal, in: -Float.pi...Float.pi) }
                    VStack { Text("edge \(String(format:"%.2f", edgeVal))"); Slider(value: $edgeVal, in: 0.1...30) }
                }
                .tint(.primary.opacity(0.2))
                .fontWeight(.bold)
                .frame(maxHeight: .infinity, alignment: .top)
                .padding(.horizontal, 16)
                .padding(.top, 32)
            }
            .presentationDetents([.height(220), .height(100)])
            .presentationBackgroundInteraction(.enabled)
            .presentationBackground {
                Rectangle()
                    .foregroundStyle(.ultraThinMaterial)
            }
        })

    }

}

#Preview {
    PLLPreview()
}
