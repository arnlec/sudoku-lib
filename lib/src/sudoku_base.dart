class SudokuBoard {
  static const int size=9;
  List<String> cells;

  SudokuBoard(this.cells);

  SudokuBoard copy(SudokuBoard original){
    return SudokuBoard([...cells]);
  }

  @override
  String toString() {
    var table = "";
    for (int i = 0; i < size; i++) {
      if (i % 3 == 0) {
        table += " --- --- --- --- --- --- --- --- ---\n";
      }
      table +=
          "| ${cells[i*size]}   ${cells[i*size + 1]}   ${cells[i*size + 2]} | ${cells[i*size + 3]} ";
      table +=
          "  ${cells[i*size + 4]}   ${cells[i*size + 5]} | ${cells[i*size + 6]}   ${cells[i*size + 7]} ";
      table += "  ${cells[i*size + 8]} | \n";
    }
    table += " --- --- --- --- --- --- --- --- ---";
    return table;
  }

  String getCell(int row,int column){
    return cells[row*SudokuBoard.size+column];
  }
  
  void setCell(int row, int column,String value){
    cells[row*SudokuBoard.size+column]=value;
  }
}

abstract class SudokuSolver {
  static const characters = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];

  SudokuBoard solve(SudokuBoard board);

  bool isValueInRow(SudokuBoard board,int row, String value){
    return getRow(board, row).contains(value);
  }

  bool isEmptyValue(SudokuBoard board,int row, int column){
    return !characters.contains(board.getCell(row, column));
  }

  bool isValueInColumn(SudokuBoard board, int column, String value){
    return getColumn(board, column).contains(value);
  }

  bool isValueInBlock(SudokuBoard board, int blockId, String value){
    return getBlock(board, blockId).contains(value);
  }

  bool isCorrectAt(SudokuBoard board, int row, int column, String value){
    var blockId = (row ~/ 3)*3 + column ~/ 3;
    return !isValueInBlock(board, blockId, value) &&
      !isValueInColumn(board, column, value) &&
      !isValueInRow(board, row, value); 
  }

  bool rowIsValid(SudokuBoard board, int i) {
    var cells = getRow(board, i);
    return valuesAreUniq(cells);
  }

  List<String> getRow(SudokuBoard board,int i){
    return board.cells.getRange(i * SudokuBoard.size, i * SudokuBoard.size + SudokuBoard.size -1).toList();
  }

  bool columnIsValid(SudokuBoard board, int i) {
    var cells = getColumn(board, i);
    return valuesAreUniq(cells);
  }

  List<String> getColumn(SudokuBoard board, int i){
    return List<int>.generate(SudokuBoard.size, (index) => index * SudokuBoard.size + i)
        .map((e) => board.cells[e])
        .toList();
  }

  bool blockIsValid(SudokuBoard board, int i) {
    var cells = getBlock(board, i);
    return valuesAreUniq(cells);
  }

  List<String> getBlock(SudokuBoard board, int i){
    var indexes = List<int>.generate(SudokuBoard.size,
        (idx) => ((i%3)*3+(i~/3)*27) +(SudokuBoard.size*(idx~/3))+(idx%3));
    return indexes.map((e) => board.cells[e])
        .toList();
  }

  bool boardIsCompleted(SudokuBoard board) {
    return board.cells
        .firstWhere((element) => !characters.contains(element),
            orElse: () => "")
        .isEmpty;
  }

  bool valuesAreUniq(List<String> cells) {
    var cellsNumber = cells.where((element) => characters.contains(element));
    var distinctValues = [
      ...{...cellsNumber}
    ];
    return cellsNumber.length == distinctValues.length;
  }
}

class NotResolvableException implements Exception {
  SudokuBoard board;
  NotResolvableException(this.board);
}

SudokuSolver getSudoSolver() {
  return RecursiveSudokuSolver();
}

class RecursiveSudokuSolver extends SudokuSolver {
  @override
  SudokuBoard solve(SudokuBoard board) {
    var copy = board.copy(board);
    for(int i=0;i<SudokuBoard.size;i++){
      for(int j=0;j<SudokuBoard.size;j++){
        if (isEmptyValue(board, i, j)){
          for(int idx = 0; idx < SudokuSolver.characters.length; idx++){
            final value = SudokuSolver.characters[idx];
            if (isCorrectAt(copy, i, j, value)){
              copy.setCell(i, j, value);
              try {
                return solve(copy);
              }
              catch(e){
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
