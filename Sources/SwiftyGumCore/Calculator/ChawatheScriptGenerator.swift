import Foundation
import SwiftSyntax


/// This struct is based on Chawathe's methodology.
/// http://ilpubs.stanford.edu:8090/115/1/1995-46.pdf
struct ChawatheScriptGenerator: EditScriptGenerator {

    /// Plese check the Figure 8 (Algorithm EditScript) in the paper.
    func generate(from mappingStore: MappingStore) -> EditScript {
        var actions = [EditAction]()
        let mappingStore = copyMappingStore(from: mappingStore)
        let copiedSrcRootNode = mappingStore.srcRootNode
        let copiedDstRootNode = mappingStore.dstRootNode
        let orderStore = NodeOrderStore()

        mappingStore.link(src: copiedSrcRootNode, dst: copiedDstRootNode)

        //  valiable names are based on Figure 8.
        //
        //  x(dst) : target node
        //  y(dst) : x's parent node
        //  z(src) : matched node with y
        //  w(src) : matched node with x
        //  v(src) : w's parent
        //
        //       (src)      |  (dst)
        //  [v]       [z] <-+-> [y]
        //   |              |    |
        //  [w] <-----------+-> [x]
        //                  |

        for x in copiedDstRootNode.breadthFirstNodes {
            guard let y = x.parent else {
                // TODO: - the case when x is root
                continue
            }

            let z = mappingStore.matchedSrcNode(with: y)!
            if !mappingStore.isMatched(dst: x) {
                let pos = findPos(for: x, mappingStore: mappingStore, orderStore: orderStore)
                let w = Node(label: x.label, value: x.value, parent: z)
                let insert = EditAction.insert(node: w, to: z, pos: pos)
                actions.append(insert)
                z.children.insert(w, at: pos)
                mappingStore.link(src: w, dst: x)
            } else if let w = mappingStore.matchedSrcNode(with: x),
                let v = w.parent {

                if w.value != x.value {
                    let update = EditAction.update(node: w, newValue: x.value)
                    actions.append(update)
                    w.value = x.value
                }

                if !mappingStore.isLinked(src: v, dst: y) {
                    let pos = findPos(for: x, mappingStore: mappingStore, orderStore: orderStore)
                    let move = EditAction.move(node: w, to: z, pos: pos)
                    actions.append(move)
                    v.children.removeAll { $0 == w }
                    w.parent = z
                    z.children.insert(w, at: pos)
                }
            }
            let w = mappingStore.matchedSrcNode(with: x)!
            orderStore.orderSrcNodes.insert(w)
            orderStore.orderDstNodes.insert(x)
            let moves = alignChildren(w: w, x: x, mappingStore: mappingStore, orderStore: orderStore)
            actions.append(contentsOf: moves)
        }

        copiedSrcRootNode.updateHeight()

        copiedSrcRootNode.descents
            .filter { !mappingStore.isMatched(src: $0) }
            .sorted(by: { $0.height >= $1.height })
            .forEach { node in
                let delete = EditAction.delete(node: node)
                actions.append(delete)
                node.parent?.children.removeAll(where: { $0 == node })
        }
        return EditScript(action: actions)
    }

    /// Plese check the Figure 9 (AlignChildre) in the paper.
    private func alignChildren(w: Node, x: Node, mappingStore: MappingStore, orderStore: NodeOrderStore) -> [EditAction] {
        w.children.forEach { orderStore.orderSrcNodes.remove($0) }
        x.children.forEach { orderStore.orderDstNodes.remove($0) }

        let s1 = w.children.filter {
            mappingStore.isMatched(src: $0)
                && x.children.contains(mappingStore.mathcedDstNode(with: $0)!)
        }
        let s2 = x.children.filter {
            mappingStore.isMatched(dst: $0)
                && w.children.contains(mappingStore.matchedSrcNode(with: $0)!)
        }

        let s = computeLcs(s1: s1, s2: s2, mappingStore: mappingStore)
        s.forEach { (src, dst) in
            orderStore.orderSrcNodes.insert(src)
            orderStore.orderDstNodes.insert(dst)
        }

        var results = [EditAction]()
        for a in s1 {
            for b in s2 {
                if mappingStore.isLinked(src: a, dst: b)
                    && !s.contains(where: { $0 == a && $1 == b }) {
                    let k = findPos(for: b, mappingStore: mappingStore, orderStore: orderStore)
                    let move = EditAction.move(node: a, to: w, pos: k)
                    results.append(move)
                    w.children.removeAll(where: { $0 == a })
                    w.children.insert(a, at: k)
                    orderStore.orderSrcNodes.insert(a)
                    orderStore.orderDstNodes.insert(b)
                }
            }
        }
        return results
    }

    /// Plese check the Figure 9 (FindPos) in the paper.
    private func findPos(for x: Node, mappingStore: MappingStore, orderStore: NodeOrderStore) -> Int {
        guard let y = x.parent else {
                return 0
        }

        guard let vIndex = (0..<y.children.firstIndex(of: x)!)
            .reversed()
            .filter({ y.children[$0] != x })
            .first(where: { orderStore.orderDstNodes.contains(y.children[$0]) }) else {
                orderStore.orderDstNodes.insert(x)
                return 0
        }

        let v = y.children[vIndex]
        guard let u = mappingStore.matchedSrcNode(with: v) else {
            return 0
        }

        return u.parent!.children.firstIndex(of: u)! + 1
    }
}

// MARK: - Util

extension ChawatheScriptGenerator {

    func copyMappingStore(from mappingStore: MappingStore) -> MappingStore {
        let srcFakeNode = mappingStore.srcRootNode.deepCopy()
        let dstFakeNode = mappingStore.dstRootNode.deepCopy()

        let srcNodes = createNodeDict(from: srcFakeNode)
        let dstNodes = createNodeDict(from: dstFakeNode)

        let coppiedMappingStore = MappingStore(srcNode: srcFakeNode, dstNode: dstFakeNode)
        mappingStore.pairs.forEach { mapping in
            guard let srcNode = srcNodes[mapping.srcNode],
                let dstNode = dstNodes[mapping.dstNode] else {
                    return
            }
            coppiedMappingStore.link(Mapping(src: srcNode, dst: dstNode))
        }
        return mappingStore
    }

    private func createNodeDict(from node: Node) -> [Node: Node] {
        node.descents.reduce([:]) { (result, node) -> [Node: Node] in
            var result = result
            result[node] = node
            return result
        }
    }

    private func computeLcs(s1: [Node], s2: [Node], mappingStore: MappingStore) -> [(Node, Node)] {
        var results = [(Node, Node)]()
        var opt = Array(repeating: Array(repeating: 0, count: s2.count + 1), count: s1.count + 1)

        (0..<s1.count).reversed().forEach { i in
            (0..<s2.count).reversed().forEach { j in
                if mappingStore.matchedSrcNode(with: s2[j]) == s1[i] {
                    opt[i][j] = opt[i + 1][j + 1] + 1
                } else {
                    opt[i][j] = max(opt[i + 1][j], opt[i][j + 1])
                }
            }
        }

        var i = 0, j = 0
        while i < s1.count && j < s2.count {
            if mappingStore.matchedSrcNode(with: s2[j]) == s1[i] {
                results.append((s1[i], s2[j]))
                i += 1
                j += 1
            } else if opt[i + 1][j] >= opt[i][j + 1] {
                i += 1
            } else {
                j += 1
            }
        }
        return results
    }
}

private extension Node {

    var breadthFirstNodes: [Node] {
        var nodes = [Node]()
        var currents = [self]
        while !currents.isEmpty {
            let node = currents.removeFirst()
            nodes.append(node)
            currents.append(contentsOf: node.children)
        }
        return nodes
    }
}

class NodeOrderStore {
    var orderSrcNodes = Set<Node>()
    var orderDstNodes = Set<Node>()
}
