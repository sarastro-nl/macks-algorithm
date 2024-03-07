import Foundation

let dim = 12
var m = Array(repeating: 0, count: dim * dim)
m = [ 21,16,13,26,17,20,2,22,13,6,2,21,23,8,7,2,17,1,11,11,11,10,5,27,14,6,14,10,9,0,3,2,16,25,13,2,3,15,15,0,18,10,9,17,27,22,21,14,10,8,14,2,9,17,22,15,0,11,27,24,15,22,27,27,15,24,26,5,4,18,25,14,22,4,8,6,16,17,25,18,1,21,18,16,13,13,20,1,24,19,22,17,11,9,15,12,19,6,12,2,17,8,27,18,22,23,3,24,12,23,26,4,13,14,17,22,2,26,13,21,25,6,11,22,12,0,12,2,21,9,16,2,12,23,1,2,16,15,27,24,22,22,7,25,
]
var base = Array(repeating: 0, count: dim)
var u = Array(repeating: 0, count: dim)
var nrOfBases = Array(repeating: 0, count: dim)

func print_m(_ rows: [Int]? = nil, _ columns: [Int]? = nil, _ min: (Int, Int)? = nil) {
    var s: String
    for i in 0..<dim {
        for j in 0..<dim {
            s = String(format: "%3d ", m[i * dim + j] + u[j])
            if base[i] == j {
                s = s.red
            } else if let min = min, min == (i, j) {
                s = s.green
            } else if let columns = columns, columns.contains(j) {
                s = s.blue
            } else if let rows = rows, rows.contains(i) {
                s = s.orange
            }
            print(s, terminator: "")
        }
        print()
    }
    print()
}

func macksalgoritm() {
    for i in 0..<dim {
        var min = m[i * dim];
        var jj = 0;
        for j in 1..<dim {
            if m[i * dim + j] < min {
                min = m[i * dim + j]
                jj = j
            }
        }
        base[i] = jj
        nrOfBases[jj] += 1
    }
    print_m()
    var row = -1
    while var column = nrOfBases.firstIndex(where: {$0 > 1}) {
        print("checking column: \(column + 1)")
        var rows: [Int] = []
        var columns: [Int] = []
        var pred = Array(repeating: -1, count: dim)
        let heap = Heap()
        var nodes: [Node?] = Array(repeating: nil, count: dim)
        var dsum = 0
        repeat {
            columns.append(column)
            for (row, value) in base.enumerated() where value == column {
                rows.append(row)
                let mbase = m[row * dim + column] + u[column] - dsum
                for j in 0..<dim where !columns.contains(j) {
                    let value = m[row * dim + j] + u[j] - mbase
                    if let node = nodes[j] {
                        heap.change_value(node: node, value: value, data: (row, j))
                    } else {
                        nodes[j] = heap.insert(value: value, data: (row, j))
                    }
                }
            }
            print_m(rows, columns)
            for j in 0..<dim {
                if columns.contains(j) {
                    print("    ", terminator: "")
                } else {
                    var jmin = Int.max
                    for i in rows.sorted() {
                        let mbase = m[i * dim + base[i]] + u[base[i]]
                        let mm = m[i * dim + j] + u[j]
                        if mm - mbase < jmin {
                            jmin = mm - mbase
                        }
                    }
                    let s = String(format: "%3d ", jmin + dsum)
                    print(s.red, terminator: "")
                }
            }
            print()
            guard let node = heap.remove_minimum() else { fatalError() }
            pred[column] = row
            (row, column) = node.data
            print("dsum: \(dsum)")
            if node.value > dsum {
                let min = node.value - dsum
                dsum = node.value
                for j in columns {
                    u[j] += min
                }
            }
            print_m(rows, columns, (row, column))
        } while base.contains(column)
        nrOfBases[column] += 1
        repeat {
            let oldColumn = base[row]
            base[row] = column
            column = oldColumn
            row = pred[column]
        } while row > -1
        nrOfBases[column] -= 1
        print("changing bases")
        print_m(rows, columns)
    }
    
    u = Array(repeating: 0, count: dim)
    print("Mack's algorithm solution:")
    print_m()
    var sum = 0
    for i in 0..<dim { sum += m[i * dim + base[i]] }
    print("sum: \(sum)")
    
    print("================")
}

func brute_force() {
    var l = Array(repeating: -1, count: dim)
    var min = Int.max
    var sum = 0

    func brute(_ i: Int = 0) {
        guard i < dim else { base = l; min = sum; return }
        for j in 0..<dim where !l.contains(j) && sum + m[i * dim + j] < min {
            sum += m[i * dim + j]
            l[i] = j
            brute(i + 1)
            l[i] = -1
            sum -= m[i * dim + j]
        }
    }
    
    brute()
    print("brute force solution:")
    print_m()
    print("sum: \(min)")
}

macksalgoritm()
brute_force()
