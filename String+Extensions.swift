extension String {
    var red: String { Array(self).map({ "\($0)\u{fe06}"}).joined() }
    var green: String { Array(self).map({ "\($0)\u{fe07}"}).joined() }
    var orange: String { Array(self).map({ "\($0)\u{fe08}"}).joined() }
    var blue:  String { Array(self).map({ "\($0)\u{fe09}"}).joined() }
    var purple: String { Array(self).map({ "\($0)\u{fe0A}"}).joined() }
}
