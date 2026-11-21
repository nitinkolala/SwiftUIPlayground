//
//  ContentView.swift
//  SwiftUI_CodingPractice
//
//  Created by Nitin on 21/11/26.
//

import SwiftUI

// A View is a struct that describes what the screen should look like.
// SwiftUI calls `body` to build it, and calls it again whenever the data it depends on changes.
struct ContentView: View {

    // @State lets this view own a small piece of data.
    // - `counter` holds the logic and the value shown on screen (see Counter.swift).
    // - When `counter` changes, SwiftUI re-runs `body` and updates the UI.
    // - `private` is the convention: only this view should touch its own state.
    @State private var counter = Counter()

    // `some View` means (opaque type) "returns one specific View type, chosen by the compiler." It avoids writing the long nested type and has no runtime cost.
    // `any View` (existential) is slower because it boxes the view at runtime.
    var body: some View {
        VStack(spacing: 20) {

            // Reads `counter.value` directly, so it always shows the latest value.
            Text("Count: \(counter.value)")
                .font(.largeTitle)

            VStack{
                Button("+"){
                    counter.increment()
                }
                Button("-"){
                    counter.decrement()
                }
            }
            .buttonStyle(.borderedProminent)

            // Disabled when there is nothing to reset.
            Button("Reset"){
                counter.reset()
            }
            .disabled(!counter.canReset)

        }
        .padding()
    }
}

#Preview {
    ContentView()
}
