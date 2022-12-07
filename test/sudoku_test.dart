import 'package:sudoku/sudoku.dart';
import 'package:test/test.dart';

void main() {
  group('SudokuGrid', () {
    final grid = SudokuGrid(List.generate(SudokuGrid.size * SudokuGrid.size,
        (index) => "${(index % SudokuGrid.size) + 1}"));

    test('print', () {
      print(grid.toString());
    });
  });

  group('SudokuSolver', () {
    final solver = getSudokuSolver();

    setUp(() {
      // Additional setup goes here.
    });

    test('solve', () {
      var grid = SudokuGrid(
          List.generate(SudokuGrid.size * SudokuGrid.size, (index) => "?"));
      grid.setCell(0, 0, '9');
      try {
        var result = solver.solve(grid);
        expect(result.getCell(0, 0), '9');
        print(result.toString());
      } on NotResolvableException catch (e) {
        print(e.grid.toString());
        fail("Not resolvable grid");
      }
    });

    test('isEmptyValye', () {
      var grid = SudokuGrid(
          List.generate(SudokuGrid.size * SudokuGrid.size, (index) => "?"));
      expect(solver.isEmptyValue(grid, 1, 3), isTrue);
      grid.setCell(1, 3, '1');
      expect(solver.isEmptyValue(grid, 1, 3), isFalse);
    });

    test('isValueInRow', () {
      var grid = SudokuGrid(
          List.generate(SudokuGrid.size * SudokuGrid.size, (index) => "?"));
      expect(solver.isValueInRow(grid, 0, '1'), isFalse);
      grid.setCell(0, 3, '1');
      expect(solver.isValueInRow(grid, 0, '1'), isTrue);
      expect(solver.isValueInRow(grid, 1, '1'), isFalse);
    });

    test('isValueInColumn', () {
      var grid = SudokuGrid(
          List.generate(SudokuGrid.size * SudokuGrid.size, (index) => "?"));
      expect(solver.isValueInColumn(grid, 1, '1'), isFalse);
      grid.setCell(2, 1, '1');
      expect(solver.isValueInColumn(grid, 1, '1'), isTrue);
      expect(solver.isValueInColumn(grid, 2, '1'), isFalse);
    });

    test('isValueInBlock', () {
      var grid = SudokuGrid(
          List.generate(SudokuGrid.size * SudokuGrid.size, (index) => "?"));
      expect(solver.isValueInBlock(grid, 1, '1'), isFalse);
      grid.setCell(1, 3, '1');
      expect(solver.isValueInBlock(grid, 1, '1'), isTrue);
      expect(solver.isValueInBlock(grid, 2, '1'), isFalse);
    });

    test('gridIsCompleted', () {
      var grid = SudokuGrid(List.generate(SudokuGrid.size * SudokuGrid.size,
          (index) => "${(index % SudokuGrid.size) + 1}"));
      expect(solver.gridIsCompleted(grid), isTrue);
      grid.cells[SudokuGrid.size] = "?";
      expect(solver.gridIsCompleted(grid), isFalse);
    });

    test('rowIsValid', () {
      var grid = SudokuGrid(
          List.generate(SudokuGrid.size * SudokuGrid.size, (index) => "?"));
      expect(solver.rowIsValid(grid, 0), isTrue);
      for (var i = 0; i < SudokuGrid.size; i++) {
        grid.cells[i] = "${i + 1}";
      }
      expect(solver.rowIsValid(grid, 0), isTrue);
      grid.cells[1] = "1";
      expect(solver.rowIsValid(grid, 0), isFalse);
      grid.cells[1] = "?";
      expect(solver.rowIsValid(grid, 0), isTrue);
      grid.cells[2] = "?";
      expect(solver.rowIsValid(grid, 0), isTrue);
    });

    test('columnIsValid', () {
      var grid = SudokuGrid(
          List.generate(SudokuGrid.size * SudokuGrid.size, (index) => "?"));
      expect(solver.columnIsValid(grid, 0), isTrue);
      for (var i = 0; i < SudokuGrid.size; i++) {
        grid.cells[i * SudokuGrid.size] = "${i + 1}";
      }
      expect(solver.columnIsValid(grid, 0), isTrue);
      grid.cells[9] = "1";
      expect(solver.columnIsValid(grid, 0), isFalse);
      grid.cells[9] = "?";
      expect(solver.columnIsValid(grid, 0), isTrue);
    });

    test('blockIsValid', () {
      var grid = SudokuGrid(
          List.generate(SudokuGrid.size * SudokuGrid.size, (index) => "?"));
      expect(solver.blockIsValid(grid, 1), isTrue);
      var blockIndexes = [3, 4, 5, 12, 13, 14, 21, 22, 23];
      for (var i = 0; i < SudokuGrid.size; i++) {
        grid.cells[blockIndexes[i]] = "${i + 1}";
      }
      expect(solver.blockIsValid(grid, 1), isTrue);
      grid.cells[3] = "9";
      expect(solver.blockIsValid(grid, 1), isFalse);
      grid.cells[3] = "?";
      expect(solver.blockIsValid(grid, 1), isTrue);
      blockIndexes = [60, 61, 62, 69, 70, 71, 78, 79, 80];
      for (var i = 0; i < SudokuGrid.size; i++) {
        grid.cells[blockIndexes[i]] = "${i + 1}";
      }
      expect(solver.blockIsValid(grid, 8), isTrue);
    });
  });
}
