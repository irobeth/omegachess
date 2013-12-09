package net.omegachess.controllers.movement
{
	import flash.events.ProgressEvent;
	import flash.utils.getTimer;
	
	import mx.controls.ProgressBar;
	import mx.core.Application;
	import mx.core.Window;
	import mx.core.WindowedApplication;
	import mx.managers.PopUpManager;
	
	import net.omegachess.classes.Board;
	import net.omegachess.classes.pieces.Piece;
	import net.omegachess.components.Cell;
	import net.omegachess.controllers.PromotionController;
	import net.omegachess.intents.Intent;
	import net.omegachess.intents.IntentRegistry;
	import net.omegachess.moves.MoveFactory;
	import net.omegachess.moves.MoveGeneratorFactory;
	import net.omegachess.moves.generators.IMoveGenerator;
	import net.omegachess.moves.movetypes.Move;
	import net.omegachess.moves.movetypes.Promotion;
	import net.omegachess.rules.LeavesMeInCheck;
	import net.omegachess.rules.PromotionTime;
	import net.omegachess.tasks.Task;
	import net.omegachess.tasks.TaskEvent;
	
	public class HumanMovementController implements IMovementController
	{
		//mx.core.FlexGlobals.topLevelApplication

		private var board : Board;
		//we search this later
		private var availableMoves : Array = new Array();
		
		private var calculationBar : ProgressBar;
		
		public function HumanMovementController() {
			
		}
		
		/**
		 * Should be called when you first start a turn and you a are waiting for the accepted move or sometihng,
		 * I don't know, if this is the AI it'll signify to start the search and dispatch an intent when you've finsihed
		 * */
		public function init(b:Board) : void {
			
			board = b;
			
			//init is called at the start of our turn?
			//register an expungable intent to cellSelectedHandler
			IntentRegistry.registerIntentHandler(Intent.INTENT_TYPE_CELL_SELECTED, cellSelectedHandler, true);
			//oh hey, expungable intents work well here			
		}
		
		public function hasVisualNotifications() : Boolean {
			return true;
		}
		
		private function cellSelectedHandler( i : Intent ) : void {
			Debug.show(Debug.FUNCTION, "HumanController:cellSellectedHandler", "");
			
			
			//determine if this is our piece to move / has legal moves
			var cell : Cell = i.data as Cell;			
			if(cell.piece.alignment == board.movingAlignment) {
				availableMoves = MoveFactory.getMoves(cell, board);			
				
				if(availableMoves.length == 0) {
					Debug.show(Debug.INFO, "PVPGameController:sSP", "No available moves");	
					IntentRegistry.registerIntentHandler(Intent.INTENT_TYPE_CELL_SELECTED, cellSelectedHandler, true);
				} else {										
					//a task that checks one move per frame
					var task : Task = new Task();
						task.job = moveCheckTask;						
						task.params = [availableMoves, 0, task];
					
					//since this just looks like a flicker when it takes one or two frames,
					//we can limit the progres bar to showing up only when it's noticable
					(availableMoves.length > 5) ? this.displayProgress(task) : void;
					
					
					task.addEventListener(TaskEvent.COMPLETE, drawLegalMoves_TaskHandler);
					
					var tsi : Intent = new Intent(this);
						tsi.type = Intent.INTENT_TYPE_START_TASK;
						tsi.data = task;
						
					IntentRegistry.handleIntent(tsi);
				}//if available moves length > 0
			} else { //if alignment
				//we expunged the intent by getting here so we need to re-register for it
				IntentRegistry.registerIntentHandler(Intent.INTENT_TYPE_CELL_SELECTED, cellSelectedHandler, true);
			}
		}

		private function drawLegalMoves_TaskHandler( event : TaskEvent ) : void {
			
			PopUpManager.removePopUp(this.calculationBar);
			
			var scannedMoves : Array = event.data as Array;
			availableMoves = new Array();
			
			for each(var m : Move in scannedMoves) {
				if(m != null) {
					availableMoves.push(m);
				} //null moves represented illegal moves	
			}
			
			if(availableMoves.length == 0) {
				trace("No legal moves");
				IntentRegistry.registerIntentHandler(Intent.INTENT_TYPE_CELL_SELECTED, cellSelectedHandler, true);
			} else {
				//drawMoves(availableMoves);
				var dmi : Intent = new Intent(event.task);
					dmi.type = Intent.INTENT_TYPE_DRAW_MOVES;
					dmi.data = availableMoves;
				
				IntentRegistry.handleIntent(dmi);
				//state = STATE_ACCEPT_MOVE;
				IntentRegistry.registerIntentHandler(Intent.INTENT_TYPE_CELL_SELECTED, moveSelectedHandler, true);
			}
			
		}
		
		private function handleNoMoves() : void {
			//we need the game state back to STATE_SELECT somehow...
			
		}
		
		private function moveSelectedHandler( i : Intent ) : void {
			Debug.show(Debug.FUNCTION, "PVPGameController::acceptMoveHandler", "");									
			
			var selectedCell : Cell = i.data as Cell;
			var found : Boolean = false;
			
			Debug.show(Debug.VERBOSE_2, "GC:aMH", "Selected cell is " + selectedCell.toString());
			
			Debug.show(Debug.VERBOSE_2, "GC:aMH", "Beginning scan for selected cell in moves");
			
			for each(var mov : Move in availableMoves) {
				Debug.show(Debug.VERBOSE_3, "GC:aMH", "Looking at " + mov.destination.toString());
				
				if(mov.destination.rank == selectedCell.rank && mov.destination.file == selectedCell.file) {
					trace("Found");
					found = true;
					break;					
				}
			}
			
			if(found) {
				this.handleChosenMove(mov);
			} else {
				Debug.show(Debug.INFO, "PVPGameController::aMH", "Wrong cell selected, dropping back to STATE_SELECT");
				IntentRegistry.registerIntentHandler(Intent.INTENT_TYPE_CELL_SELECTED, cellSelectedHandler, true);
				//I can trigger a board redraw with this I think
				var bci : Intent = new Intent(this);
					bci.data = board;
					bci.type = Intent.INTENT_TYPE_BOARD_CHANGED;
					
				IntentRegistry.handleIntent(bci);				
			}//if not found
		}
		
		private function handleChosenMove(mov : Move) : void {
			var testBoard = mov.apply(board);
			var promotionTime : PromotionTime = new PromotionTime();
			var self : HumanMovementController = this;
			if(promotionTime.satisfies(testBoard)) {
				trace("BOARD WOULD PROMOTE");
				IntentRegistry.registerIntentHandler(Intent.INTENT_TYPE_PROMOTION, 
					function(intent : Intent) : void {
						
						//promotionController will replace the piece with their choice...
						trace("Captured promotion intent");
						testBoard.getCellAt(
							mov.destination.rank, 
							mov.destination.file
						).piece = intent.data as Piece;
						
						//here we produce the promotion to capture in moveReplay
						var pro : Promotion = new Promotion();
							pro.source = mov.source;
							pro.destination = mov.destination;
							pro.data = intent.data;
						
						self.sendMoveIntent(pro);
						Debug.show(Debug.DUMP, "Promotion", pro);
					}, true, 1
				);
				
				var promotionController : PromotionController = new PromotionController();
				promotionController.ShowPromotionDialogue(
					testBoard.getCellAt(
						mov.destination.rank, 
						mov.destination.file
					)
				);
				
				trace("BOARD DID PROMOTE");
			} else {
				//mov is our chosen move
				this.sendMoveIntent(mov);
			}
		}
		
		private function sendMoveIntent(mov : Move) : void {
			var mdi : Intent = new Intent(this);
				mdi.type = Intent.INTENT_TYPE_MOVE_DECIDED;
				mdi.data = mov;
			
			IntentRegistry.handleIntent(mdi);
		}
		
		private function moveCheckTask(moves : Array, index : Number, task : Task) : void {
			
			var check : LeavesMeInCheck = new LeavesMeInCheck();
			var testMove : Move = moves[index] as Move;
			var testBoard : Board = testMove.apply(board);
			
			Debug.show(Debug.INFO, "Task job", "Testing move index " + index);
			
			if(check.satisfies(testBoard)) {
				Debug.show(Debug.VERBOSE_3, "Task job", testMove.toACN() + " is unsafe");
				moves[index] = null; //mark unsafe as null and we'll throw them out when we're done
			}
			
			task.params = [moves, ++index, task];
			
			if(index < moves.length) {
				var pe : ProgressEvent = new ProgressEvent(ProgressEvent.PROGRESS, false, false, index, moves.length);
					task.dispatchEvent(pe);				
				task.callLater(task.job, task.params);
			} else {
				
				var tce : TaskEvent = new TaskEvent(TaskEvent.COMPLETE);
					tce.task = task;
					tce.data = moves;
				task.dispatchEvent(tce);
				
			}
		}
		
		private function displayProgress(task : Task) : void {
			calculationBar = new ProgressBar();
			calculationBar.width = 500;
			calculationBar.mode = "manual";
			calculationBar.labelPlacement = "center";
			calculationBar.label = "Calculating Moves";
			
			task.addEventListener(ProgressEvent.PROGRESS, function(event : ProgressEvent) : void {
				calculationBar.setProgress(event.bytesLoaded, event.bytesTotal);							
			});
			
			PopUpManager.addPopUp(calculationBar, mx.core.Application.application as WindowedApplication, true);
			PopUpManager.centerPopUp(calculationBar);	
		}
	}
}