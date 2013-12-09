package net.omegachess.moves.movetypes
{
	import flash.errors.IllegalOperationError;
	
	import net.omegachess.classes.Board;
	import net.omegachess.components.Cell;

	public class Move implements IMove
	{
		protected var _source 		: Cell;
		protected var _destination 	: Cell;
		protected var _data			: Object;
		public function Move(){}
		
		public function set source( cell : Cell ) : void {
			_source = cell.copy();
		}
		
		public function get source() : Cell {
			return _source;
		}
		
		public function set destination( cell : Cell) : void {
			_destination = cell.copy();
		}
		
		public function get destination() : Cell {
			return _destination;
		}
		
		public function get data() : Object {
			return _data;
		}
		
		public function set data(d : Object) : void {
			_data = d;
		}
		
		public function apply( board : Board ) : Board {
			throw new IllegalOperationError("Move.apply requires that it be overridden by a subclass of Move");
		}
		
		public function toACN() : String {
			throw new IllegalOperationError("Move.toACN requires that it be overridden by a subclass of Move");
		}
	}
}