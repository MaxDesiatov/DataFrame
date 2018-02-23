struct DataFrame<C, R> where C: Hashable, R: Hashable {
  fileprivate var columns = [C: [Any]]()
  fileprivate var rowIndex = [R: Int]()

  /// Empty DataFrame
  init() {
  }

  func set(column: C, values: [Any], index: [R]) {
    // Autogenerate missing Int row index
    if C.self == Int.self {
      print("test")
    }
  }

  subscript(index: C) -> [Any]? {
    get {
      return columns[index]
    }
  }

  subscript(index: R) -> Row<C, R>? {
    get {
      guard let rowPosition = rowIndex[index] else { return nil }

      return Row(dataFrame: self, rowPosition: rowPosition)
    }
  }

  func group<G>(by: @escaping (Row<C, R>) -> G) -> DataFrameGroup<C, R, G>
  where G: Equatable {
    return DataFrameGroup(grouping: by)
  }
}

// This should encapsulate DataFrame access without a need to copy every row
// to a dictionary, although need to test how Array and Dictionary COW works here.
// Given that a Row has `dataFrame` property, when does all `dataFrame` contents
// get copied to a Row, or is it copied at all if the original DataFrame is
// not modified?
// Is a separate Row struct needed, or could it just wrap something like DataSlice?
struct Row<C, R> where C: Hashable, R: Hashable {
  fileprivate let dataFrame: DataFrame<C, R>
  fileprivate let rowPosition: Int

  subscript(index: C) -> Any? {
    get {
      return dataFrame[index]?[rowPosition]
    }
  }
}

struct DataFrameGroup<C, R, G> where C: Hashable, R: Hashable, G: Equatable {
  let grouping: (Row<C, R>) -> G
}
