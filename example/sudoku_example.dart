import 'package:sudoku/sudoku.dart';

void main() {
  var solver = getSudokuSolver();
  var validator = SudokuGridValidator();
  var grid = SudokuGrid([
    '2',
    '?',
    '7',
    '?',
    '?',
    '?',
    '?',
    '?',
    '?',
    '?',
    '?',
    '5',
    '6',
    '?',
    '7',
    '?',
    '?',
    '4',
    '8',
    '?',
    '?',
    '?',
    '?',
    '?',
    '1',
    '?',
    '?',
    '?',
    '1',
    '?',
    '?',
    '7',
    '9',
    '6',
    '?',
    '8',
    '?',
    '5',
    '?',
    '?',
    '6',
    '2',
    '?',
    '4',
    '?',
    '?',
    '?',
    '?',
    '5',
    '3',
    '?',
    '?',
    '?',
    '?',
    '7',
    '?',
    '?',
    '?',
    '?',
    '5',
    '?',
    '?',
    '?',
    '?',
    '?',
    '?',
    '?',
    '2',
    '6',
    '8',
    '?',
    '5',
    '?',
    '?',
    '6',
    '8',
    '?',
    '1',
    '4',
    '?',
    '?'
  ]);
    print("Try to resolve");
    print(grid);
    if (validator.isValid(grid)){
      try {
        var solution = solver.solve(grid);
        print("Solution is:");
        print(solution);
        print(validator.isSucceed(solution));
      } on NotResolvableException catch (e) {
        print("Can't resolve the grid");
        print(e.grid);
      }
    }
    else{
      print("grid is not value");
      print(grid);
    }
}
