package net.omegachess.controllers
{
	import flash.utils.getTimer;
	
	import mx.controls.Alert;
	import mx.core.Application;
	import mx.core.WindowedApplication;
	
	import net.omegachess.classes.Board;
	import net.omegachess.classes.pieces.Piece;
	import net.omegachess.controllers.movement.IMovementController;
	import net.omegachess.intents.Intent;
	import net.omegachess.intents.IntentRegistry;
	import net.omegachess.models.GameModel;
	import net.omegachess.moves.movetypes.Move;
	import net.omegachess.moves.movetypes.Promotion;
	import net.omegachess.rules.Check;
	import net.omegachess.rules.Checkmate;
	import net.omegachess.rules.PromotionTime;

	public class GameController extends Object
	{
		private var _model : GameModel;
		private var whiteMovementController : IMovementController;
		private var blackMovementController : IMovementController;

		public function GameController(wmc : IMovementController, bmc : IMovementController) {
			super();
							
			whiteMovementController = wmc;
			blackMovementController = bmc;
			
			IntentRegistry.registerIntentHandler(Intent.INTENT_TYPE_MOVE_DECIDED, moveDecidedHandler, false);
		}
		
		public function set model( m : GameModel ) : void {
			_model = m;
			
			var boardChangedIntent : Intent 	= new Intent(this);
				boardChangedIntent.type 		= Intent.INTENT_TYPE_BOARD_CHANGED;
				boardChangedIntent.data			= m.board;
				
			IntentRegistry.handleIntent(boardChangedIntent);
		}
		
		public function init() : void {
			new Assertion(_model != null);
			trace("GC Init");
			
			var targetMC : IMovementController = getAlignmentMovementController(_model.board.movingAlignment);
				targetMC.init(_model.board);
		}
		
		private function getAlignmentMovementController( alignment : Number ) : IMovementController {
			if(alignment == Piece.ALIGNMENT_WHITE) {
				return whiteMovementController;
			} else {
				return blackMovementController;
			}
		}
		
		private function moveDecidedHandler( i : Intent ) : void {
			trace("MoveDecidedHandler");
			
			var m : Move = i.data as Move;
				_model.applyMove(m);
			
			var msi : Intent = new Intent(m);
				msi.data = m;
				msi.type = Intent.INTENT_TYPE_SAVE_MOVE;
				
			IntentRegistry.handleIntent(msi);				
				
			finalizeTurn();
			
			
			Debug.show(Debug.INFO, "GC:aMH", "Finishing the move at " + getTimer());
		}		
		
		private function finalizeTurn() : void {
			var targetMC : IMovementController = getAlignmentMovementController(_model.board.movingAlignment);
			
			var check : Check = new Check();
			if(check.satisfies(_model.board)) {
				var checkmate : Checkmate = new Checkmate();
				if(checkmate.satisfies(_model.board)) {
					if(targetMC.hasVisualNotifications())
						Alert.show("Checkmate!", Piece.alignmentToString(_model.board.movingAlignment) + " to move", Alert.OK, mx.core.Application.application as WindowedApplication);
					
					return; //stops any more moves
				} else {
					if(targetMC.hasVisualNotifications())
						Alert.show("Check", Piece.alignmentToString(_model.board.movingAlignment) + " to move", Alert.OK, mx.core.Application.application as WindowedApplication);
				}//if is checkmate										
			}//if is check
			
			targetMC.init(_model.board);
		}
	}
}