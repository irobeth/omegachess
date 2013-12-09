package net.omegachess.classes
{
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.utils.getTimer;
	
	import mx.collections.ArrayCollection;
	import mx.core.Container;
	
	import net.omegachess.classes.pieces.Hole;
	import net.omegachess.classes.pieces.King;
	import net.omegachess.classes.pieces.Piece;
	import net.omegachess.classes.pieces.Rook;
	import net.omegachess.components.Cell;
	import net.omegachess.events.CellSelectedEvent;
	import net.omegachess.populators.DefaultBoardPopulator;
	import net.omegachess.populators.IBoardPopulator;

	[RemoteClass]
	public class Board extends EventDispatcher
	{		
		private var whoseMove 				: Number = Piece.ALIGNMENT_WHITE;
		private var board 					: Array = new Array();		
		/**
		 * TODO: Remove this from Board, make a component which accepts a Board as a dataProvider
		 * and updates the cells it owns; Should stop us from having to rip off listeners every draw.		
		*/
		private var display 				: Container;
		
		private var _whiteKing 				: Cell = null;
		private var _blackKing 				: Cell = null;
		
		private var _halfMove 				: Number = 0;
		private var _move 					: Number = 1;
		
		private var _enPassantTargets 		: ArrayCollection = null;
		private var _enPassantPawn			: Cell = null;
		
		private var _capturedPieces			: ArrayCollection = new ArrayCollection();
		
		private var _whiteCastleKingside 	: Boolean = true;
		private var _whiteCastleQueenside 	: Boolean = true;
		private var _blackCastleKingside 	: Boolean = true;
		private var _blackCastleQueenside 	: Boolean = true;					
				
		public function Board(target:IEventDispatcher=null)  {					
			super(target);			
		}
			
		public function draw() : void {					
			//so we only draw when we have a display to render to.
			//this is pretty expensive, too
			/**
			 * TODO: Find a better way
			 * */
			if(display != null) {				
				display.removeAllChildren();
				//reverse array is faster for some reason
				for(var i : Number = board.length - 1; i >= 0; i--) {
					var c : Cell = (board[i] as Cell);
						c.removeEventListener(CellSelectedEvent.CELL_SELECTED, cellSelectedHandler);					
						c.addEventListener(CellSelectedEvent.CELL_SELECTED, cellSelectedHandler);
					display.addChild(c);
						c.draw();					
				}			
			}
		}
		
		/**
		 * Relay the selected cell out to the controller.
		 * */
		public function cellSelectedHandler( event : CellSelectedEvent ) : void {
			Debug.show(Debug.INFO, "Board::cellSelectedHandler", "");
			var cell : Cell = event.cell as Cell;					
			
			var cse : CellSelectedEvent = new CellSelectedEvent(cell, CellSelectedEvent.CELL_SELECTED)					
			dispatchEvent(cse);			
		} //function cellSelectedHandler				
		
		public function getPiecesBitboard() : Bitboard {			
			var bitboard : Bitboard = new Bitboard();
			
			for(var i : Number = 0; i < 12; i ++) {				
				for( var j : Number = 0; j < 12; j ++) {														
					bitboard.setBitAt(getPieceAt(i, j).alignment, i, j);					
				}
			}

			return bitboard;
		} //function getPiecesBitboard
		
		public function getAlignmentBitboard( alignment : Number ) : Bitboard {
			
			var bitboard : Bitboard = new Bitboard();
			
			for(var i : Number = 0; i < 12; i ++) {				
				for( var j : Number = 0; j < 12; j ++) {
					if(getPieceAt(i, j).alignment == alignment) {
						bitboard.setBitAt(1, i, j);				
					}
				}
			}
			
			return bitboard;			
		} //function getAlignmentBitboard
		
		public function getAlignmentThreatBitboard( alignment : Number ) : Bitboard {
			var bitboard : Bitboard = new Bitboard();
			
			for(var i : Number = 0; i < 12; i ++) {				
				for( var j : Number = 0; j < 12; j ++) {
					if(getPieceAt(i, j).alignment == alignment) {
						bitboard = Bitboard.merge(
							bitboard, 
							getPieceAt(i, j).getCaptureBitboard(
								this.getPiecesBitboard()
							)
						);
					}
				}
			}
			Debug.show(Debug.VERBOSE_3, "getAlignmentThreatBitboard", bitboard);
			
			return bitboard;		
		}//function getAlignmentThreatBitboard
		
		
		public function getPieceAt( rank : Number, file : Number ) : Piece {
			return (board[rank * 12 + file] as Cell).piece;
		}
		
		public function setPieceAt( piece : Piece, rank : Number, file : Number ) : void {
			(board[rank * 12 + file] as Cell).piece = piece;
		}				
		
		public function getCellAt( rank : Number, file : Number ) : Cell {
			return (board[rank * 12 + file] as Cell);
		}
		
		public function setCellAt( cell : Cell, rank : Number, file : Number ) : void {
			board[rank * 12 + file] = cell;
		}		
		
		public function getCellsFromBitboard( bitboard : Bitboard ) : Array {
			var r : Array = new Array();
			
			for(var i : Number = 0; i < 12; i ++) {
				for(var j : Number = 0; j < 12; j++) {
					if(bitboard.getBitAt(i, j) != 0) {
						r.push( board[i*12 + j] );
					}
				}
			}
			
			return r;
		}
		
		public function toOCPN() : String {
			
			var ocpn : String = "";
			
			var counter : Number = 0;
			
			for(var r : Number = 0; r < 12; r ++) {
				for(var f : Number = 0; f < 12; f++) {					
										
					var piece : Piece = (board[r*12 + f] as Cell).piece;					
					var acn : String = piece.acn();
					
					if((r == 0 && f != 0 && f != 11) || (r == 11 && f != 0 && f != 11) || (f == 0 && r != 0 && r != 11) || (f == 11 && r != 0 && r != 11)) {
						//don't include board holes in OCPN
					} else {						
						if(piece.acn() == "0") {
							counter ++;
						} else {
							if(counter != 0) {
								ocpn += counter.toString(16);
								counter = 0;
							}
							ocpn = ocpn + acn;
						}						
					} //else not hole
			
				}
				
				if(counter != 0) {
					ocpn += counter.toString(16);
					counter = 0;	
				}
				
				if(r != 11) {
					ocpn += "/"
				}
							
			}			

			ocpn += "/";
			//scan for rooks and kings, set 1 or 0 for each firstmove bit			
			for(var r : Number = 0; r < 12; r ++) {
				for(var f : Number = 0; f < 12; f++) {					
					var piece : Piece = (board[r*12 + f] as Cell).piece;
					if(piece is King || piece is Rook) {
						ocpn += piece.hasMoved ? "0" : "1";
					}
				}
			}
			
			return ocpn;
		} //function OCPN

		public function toggleMovingAlignment() : Number {
			Debug.show(Debug.INFO, "board:toggleMovingAlignment", Piece.alignmentToString(whoseMove) + " to move.");
			if(whoseMove == Piece.ALIGNMENT_BLACK) {
				trace("Black to move, now white to move.");
				whoseMove = Piece.ALIGNMENT_WHITE;
				return whoseMove;
			} else if(whoseMove == Piece.ALIGNMENT_WHITE) {
				trace("White to move, now black to move.");
				whoseMove = Piece.ALIGNMENT_BLACK;
				return whoseMove;
			} else {
				throw new IllegalOperationError("Toggled moving alignment when either NONE or HOLE could move.");
			}
		}
		
		public function copy() : Board {
			var workBoard : Board = new Board();
			
			for(var i : Number = 0; i < 12; i ++) {
				for(var j : Number = 0; j < 12; j++) {
					workBoard.setCellAt(
						getCellAt(i,j).copy(),
						i,
						j
					);
				}
			}
			
			workBoard._enPassantTargets = new ArrayCollection();
			
			for each(var t : Cell in _enPassantTargets) {
				workBoard._enPassantTargets.addItem(t.copy());
			}
			if(enPassantPawn != null)
				workBoard.enPassantPawn				= workBoard.getCellAt(_enPassantPawn.rank, _enPassantPawn.file);
			
			workBoard.whoseMove					= whoseMove;
			workBoard._blackKing				= workBoard.getCellAt(_blackKing.rank, _blackKing.file);
			workBoard._whiteKing				= workBoard.getCellAt(_whiteKing.rank, _whiteKing.file);
			workBoard._blackCastleKingside 		= _blackCastleKingside == true;
			workBoard._blackCastleQueenside 	= _blackCastleQueenside == true;
			workBoard._whiteCastleKingside 		= _whiteCastleKingside == true;
			workBoard._whiteCastleQueenside 	= _whiteCastleQueenside == true;			
			workBoard._halfMove 				= _halfMove + 0;
			workBoard._move 					= _move + 0;
			workBoard.display					= display;
			
			return workBoard;
		}
		
		
		public function get whiteCanCastleKingside() : Boolean {
			return _whiteCastleKingside;
		}
		
		public function set whiteCanCastleKingside( can : Boolean ) : void {
			_whiteCastleKingside = can;
		}
		
		public function get whiteCanCastleQueenside() : Boolean {
			return _whiteCastleQueenside;
		}
		
		public function set whiteCanCastleQueenside( can : Boolean ) : void {
			_whiteCastleQueenside = can;
		}
		
		public function get blackCanCastleKingside() : Boolean {
			return _blackCastleKingside;
		}
		
		public function set blackCanCastleKingside( can : Boolean ) : void {
			_blackCastleKingside = can;
		}
		
		public function get blackCanCastleQueenside() : Boolean {
			return _blackCastleQueenside;
		}
		
		public function set blackCanCastleQueenside( can : Boolean ) : void {
			_blackCastleQueenside = can;
		}
		
		public function get blackKing() : Cell {
			return _blackKing;
		}
		
		public function get whiteKing() : Cell {
			return _whiteKing;	
		}
		
		public function set blackKing(cell : Cell) : void {
			_blackKing = cell;
		}
		
		public function set whiteKing(cell : Cell) : void {
			_whiteKing = cell;		
		}
		
		public function get capturedPieces() : ArrayCollection {
			return _capturedPieces;
		}
		
		public function set capturedPieces( a : ArrayCollection ) : void {
			_capturedPieces = a;
		}
		
		public function get enPassantTargets() : ArrayCollection {
			return _enPassantTargets;
		}
		
		public function set enPassantTargets( t : ArrayCollection ) : void {
			_enPassantTargets = t;
		}
		
		public function set enPassantPawn( c : Cell ) : void {
			_enPassantPawn = c;
		}
		
		public function get enPassantPawn() : Cell {
			return _enPassantPawn;
		}
		
		public function get movingAlignment() : Number {
			Debug.show(Debug.FUNCTION, "Board::get:MovingAlignment", whoseMove);
			return whoseMove;	
		}
		
		public function set movingAlignment( alignment : Number ) : void {
			Debug.show(Debug.FUNCTION, "Board::set:MovingAlignment", alignment);
			whoseMove = alignment;
		}
		
		public function get enemyAlignment() : Number {
			if(whoseMove == Piece.ALIGNMENT_WHITE) { 
				return Piece.ALIGNMENT_BLACK;
			} else if(whoseMove == Piece.ALIGNMENT_BLACK) {
				return Piece.ALIGNMENT_WHITE;
			} else {
				throw new Error("Somehow neither player is moving.");
			}			
		}
	}//class Board	
}//package