package net.omegachess.rules
{
	import net.omegachess.classes.Board;

	public interface IOmegaChessRule {
		function satisfies(board : Board) : Boolean;
	}
}