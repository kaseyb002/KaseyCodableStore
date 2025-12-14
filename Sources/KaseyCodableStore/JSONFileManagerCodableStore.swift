import Foundation

public final class JSONFileManagerCodableStore: CodableStore {
    private let jsonEncoder: JSONEncoder = .init()
    private let jsonDecoder: JSONDecoder = .init()
    private let folderName: String
    private let fileName: String
    
    public func save<E: Encodable>(object: E) async throws {
        guard let documentsDirectory: URL else {
            throw JSONFileManagerCodableDataStoreError.documentsDirectoryNotFound
        }
        
        let folderURL: URL = documentsDirectory
            .appendingPathComponent(folderName, isDirectory: true)
        try createFolderDirectoryIfNeeded(folderURL: folderURL)
        let fileURL: URL = folderURL
            .appending(component: fileName + ".json")
        
        let encodedData: Data = try jsonEncoder.encode(object)
        try encodedData.write(to: fileURL)
    }
    
    public func retrieve<D: Decodable>(type: D.Type) async throws -> D {
        let data: Data = try Data(contentsOf: try fileURL())
        let object: D = try jsonDecoder.decode(D.self, from: data)
        return object
    }
    
    public func delete() async throws {
        try FileManager.default.removeItem(at: try fileURL())
    }
    
    private var documentsDirectory: URL? {
        FileManager.default.urls(
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
    
    public init(
        folderName: String = "CodableObjects",
        fileName: String
    ) {
        self.folderName = folderName
        self.fileName = fileName
    }
    
    private func createFolderDirectoryIfNeeded(folderURL: URL) throws {
        let fm = FileManager.default
        guard fm.fileExists(atPath: folderURL.path) == false else {
            return
        }
        
        try fm.createDirectory(
            atPath: folderURL.path,
            withIntermediateDirectories: true,
            attributes: nil
        )
    }
}

private enum JSONFileManagerCodableDataStoreError: Error {
    case documentsDirectoryNotFound
}
