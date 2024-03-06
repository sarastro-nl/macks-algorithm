import Foundation

class Node {
    public var data: (Int, Int)

    var value: Int
    var degree: Int = 0
    var mark: Bool = false
    var left: Node!
    var right: Node!
    var child: Node? = nil
    var parent: Node? = nil
    
    init(value: Int, data: (Int, Int)) {
        self.value = value
        self.data = data
        left = self
        right = self
    }
}

class Heap {
    private var min: Node? = nil
    private var root: Node? = nil
    private var n: Int = 0
    
    func insert(value: Int, data: (Int, Int)) -> Node {
        let node = Node(value: value, data: data)
        add_to_root(node: node)
        n += 1
        if let _min = min {
            if value < _min.value {
                min = node
            }
        } else {
            min = node
        }
        return node
    }
    
    func remove_minimum() -> Node? {
        guard let min = min else { return nil }
        print("removing minimum: \(min.value)")
        for node in get_siblings(node: min.child) {
            add_to_root(node: node)
            node.parent = nil
        }
        min.left.right = min.right
        min.right.left = min.left
        if min === min.right {
            root = nil
            self.min = nil
        } else {
            if root === min {
                root = min.right
            }
//            print_heap()
            consolidate()
            self.min = root
            var node: Node = root!.right
            while node !== root {
                if node.value < self.min!.value {
                    self.min = node
                }
                node = node.right
            }
        }
        n -= 1
        return min
    }

    func change_value(node: Node, value: Int, data: (Int, Int)) {
        if value < node.value {
//            print("changing value: \(node.value) to \(value) for \(data)")
            node.value = value
            node.data = data
//            print_heap()
            if let parent = node.parent, value < parent.value {
                move_to_root(node: node, parent: parent)
                cascade(node: parent)
            }
            if value < min!.value {
                min = node
            }
        }
    }
    
    private func add_to_root(node: Node) {
        if let root = root {
            node.left = root.left
            node.right = root
            root.left.right = node
            root.left = node
        } else {
            root = node
        }
    }
    
    private func add_child(node: Node, child: Node) {
        child.left.right = child.right
        child.right.left = child.left
        child.parent = node
        if root === child {
            root = child.right
        }
        if let first_child = node.child {
            child.left = first_child.left
            child.right = first_child
            first_child.left.right = child
            first_child.left = child
        } else {
            node.child = child
            child.left = child
            child.right = child
        }
        node.degree += 1
    }
    
    private func get_siblings(node: Node?) -> [Node] {
        var siblings: [Node] = []
        if let start = node {
            var node = start
            repeat {
                siblings.append(node)
                node = node.right
            } while node !== start
        }
        return siblings
    }
    
    private func consolidate() {
//        print("consolidating")
        var a: [Node?] = Array(repeating: nil, count: n)
        for var node in get_siblings(node: root) {
            var d = node.degree
            while var other = a[d] {
                if other.value < node.value {
                    swap(&node, &other)
                }
                add_child(node: node, child: other)
//                print_heap()
                a[d] = nil
                d += 1
            }
            a[d] = node
        }
    }
    
    private func move_to_root(node: Node, parent: Node) {
        node.left.right = node.right
        node.right.left = node.left
        if parent.child === node {
            if node === node.right {
                parent.child = nil
            } else {
                parent.child = node.right
            }
        }
        add_to_root(node: node)
//        print_heap()
        parent.degree -= 1
        node.parent = nil
        node.mark = false
    }
    
    private func cascade(node: Node) {
        if let parent = node.parent {
            if node.mark {
                move_to_root(node: node, parent: parent)
                cascade(node: parent)
            } else {
                node.mark = true
            }
        }
    }
    
    private func print_nodes(indent: inout Int, next_indent: inout Int, strings: inout [String], row: Int, node: Node) {
        var row = row
        if row > 0 {
            if row == strings.count { strings.append("") }
            strings[row] += String(repeating: " ", count: indent - strings[row].count) + "│"
            row += 1
            if row == strings.count { strings.append("") }
            strings[row] += String(repeating: " ", count: indent - strings[row].count)
        }
        var node = node
        let start = node
        repeat {
            if row == strings.count { strings.append("") }
            strings[row] += String(node.value)
            if strings[row].count + 1 > next_indent {
                next_indent = strings[row].count + 1
            }
            if let child = node.child {
                print_nodes(indent: &indent, next_indent: &next_indent, strings: &strings, row: row + 1, node: child)
            } else {
                indent = next_indent
                next_indent = 0
            }
            node = node.right
            if start !== node {
                strings[row] += String(repeating: "-", count: indent - strings[row].count)
            }
        } while start !== node
    }
    
    private func print_heap() {
        var strings: [String] = []
        if let node = root {
            var indent = 0
            var next_indent = 0
            print_nodes(indent: &indent, next_indent: &next_indent, strings: &strings, row: 0, node: node)
        }
        for s in strings {
            print(s)
        }
        print("======================")
    }
    
    //int main(int argc, const char * argv[] {
    //    node_t *n1 = insert(7)
    //    node_t *n2 = insert(18)
    //    node_t *n3 = insert(38)
    //    node_t *n4 = insert(24)
    //    node_t *n5 = insert(17)
    //    node_t *n6 = insert(23)
    //    node_t *n7 = insert(21)
    //    node_t *n8 = insert(39)
    //    node_t *n9 = insert(41)
    //    node_t *n10 = insert(26)
    //    node_t *n11 = insert(46)
    //    node_t *n12 = insert(30)
    //    node_t *n13 = insert(35)
    //    node_t *n14 = insert(52)
    //    add_child(n1, n4)
    //    add_child(n1, n5)
    //    add_child(n1, n6)
    //    add_child(n4, n10)
    //    add_child(n4, n11)
    //    add_child(n5, n12)
    //    add_child(n10, n13)
    //    add_child(n2, n7)
    //    add_child(n2, n8)
    //    add_child(n7, n14)
    //    add_child(n3, n9)
    //    n10.mark = true
    //    n2.mark = true
    //    n8.mark = true
    //    print_heap()
    //    change_value(n11, 15)
    //    print_heap()
    //    change_value(n13, 5)
    //    print_heap()
    //    remove_node(n14)
    //    print_heap()
    //    while node_t *node = remove_minimum( {
    //        free(node)
    //    }
    //    return 0
    //}
    //
}
