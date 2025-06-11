//
//  SecurityManager.swift
//  template
//
//  Created by iOS Advanced Setup Script
//

import Foundation
import LocalAuthentication
import CryptoKit
import UIKit
import os.log

// MARK: - Security Service Protocol
protocol SecurityServiceProtocol {
    func encrypt(data: Data) -> Data?
    func decrypt(data: Data) -> Data?
    func generateSecureToken() -> String
    func validateCertificate(_ certificate: Data) -> Bool
}

/// Security manager for handling app security features
final class SecurityManager: @unchecked Sendable, SecurityServiceProtocol {
    static let shared = SecurityManager()
    
    private let logger = Logger(subsystem: Bundle.main.bundleIdentifier ?? "com.ios.template", category: "Security")
    private let context = LAContext()
    
    private init() {}
    
    // MARK: - Jailbreak Detection
    
    /// Check if device is jailbroken
    func isJailbroken() -> Bool {
        #if targetEnvironment(simulator)
        return false
        #else
        
        // Check for common jailbreak files
        let jailbreakPaths = [
            "/Applications/Cydia.app",
            "/Library/MobileSubstrate/MobileSubstrate.dylib",
            "/bin/bash",
            "/usr/sbin/sshd",
            "/etc/apt",
            "/private/var/lib/apt/",
            "/private/var/lib/cydia",
            "/private/var/mobile/Library/SBSettings/Themes",
            "/Library/MobileSubstrate/DynamicLibraries/LiveClock.plist",
            "/System/Library/LaunchDaemons/com.ikey.bbot.plist",
            "/System/Library/LaunchDaemons/com.saurik.Cydia.Startup.plist",
            "/private/var/tmp/cydia.log",
            "/private/var/lib/cydia",
            "/private/var/stash"
        ]
        
        for path in jailbreakPaths {
            if FileManager.default.fileExists(atPath: path) {
                logger.warning("🚨 Jailbreak detected: Found file at \(path)")
                return true
            }
        }
        
        // Check if we can write to system directories
        let testString = "jailbreak_test"
        do {
            try testString.write(toFile: "/private/test_jailbreak.txt", atomically: true, encoding: .utf8)
            try FileManager.default.removeItem(atPath: "/private/test_jailbreak.txt")
            logger.warning("🚨 Jailbreak detected: Can write to system directory")
            return true
        } catch {
            // This is expected on non-jailbroken devices
        }
        
        // Check for suspicious URL schemes
        let suspiciousSchemes = ["cydia://", "undecimus://", "sileo://"]
        for scheme in suspiciousSchemes {
            if let url = URL(string: scheme), UIApplication.shared.canOpenURL(url) {
                logger.warning("🚨 Jailbreak detected: Can open suspicious URL scheme \(scheme)")
                return true
            }
        }
        
        return false
        #endif
    }
    
    // MARK: - Debugger Detection
    
    /// Check if debugger is attached
    func isDebuggerAttached() -> Bool {
        #if DEBUG
        return false // Allow debugging in debug builds
        #else
        var info = kinfo_proc()
        var mib: [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        var size = MemoryLayout<kinfo_proc>.stride
        
        let result = sysctl(&mib, u_int(mib.count), &info, &size, nil, 0)
        
        if result != 0 {
            return false
        }
        
        let isDebugged = (info.kp_proc.p_flag & P_TRACED) != 0
        if isDebugged {
            logger.warning("🚨 Debugger detected")
        }
        
        return isDebugged
        #endif
    }
    
    // MARK: - Biometric Authentication
    
    /// Check if biometric authentication is available
    func isBiometricAvailable() -> Bool {
        var error: NSError?
        let available = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if let error = error {
            logger.error("❌ Biometric check failed: \(error.localizedDescription)")
        }
        
        return available
    }
    
    /// Get biometric type
    func getBiometricType() -> LABiometryType {
        return context.biometryType
    }
    
    /// Authenticate with biometrics
    func authenticateWithBiometrics(reason: String) async -> Result<Bool, Error> {
        return await withCheckedContinuation { continuation in
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                if let error = error {
                    self.logger.error("❌ Biometric authentication failed: \(error.localizedDescription)")
                    continuation.resume(returning: .failure(error))
                } else {
                    self.logger.info("✅ Biometric authentication successful")
                    continuation.resume(returning: .success(success))
                }
            }
        }
    }
    
    // MARK: - Data Encryption
    
    /// Encrypt data using AES-GCM
    func encryptData(_ data: Data, key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.seal(data, using: key)
        return sealedBox.combined!
    }
    
    /// Decrypt data using AES-GCM
    func decryptData(_ encryptedData: Data, key: SymmetricKey) throws -> Data {
        let sealedBox = try AES.GCM.SealedBox(combined: encryptedData)
        return try AES.GCM.open(sealedBox, using: key)
    }
    
    /// Generate a new symmetric key
    func generateSymmetricKey() -> SymmetricKey {
        return SymmetricKey(size: .bits256)
    }
    
    // MARK: - Certificate Pinning
    
    /// Validate SSL certificate pinning
    func validateCertificatePinning(for challenge: URLAuthenticationChallenge, pinnedCertificates: [Data]) -> Bool {
        guard let serverTrust = challenge.protectionSpace.serverTrust else {
            logger.error("❌ No server trust found")
            return false
        }
        
        let serverCertificateCount = SecTrustGetCertificateCount(serverTrust)
        
        for i in 0..<serverCertificateCount {
            guard let serverCertificate = SecTrustGetCertificateAtIndex(serverTrust, i) else {
                continue
            }
            
            let serverCertificateData = SecCertificateCopyData(serverCertificate)
            let serverCertificateBytes = CFDataGetBytePtr(serverCertificateData)
            let serverCertificateLength = CFDataGetLength(serverCertificateData)
            
            let serverCertificateNSData = Data(bytes: serverCertificateBytes!, count: serverCertificateLength)
            
            for pinnedCertificate in pinnedCertificates {
                if serverCertificateNSData == pinnedCertificate {
                    logger.info("✅ Certificate pinning validation successful")
                    return true
                }
            }
        }
        
        logger.warning("🚨 Certificate pinning validation failed")
        return false
    }
    
    // MARK: - Screen Recording Detection
    
    /// Check if screen is being recorded
    func isScreenBeingRecorded() -> Bool {
        if #available(iOS 11.0, *) {
            let isRecording = UIScreen.main.isCaptured
            if isRecording {
                logger.warning("🚨 Screen recording detected")
            }
            return isRecording
        }
        return false
    }
    
    // MARK: - App Integrity
    
    /// Verify app signature (simplified version)
    func verifyAppSignature() -> Bool {
        let bundlePath = Bundle.main.bundlePath
        guard !bundlePath.isEmpty else {
            logger.error("❌ Could not get bundle path")
            return false
        }

        // Basic bundle integrity check
        let requiredFiles = ["Info.plist", "PkgInfo"]
        for file in requiredFiles {
            let filePath = bundlePath + "/" + file
            if !FileManager.default.fileExists(atPath: filePath) {
                logger.warning("🚨 Missing required file: \(file)")
                return false
            }
        }

        logger.info("✅ Basic app integrity check passed")
        return true
    }
    
    // MARK: - SecurityServiceProtocol Implementation

    func encrypt(data: Data) -> Data? {
        let key = generateSymmetricKey()
        do {
            return try encryptData(data, key: key)
        } catch {
            logger.error("❌ Encryption failed: \(error)")
            return nil
        }
    }

    func decrypt(data: Data) -> Data? {
        let key = generateSymmetricKey()
        do {
            return try decryptData(data, key: key)
        } catch {
            logger.error("❌ Decryption failed: \(error)")
            return nil
        }
    }

    func generateSecureToken() -> String {
        let key = generateSymmetricKey()
        return key.withUnsafeBytes { Data($0).base64EncodedString() }
    }

    func validateCertificate(_ certificate: Data) -> Bool {
        // Basic certificate validation
        return certificate.count > 0
    }

    // MARK: - Security Checks

    /// Perform comprehensive security check
    func performSecurityCheck() -> SecurityCheckResult {
        let jailbroken = isJailbroken()
        let debuggerAttached = isDebuggerAttached()
        let screenRecording = isScreenBeingRecorded()
        let signatureValid = verifyAppSignature()
        
        let result = SecurityCheckResult(
            isJailbroken: jailbroken,
            isDebuggerAttached: debuggerAttached,
            isScreenBeingRecorded: screenRecording,
            isSignatureValid: signatureValid
        )
        
        logger.info("🔒 Security check completed: \(result)")
        
        return result
    }
}

// MARK: - Security Check Result

struct SecurityCheckResult {
    let isJailbroken: Bool
    let isDebuggerAttached: Bool
    let isScreenBeingRecorded: Bool
    let isSignatureValid: Bool
    
    var isSecure: Bool {
        return !isJailbroken && !isDebuggerAttached && !isScreenBeingRecorded && isSignatureValid
    }
}

extension SecurityCheckResult: CustomStringConvertible {
    var description: String {
        return """
        SecurityCheckResult(
            jailbroken: \(isJailbroken),
            debugger: \(isDebuggerAttached),
            recording: \(isScreenBeingRecorded),
            signature: \(isSignatureValid),
            secure: \(isSecure)
        )
        """
    }
}
