//
//  CredentialRefresher.swift
//  NetworkKit
//
//  Created by Marwa Attef on 08/07/2026.
//

import Foundation

/// Refreshes authentication credentials.
///
/// This abstraction allows the retry layer to request refreshed
/// credentials without depending on a specific authentication
/// implementation such as OAuth or JWT.
public protocol CredentialRefresher: Sendable {
    
    /// Refreshes credentials and persists them.
    ///
    /// - Throws: An error if refreshing fails.
    func refreshCredentials() async throws
}
