import Foundation

/// Stores, retrieves, and deletes a single Codable object
public protocol CodableStore: Sendable {
    associatedtype CodableObject: Codable & Sendable

    func save(object: CodableObject) async throws
    func retrieve() async throws -> CodableObject
    func delete() async throws
}
