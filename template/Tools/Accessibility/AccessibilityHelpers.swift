//
//  AccessibilityHelpers.swift
//  template
//
//  Created by iOS Advanced Setup Script
//

import SwiftUI

/// Extension to add accessibility helpers to SwiftUI views
extension View {
    
    /// Add accessibility identifier and label
    func accessibility(identifier: String, label: String? = nil, hint: String? = nil) -> some View {
        self
            .accessibilityIdentifier(identifier)
            .accessibilityLabel(label ?? "")
            .accessibilityHint(hint ?? "")
    }
    
    /// Add accessibility for buttons
    func accessibilityButton(identifier: String, label: String, hint: String? = nil) -> some View {
        self
            .accessibilityIdentifier(identifier)
            .accessibilityLabel(label)
            .accessibilityHint(hint ?? "")
            .accessibilityAddTraits(.isButton)
    }
    
    /// Add accessibility for headers
    func accessibilityHeader(identifier: String, label: String) -> some View {
        self
            .accessibilityIdentifier(identifier)
            .accessibilityLabel(label)
            .accessibilityAddTraits(.isHeader)
    }
    
    /// Add accessibility for images
    func accessibilityImage(identifier: String, label: String, isDecorative: Bool = false) -> some View {
        self
            .accessibilityIdentifier(identifier)
            .accessibilityLabel(isDecorative ? "" : label)
            .accessibilityAddTraits(isDecorative ? [] : .isImage)
    }
}
