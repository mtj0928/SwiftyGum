import Foundation

protocol EditScriptGenerator {
    func generate(from mappingStore: MappingStore, srcSourceCode: SourceCode, dstSourceCode: SourceCode) -> EditScript
}
