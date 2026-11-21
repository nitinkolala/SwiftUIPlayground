//
//  Counter.swift
//  SwiftUI_CodingPractice
//

// The counter's logic, kept separate from the view so it can be unit tested.
struct Counter {
    // Read-only from outside: only the methods below change it.
    private(set) var value = 0

    // Reset is only useful when the value is not already 0.
    var canReset: Bool {
        value != 0
    }

    mutating func increment() {
        value += 1
    }

    mutating func decrement() {
        value -= 1
    }

    mutating func reset() {
        value = 0
    }
}
