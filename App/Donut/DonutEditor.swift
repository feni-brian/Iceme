//
//  DonutEditor.swift
//  Iceme Corner
//
//  Created by Feni Brian on 22/07/2023.
//

import SwiftUI
import FoodTruckKit

struct DonutEditor: View {
    @Binding var donut: Donut
    
    var body: some View {
        ZStack {
            #if os(macOS)
            HSplitView {
                donutViewer
                    .layoutPriority(1)
                Form {
                    editorContent
                }
                .formStyle(.grouped)
                .padding()
                .frame(minWidth: 300, idealWidth: 350, maxHeight: .infinity, alignment: .top)
            }
            #else
            WidthThresholdReader { proxy in
                if proxy.isCompact {
                    Form {
                        donutViewer
                        editorContent
                    }
                } else {
                    HStack(spacing: 0) {
                        donutViewer
                        Divider().ignoresSafeArea()
                        Form { editorContent }
                            .formStyle(.grouped)
                            .frame(width: 350)
                    }
                }
            }
            #endif
        }
        .toolbar {
            ToolbarTitleMenu {
                Button {
                    
                } label: {
                    Label("My Action", systemImage: "star")
                }
            }
        }
        .navigationTitle(donut.name)
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        .toolbarRole(.editor)
        // We wish not to store messages that interrupt any donut editing, would we...
        .storeMessagesDeferred(true)
        #endif
    }
    
    var donutViewer: some View {
        DonutView(donut: donut)
    }
    
    @ViewBuilder
    var editorContent: some View {
        
        Section("Donut") {
            TextField("Name", text: $donut.name, prompt: Text("Donut Name"))
        }
        
        Section("Flavour Profile") {
            Grid {
                let (topFlavour, topFlavourValue) = donut.flavors.mostPotent
                ForEach(Flavor.allCases) { flavour in
                    let isTopFlavour = topFlavour == flavour
                    let flavourValue = max(donut.flavors[flavour], 0)
                    Grid {
                        flavour.image
                            .foregroundStyle(isTopFlavour ? .primary : .secondary)
                        Text(flavour.name)
                            .gridCellAnchor(.leading)
                            .foregroundStyle(isTopFlavour ? .primary : .secondary)
                        Gauge(value: Double(flavourValue), in: 0...Double(topFlavourValue)) { EmptyView() }
                            .tint(isTopFlavour ? Color.accentColor : Color.secondary)
                            .labelsHidden()
                        Text(flavourValue.formatted())
                            .gridCellAnchor(.trailing)
                            .foregroundStyle(isTopFlavour ? .primary : .secondary)
                    }
                }
            }
        }
        
        Section("Ingredients") {
            Picker("Dough", selection: $donut.dough) {
                ForEach(Donut.Dough.all) { dough in
                    Text(dough.name)
                        .tag(dough)
                }
            }
            Picker("Glaze", selection: $donut.glaze) {
                Section {
                    Text("None")
                        .tag(nil as Donut.Glaze?)
                }
                ForEach(Donut.Glaze.all) { glaze in
                    Text(glaze.name)
                        .tag(glaze as Donut.Glaze?)
                }
            }
            Picker("Topping", selection: $donut.topping) {
                Section {
                    Text("None")
                        .tag(nil as Donut.Topping?)
                }
                Section {
                    ForEach(Donut.Topping.other) { topping in
                        Text(topping.name)
                            .tag(topping as Donut.Topping?)
                    }
                }
                Section {
                    ForEach(Donut.Topping.lattices) { topping in
                        Text(topping.name)
                            .tag(topping as Donut.Topping?)
                    }
                }
                Section {
                    ForEach(Donut.Topping.lines) { topping in
                        Text(topping.name)
                            .tag(topping as Donut.Topping?)
                    }
                }
                Section {
                    ForEach(Donut.Topping.drizzles) { topping in
                        Text(topping.name)
                            .tag(topping as Donut.Topping?)
                    }
                }
            }
        }
    }
}

struct DonutEditor_Previews: PreviewProvider {
    struct Preview: View {
        @State var donut = Donut.preview
        var body: some View {
            DonutEditor(donut: $donut)
        }
    }
    
    static var previews: some View {
        NavigationStack {
            Preview()
        }
    }
}
