class SudokuGrid {
  static const int size = 9;
  List<String> cells;

  static const characters = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];

  SudokuGrid(this.cells);

  SudokuGrid copy(SudokuGrid original) {
    return SudokuGrid([...cells]);
  }

  @override
  String toString() {
    var table = "";
    for (int i = 0; i < size; i++) {
      if (i % 3 == 0) {
        table += " --- --- --- --- --- --- --- --- ---\n";
      }
      table +=
          "| ${cells[i * size]}   ${cells[i * size + 1]}   ${cells[i * size + 2]} | ${cells[i * size + 3]} ";
      table +=
          "  ${cells[i * size + 4]}   ${cells[i * size + 5]} | ${cells[i * size + 6]}   ${cells[i * size + 7]} ";
      table += "  ${cells[i * size + 8]} | \n";
    }
    table += " --- --- --- --- --- --- --- --- ---";
    return table;
  }

  String getCell(int row, int column) {
    return cells[row * SudokuGrid.size + column];
  }

  void setCell(int row, int column, String value) {
    cells[row * SudokuGrid.size + column] = value;
  }

  List<String> getRow(int i) {
    return cells
        .getRange(
            i * SudokuGrid.size, i * SudokuGrid.size + SudokuGrid.size - 1)
        .toList();
  }

  List<String> getColumn(int i) {
    return List<int>.generate(
            SudokuGrid.size, (index) => index * SudokuGrid.size + i)
        .map((e) => cells[e])
        .toList();
  }

  List<String> getBlock(int i) {
    var indexes = List<int>.generate(
        SudokuGrid.size,
        (idx) =>
            ((i % 3) * 3 + (i ~/ 3) * 27) +
            (SudokuGrid.size * (idx ~/ 3)) +
            (idx % 3));
    return indexes.map((e) => cells[e]).toList();
  }
}

class SudokuGridValidator {

  bool isValid(SudokuGrid grid){
    return Iterable<int>.generate(9).toList()
      .map((i) => rowIsValid(grid, i) && columnIsValid(grid, i) && blockIsValid(grid, i))
      .reduce((value, element) => value && element );
  }

  bool isSucceed(SudokuGrid grid){
    return gridIsCompleted(grid) && isValid(grid);
  }

  bool rowIsValid(SudokuGrid grid, int i) {
    var cells = grid.getRow(i);
    return valuesAreUniq(cells);
  }

  bool columnIsValid(SudokuGrid grid, int i) {
    var cells = grid.getColumn(i);
    return valuesAreUniq(cells);
  }

  bool blockIsValid(SudokuGrid grid, int i) {
    var cells = grid.getBlock(i);
    return valuesAreUniq(cells);
  }

  bool gridIsCompleted(SudokuGrid grid) {
    return grid.cells
        .firstWhere((element) => !SudokuGrid.characters.contains(element),
            orElse: () => "")
        .isEmpty;
  }

  bool valuesAreUniq(List<String> cells) {
    var cellsNumber =
        cells.where((element) => SudokuGrid.characters.contains(element));
    var distinctValues = [
      ...{...cellsNumber}
    ];
    return cellsNumber.length == distinctValues.length;
  }
}


abstract class SudokuSolver {
  SudokuGrid solve(SudokuGrid grid);

  bool isValueInRow(SudokuGrid grid, int row, String value) {
    return grid.getRow(row).contains(value);
  }

  bool isEmptyValue(SudokuGrid grid, int row, int column) {
    return !SudokuGrid.characters.contains(grid.getCell(row, column));
  }

  bool isValueInColumn(SudokuGrid grid, int column, String value) {
    return grid.getColumn(column).contains(value);
  }

  bool isValueInBlock(SudokuGrid grid, int blockId, String value) {
    return grid.getBlock(blockId).contains(value);
  }

  bool isCorrectAt(SudokuGrid grid, int row, int column, String value) {
    var blockId = (row ~/ 3) * 3 + column ~/ 3;
    return !isValueInBlock(grid, blockId, value) &&
        !isValueInColumn(grid, column, value) &&
        !isValueInRow(grid, row, value);
  }

  bool rowIsValid(SudokuGrid grid, int i) {
    var cells = grid.getRow(i);
    return valuesAreUniq(cells);
  }

  bool columnIsValid(SudokuGrid grid, int i) {
    var cells = grid.getColumn(i);
    return valuesAreUniq(cells);
  }

  bool blockIsValid(SudokuGrid grid, int i) {
    var cells = grid.getBlock(i);
    return valuesAreUniq(cells);
  }

  bool gridIsCompleted(SudokuGrid grid) {
    return grid.cells
        .firstWhere((element) => !SudokuGrid.characters.contains(element),
            orElse: () => "")
        .isEmpty;
  }

  bool valuesAreUniq(List<String> cells) {
    var cellsNumber =
        cells.where((element) => SudokuGrid.characters.contains(element));
    var distinctValues = [
      ...{...cellsNumber}
    ];
    return cellsNumber.length == distinctValues.length;
  }
}

class NotResolvableException implements Exception {
  SudokuGrid grid;
  NotResolvableException(this.grid);
}

SudokuSolver getSudokuSolver() {
  return RecursiveSudokuSolver();
}

class RecursiveSudokuSolver extends SudokuSolver {
  @override
  SudokuGrid solve(SudokuGrid grid) {
    var copy = grid.copy(grid);
    for (int i = 0; i < SudokuGrid.size; i++) {
      for (int j = 0; j < SudokuGrid.size; j++) {
        if (isEmptyValue(grid, i, j)) {
          for (int idx = 0; idx < SudokuGrid.characters.length; idx++) {
            final value = SudokuGrid.characters[idx];
            if (isCorrectAt(copy, i, j, value)) {
              copy.setCell(i, j, value);
              try {
                return solve(copy);
              } catch (e) {
                copy.setCell(i, j, '?');
              }
            }
          }
          throw NotResolvableException(copy);
        }
      }
    }
    return copy;
  }
}
