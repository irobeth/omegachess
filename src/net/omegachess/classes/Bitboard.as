package net.omegachess.classes {
	
	import mx.utils.ObjectUtil;
	
	import net.omegachess.classes.pieces.Piece;
	
	public class Bitboard extends Object
	{
		public var bits : Array;
		
		public function Bitboard() {
			super();
			
			bits = new Array();
			
			for(var i : Number = 0; i < 144; i ++) 
				bits.push(0);
			
		}
		
		/**
		 * performs a bitwise OR on each member of the board
		 * */
		public static function merge( b1 : Bitboard, b2 : Bitboard ) : Bitboard {
			var bitboard : Bitboard = new Bitboard();
							
			for(var i : Number = 0; i < 12; i ++) {
				for(var j : Number = 0; j < 12; j++) {
					if(b1.getBitAt(i, j) != 0 || b2.getBitAt(i, j) != 0) {
						bitboard.setBitAt(
							1,
							i,
							j
						);
					}
				}
			}
			
			return bitboard;
		}
		
		/**
		 * performs a bitwise AND on each member of the board
		 * */
		public static function and( b1 : Bitboard, b2 : Bitboard ) : Bitboard {
			var bitboard : Bitboard = new Bitboard();
			
			for(var i : Number = 0; i < 12; i ++) {
				for(var j : Number = 0; j < 12; j++) {
					if(b1.getBitAt(i, j) != 0 && b2.getBitAt(i, j) != 0) { 
						bitboard.setBitAt(
							1, i, j
						);
					}
				}
			}
			
			return bitboard;			
		}		
		
		/**
		 * the resulting bitboard is true only when this bitboard is true and the other bitboard is false
		 * */
		public static function exclude( b1 : Bitboard, b2 : Bitboard ) : Bitboard {
			var bitboard : Bitboard = new Bitboard();
			
			for(var i : Number = 0; i < 12; i ++) {
				for(var j : Number = 0; j < 12; j++) {
					bitboard.setBitAt(
						(b1.getBitAt(i, j) != 0) && (b2.getBitAt(i, j) == 0) ? 1 : 0,
						i,
						j
					);
				}
			}
			
			return bitboard;
		}
		
		public function silentSetBitAt( value : Number, rank : Number, file : Number ) : void {
			//the access is r*12 + f
			if(rank < 12 && rank >= 0 && file < 12 && file >= 0) {
				bits[rank * 12 + file] = value;
			} else {
				//throw new Error(rank + ":" + file + " is out of range.");		
			}
		}		
		
		public function setBitAt( value : Number, rank : Number, file : Number ) : void {
			//the access is r*12 + f
			if(rank < 12 && rank >= 0 && file < 12 && file >= 0) {
				bits[rank * 12 + file] = value;
			} else {
				throw new Error(rank + ":" + file + " is out of range.");		
			}
		}
		
		public function getBitAt(rank : Number, file : Number) : Number {
			if(rank < 12 && rank >= 0 && file < 12 && file >=0) {
				return bits[rank * 12 + file];
			} else {
				throw new Error(rank + ":" + file + " is out of range.");
			}
		}
		
		public function silentGetBitAt(rank : Number, file : Number) : Number {
			if(rank < 12 && rank >= 0 && file < 12 && file >=0) {
				return bits[rank * 12 + file];
			} else {
				return Piece.ALIGNMENT_HOLE;
			}
		}
		
		public function toString() : String {
			var r : String = "";
			
			for(var i : Number = 0; i < 12; i ++) {				
				for( var j : Number = 0; j < 12; j ++) {
					r = r + bits[i * 12 + j].toString() + " ";
				}		
				r = r + "\n";
			}
			
			return r;
		}
	}
}