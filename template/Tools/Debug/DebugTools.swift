//
//  DebugTools.swift
//  template
//
//  Created by iOS Advanced Setup Script
//

import Foundation
import SwiftUI
import os.log

#if DEBUG

/// Debug tools and utilities for development
final class DebugTools {
    static let shared = DebugTools()
    
    let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.ios.template", category: "Debug")
    
    private init() {}
    
    /// Print detailed view hierarchy
    func printViewHierarchy() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            logger.warning("🐛 No window found for view hierarchy debugging")
            return
        }
        printView(window, level: 0)
    }
    
    private func printView(_ view: UIView, level: Int) {
        let indent = String(repeating: "  ", count: level)
        let viewInfo = "\(indent)\(String(describing: type(of: view))) - Frame: \(view.frame)"
        logger.info("\(viewInfo)")
        
        for subview in view.subviews {
            printView(subview, level: level + 1)
        }
    }
    
    /// Log memory warnings
    func logMemoryWarning() {
        logger.warning("🚨 Memory warning received")
        PerformanceMonitor.shared.logMemoryUsage()
    }
    
    /// Debug network requests
    func logNetworkRequest(url: String, method: String, headers: [String: String]? = nil) {
        logger.debug("🌐 Network Request: \(method) \(url)")
        if let headers = headers {
            logger.debug("📋 Headers: \(headers)")
        }
    }
    
    /// Debug network response
    func logNetworkResponse(url: String, statusCode: Int, data: Data?) {
        logger.debug("🌐 Network Response: \(statusCode) \(url)")
        if let data = data {
            logger.debug("📊 Response size: \(data.count) bytes")
        }
    }
    
    /// Debug user defaults
    func printUserDefaults() {
        let defaults = UserDefaults.standard.dictionaryRepresentation()
        logger.debug("💾 UserDefaults:")
        for (key, value) in defaults {
            let headerInfo = "  \(key): \(value)"
            logger.info("\(headerInfo)")
        }
    }
    
    /// Debug keychain items (for development only)
    func printKeychainItems() {
        logger.debug("🔐 Keychain items (development only)")
        // Implementation would go here for keychain debugging
    }
    
    /// Simulate memory pressure
    func simulateMemoryPressure() {
        logger.warning("🧪 Simulating memory pressure")
        // Force memory warning for testing
        DispatchQueue.main.async {
            UIApplication.shared.perform(Selector(("_performMemoryWarning")))
        }
    }
    
    /// Debug app state
    func logAppState() {
        let state = UIApplication.shared.applicationState
        let stateString: String
        
        switch state {
        case .active:
            stateString = "Active"
        case .inactive:
            stateString = "Inactive"
        case .background:
            stateString = "Background"
        @unknown default:
            stateString = "Unknown"
        }
        
        logger.debug("📱 App State: \(stateString)")
    }
}

/// Debug view modifier for SwiftUI
struct DebugModifier: ViewModifier {
    let identifier: String
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                DebugTools.shared.logger.debug("👁️ View appeared: \(identifier)")
            }
            .onDisappear {
                DebugTools.shared.logger.debug("👋 View disappeared: \(identifier)")
            }
    }
}

extension View {
    /// Add debug logging to any view
    func debugLog(_ identifier: String) -> some View {
        self.modifier(DebugModifier(identifier: identifier))
    }
}

/// Debug overlay for showing performance metrics
struct DebugOverlay: View {
    @State private var isVisible = false
    @State private var memoryUsage = "0 MB"
    
    var body: some View {
        VStack {
            if isVisible {
                VStack(alignment: .leading, spacing: 4) {
                    Text("🐛 Debug Info")
                        .font(.caption.bold())
                    Text("Memory: \(memoryUsage)")
                        .font(.caption)
                    Text("Build: \(AppConstants.App.buildNumber)")
                        .font(.caption)
                    Text("Version: \(AppConstants.App.version)")
                        .font(.caption)
                }
                .padding(8)
                .background(Color.black.opacity(0.8))
                .foregroundColor(.white)
                .cornerRadius(8)
                .transition(.opacity)
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding()
        .onTapGesture(count: 3) {
            withAnimation {
                isVisible.toggle()
            }
        }
        .onAppear {
            updateMemoryUsage()
        }
    }
    
    private func updateMemoryUsage() {
        // Update memory usage periodically
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            var memoryInfo = mach_task_basic_info()
            var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4
            
            let kerr: kern_return_t = withUnsafeMutablePointer(to: &memoryInfo) {
                $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                    task_info(mach_task_self_,
                              task_flavor_t(MACH_TASK_BASIC_INFO),
                              $0,
                              &count)
                }
            }
            
            if kerr == KERN_SUCCESS {
                let memoryUsageMB = Double(memoryInfo.resident_size) / 1024.0 / 1024.0
                memoryUsage = String(format: "%.1f MB", memoryUsageMB)
            }
        }
    }
}

#endif
