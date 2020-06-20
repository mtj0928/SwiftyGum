import Foundation

protocol EditScriptGenerator {
    func generate(from mappingStore: MappingStore) -> EditScript
}
