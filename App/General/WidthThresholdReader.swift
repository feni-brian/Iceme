//
//  WidthThresholdReader.swift
//  Iceme Corner
//
//  Created by Feni Brian on 21/07/2023.
//

import SwiftUI

/**
 A view useful for determining if a child view should act like it is horizontally compressed.
 
 Several elements are used to decide if a view is compressed:
 - Width
 - Dynamic Type size
 - Horizontal size class (on iOS)
 **/
struct WidthThresholdReader<Content: View>: View {
    var widthThreshold: Double = 400
    var dynamicTypeThreshold: DynamicTypeSize = .xxLarge
    @ViewBuilder var content: (WidthThresholdProxy) -> Content
    #if os(iOS)
    @Environment (\.horizontalSizeClass) private var sizeClass
    #endif
    @Environment (\.dynamicTypeSize) private var dynamicType
    
    var body: some View {
        GeometryReader { geometryProxy in
            let compressionProxy = WidthThresholdProxy(width: geometryProxy.size.width, isCompact: isCompact(width: geometryProxy.size.width))
            content(compressionProxy)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
    
    func isCompact(width: Double) -> Bool {
        #if os(iOS)
        if sizeClass == .compact { return true }
        #endif
        if dynamicType >= dynamicTypeThreshold { return true }
        if width < widthThreshold { return true }
        return false
    }
}

struct WidthThresholdReader_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            WidthThresholdReader { proxy in
                Label(title: { Text("Standard") }, icon: { compactIndicator(proxy: proxy) })
            }
            .border(.quaternary)
            
            WidthThresholdReader { proxy in
                Label(title: { Text("200 Wide") }, icon: { compactIndicator(proxy: proxy) })
            }
            .frame(width: 200)
            .border(.quaternary)
            
            WidthThresholdReader { proxy in
                Label(title: { Text("X Large Type") }, icon: { compactIndicator(proxy: proxy) })
            }
            .dynamicTypeSize(.xxxLarge)
            .border(.quaternary)
            
            #if os(iOS)
            WidthThresholdReader { proxy in
                Label(title: { Text("Manually Compact Size Class") }, icon: { compactIndicator(proxy: proxy) })
            }
            .border(.quaternary)
            .environment(\.horizontalSizeClass, .regular)
            #endif
        }
    }
    
    @ViewBuilder
    static func compactIndicator(proxy: WidthThresholdProxy) -> some View {
        if proxy.isCompact {
            Image(systemName: "arrowtriangle.right.and.line.vertical.and.arrowtriangle.left.fill")
                .foregroundStyle(.red)
        } else {
            Image(systemName: "checkmark.circle")
                .foregroundStyle(.secondary)
        }
    }
}

struct WidthThresholdProxy: Equatable {
    var width: Double
    var isCompact: Bool
}
