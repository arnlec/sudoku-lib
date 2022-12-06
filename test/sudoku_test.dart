import 'package:sudoku/sudoku.dart';
import 'package:test/test.dart';

void main() {

  group('SudokuBoard',(){
    final board = SudokuBoard(List.generate(SudokuBoard.size*SudokuBoard.size, (index) => "${(index % SudokuBoard.size)+1}"));

    test('print',(){
      print(board.toString());
    });

  });


  group('SudokuSolver', () {
    final solver = getSudoSolver();

    setUp(() {
      // Additional setup goes here.
    });

    test('solve',(){  
      var board = SudokuBoard(List.generate(SudokuBoard.size*SudokuBoard.size, (index) => "?"));
      board.setCell(0,0, '9');
      try{
        var result = solver.solve(board);   
        expect(result.getCell(0, 0),'9');
        print(result.toString()); 
      }
      on NotResolvableException catch(e){
        print(e.board.toString());
        fail("Not resolvable board");
      }
    });

    test('isEmptyValye',(){
      var board = SudokuBoard(List.generate(SudokuBoard.size*SudokuBoard.size, (index) => "?"));
      expect(solver.isEmptyValue(board, 1, 3), isTrue);
      board.setCell(1, 3, '1');
      expect(solver.isEmptyValue(board, 1, 3), isFalse);
    });

    test('isValueInRow',(){
      var board = SudokuBoard(List.generate(SudokuBoard.size*SudokuBoard.size, (index) => "?"));
      expect(solver.isValueInRow(board, 0, '1'), isFalse);
      board.setCell(0, 3, '1');
      expect(solver.isValueInRow(board, 0, '1'), isTrue);
      expect(solver.isValueInRow(board, 1, '1'), isFalse);
    });

    test('isValueInColumn',(){
      var board = SudokuBoard(List.generate(SudokuBoard.size*SudokuBoard.size, (index) => "?"));
      expect(solver.isValueInColumn(board, 1, '1'), isFalse);
      board.setCell(2, 1, '1');
      expect(solver.isValueInColumn(board, 1, '1'), isTrue);
      expect(solver.isValueInColumn(board, 2, '1'), isFalse);
    });

    test('isValueInBlock',(){
      var board = SudokuBoard(List.generate(SudokuBoard.size*SudokuBoard.size, (index) => "?"));
      expect(solver.isValueInBlock(board, 1, '1'), isFalse);
      board.setCell(1, 3, '1');
      expect(solver.isValueInBlock(board, 1, '1'), isTrue);
      expect(solver.isValueInBlock(board, 2, '1'), isFalse);
    });

    test('boardIsCompleted', () {
      var board = SudokuBoard(List.generate(SudokuBoard.size*SudokuBoard.size, (index) => "${(index % SudokuBoard.size)+1}"));
      expect(solver.boardIsCompleted(board), isTrue);
      board.cells[SudokuBoard.size]="?";
      expect(solver.boardIsCompleted(board), isFalse);
    });

    test('rowIsValid',(){
      var board = SudokuBoard(List.generate(SudokuBoard.size*SudokuBoard.size, (index) => "?"));
      expect(solver.rowIsValid(board,0),isTrue);
      for(var i=0;i<SudokuBoard.size; i++) {
        board.cells[i]="${i+1}";
      }
      expect(solver.rowIsValid(board, 0), isTrue);
      board.cells[1]="1";
      expect(solver.rowIsValid(board, 0),isFalse);
      board.cells[1]="?";
      expect(solver.rowIsValid(board, 0),isTrue);
      board.cells[2]="?";
      expect(solver.rowIsValid(board, 0),isTrue);
    });

    test('columnIsValid',(){
      var board = SudokuBoard(List.generate(SudokuBoard.size*SudokuBoard.size, (index) => "?"));
      expect(solver.columnIsValid(board,0),isTrue);
      for(var i=0;i<SudokuBoard.size;i++){
        board.cells[i*SudokuBoard.size]="${i+1}";
      }
      expect(solver.columnIsValid(board,0),isTrue);
      board.cells[9]="1";
      expect(solver.columnIsValid(board,0),isFalse);
      board.cells[9]="?";
      expect(solver.columnIsValid(board,0),isTrue);
    });

    test('blockIsValid',(){
      var board = SudokuBoard(List.generate(SudokuBoard.size*SudokuBoard.size, (index) => "?"));
      expect(solver.blockIsValid(board,1),isTrue); 
      var blockIndexes = [3,4,5,12,13,14,21,22,23];
      for (var i=0;i<SudokuBoard.size;i++){
        board.cells[blockIndexes[i]]="${i+1}";      
      }
      expect(solver.blockIsValid(board,1),isTrue);
      board.cells[3]="9";
      expect(solver.blockIsValid(board,1),isFalse);
      board.cells[3]="?";
      expect(solver.blockIsValid(board,1),isTrue);
      blockIndexes = [60,61,62,69,70,71,78,79,80];
      for (var i=0;i<SudokuBoard.size;i++){
        board.cells[blockIndexes[i]]="${i+1}";      
      }
      expect(solver.blockIsValid(board,8),isTrue);
    });
  });
}
