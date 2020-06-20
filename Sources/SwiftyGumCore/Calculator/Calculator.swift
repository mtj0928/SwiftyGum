import Foundation

protocol EditScriptGenerator {
    func calculate(from mappingStore: MappingStore) -> EditScript
}
