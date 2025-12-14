import Foundation

public protocol CodableStore: Sendable {
    func save<E: Encodable>(object: E) async throws
    func retrieve<D: Decodable>(type: D.Type) async throws -> D
    func delete() async throws
}
