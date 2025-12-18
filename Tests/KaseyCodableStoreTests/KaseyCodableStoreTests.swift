import Testing
@testable import KaseyCodableStore

@Test func example() async throws {
    struct ExampleData: Codable, Sendable, Equatable {
        let name: String
        let message: String
        let age: Int
    }
    
    let exampleData: ExampleData = .init(
        name: "ralph",
        message: "hello",
        age: 32
    )
    
    let exampleStore: JSONFileManagerCodableStore<ExampleData> = .init(fileName: "example")
    try await exampleStore.save(object: exampleData)

    let retrievedData: ExampleData = try await exampleStore.retrieve()
    #expect(exampleData == retrievedData)
    
    try await exampleStore.delete()
    await #expect(throws: (any Error).self) {
        _ = try await exampleStore.retrieve()
    }
}
