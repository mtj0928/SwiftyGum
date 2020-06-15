import Foundation

protocol Calculator {
    func calculate(from mappingStore: MappingStore) -> EditScript
}
