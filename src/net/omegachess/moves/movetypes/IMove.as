package net.omegachess.moves.movetypes
{
	import net.omegachess.classes.Board;

	public interface IMove
	{
		function apply( board : Board ) : Board;
		function toACN() : String;
	}
}