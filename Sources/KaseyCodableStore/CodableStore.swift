import Foundation

/// Stores, retrieves, and deletes a single Codable object
public protocol CodableStore<CodableObject>: Sendable where CodableObject: Codable & Sendable {
    associatedtype CodableObject

    func save(object: CodableObject) async throws
    func retrieve() async throws -> CodableObject
    func delete() async throws
}
