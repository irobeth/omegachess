package net.omegachess.populators
{
	import net.omegachess.classes.Board;
	import net.omegachess.classes.pieces.Piece;
	import net.omegachess.components.Cell;

	public interface IBoardPopulator {
		function getCell(cell : Cell) : Piece;
		function populate(board : Board) : void;
	}
}