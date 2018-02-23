struct IntDataFrame<C> where C: Hashable {
  private var wrapped: DataFrame<C, Int>
}

struct DataFrame<C, R> where C: Hashable, R: Hashable {
  private var columns = [C: [Any]]()
  private var rowIndex = [R: Int]()

  func set(column: C, values: [Any], index: [R]) {
    
  }

  subscript(index: C) -> [Any]? {
    get {
      return columns[index]
    }
  }

  subscript(index: R) -> [C: Any]? {
    get {
      guard let row = rowIndex[index] else { return nil }

      return columns.mapValues { $0[row] }
    }
  }
}

