package net.omegachess.controllers.movement
{
	import net.omegachess.classes.Board;

	public interface IMovementController
	{		
		function init( board : Board ) : void;
		function hasVisualNotifications() : Boolean;
	}
}