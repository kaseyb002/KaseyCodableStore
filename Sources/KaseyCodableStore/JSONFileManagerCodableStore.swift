import Foundation

public final actor JSONFileManagerCodableStore<Object: Codable & Sendable> {
    public typealias CodableObject = Object
    
    private let fileName: String
    private let folderName: String
    private let jsonEncoder: JSONEncoder
    private let jsonDecoder: JSONDecoder
    private let fileManager: FileManager

    public init(
        fileName: String,
        folderName: String = "CodableObjects",
        jsonEncoder: JSONEncoder = .init(),
        jsonDecoder: JSONDecoder = .init(),
        fileManager: FileManager = .default,
    ) {
        self.fileName = fileName
        self.folderName = folderName
        self.jsonEncoder = jsonEncoder
        self.jsonDecoder = jsonDecoder
        self.fileManager = fileManager
    }
}

// MARK: - CodableStore
extension JSONFileManagerCodableStore: CodableStore {
    public func save(object: Object) async throws {
        guard let folderURL: URL else {
            throw JSONFileManagerCodableDataStoreError.failedToConstructFolderURL
        }
        
        try createFolderDirectoryIfNeeded(folderURL: folderURL)
        let fileURL: URL = try fileURL()
        
        let encodedData: Data = try jsonEncoder.encode(object)
        try encodedData.write(to: fileURL)
    }
    
    public func retrieve() async throws -> Object {
        let data: Data = try Data(contentsOf: try fileURL())
        return try jsonDecoder.decode(Object.self, from: data)
    }
    
    public func delete() async throws {
        try fileManager.removeItem(at: try fileURL())
    }

    private func createFolderDirectoryIfNeeded(folderURL: URL) throws {
        guard fileManager.fileExists(atPath: folderURL.path) == false else {
            return
        }
        
        try fileManager.createDirectory(
            atPath: folderURL.path,
            withIntermediateDirectories: true,
            attributes: nil
        )
    }
}

// MARK: - Derived URLs
extension JSONFileManagerCodableStore {
    private var documentsDirectory: URL? {
        fileManager.urls(
            for: .documentDirectory,
            in: .userDomainMask
        ).first
    }
    
    private var folderURL: URL? {
        documentsDirectory?
            .appendingPathComponent(folderName, isDirectory: true)
    }
    
    private func fileURL() throws -> URL {
        guard let documentsDirectory: URL else {
            throw JSONFileManagerCodableDataStoreError.documentsDirectoryNotFound
        }
        
        return documentsDirectory
            .appendingPathComponent(folderName, isDirectory: true)
            .appending(component: fileName + ".json")
    }
}

private enum JSONFileManagerCodableDataStoreError: Error {
    case documentsDirectoryNotFound
    case failedToConstructFolderURL
}
