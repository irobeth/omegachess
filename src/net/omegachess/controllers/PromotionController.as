package net.omegachess.controllers
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import mx.containers.Panel;
	import mx.core.Application;
	import mx.core.Container;
	import mx.core.WindowedApplication;
	import mx.managers.PopUpManager;
	
	import net.omegachess.classes.pieces.Bishop;
	import net.omegachess.classes.pieces.Champion;
	import net.omegachess.classes.pieces.Knight;
	import net.omegachess.classes.pieces.Pawn;
	import net.omegachess.classes.pieces.Piece;
	import net.omegachess.classes.pieces.Queen;
	import net.omegachess.classes.pieces.Rook;
	import net.omegachess.classes.pieces.Wizard;
	import net.omegachess.components.Cell;
	import net.omegachess.events.CellSelectedEvent;
	import net.omegachess.intents.Intent;
	import net.omegachess.intents.IntentRegistry;
	
	public class PromotionController extends EventDispatcher
	{
		private var promotionTarget : Cell;
		public function PromotionController(target:IEventDispatcher=null)
		{
			super(target);
		}
		
		public function ShowPromotionDialogue(cell : Cell) : void {
			Debug.show(Debug.INFO, "ShowPromotion", cell.toString());
			new Assertion(cell.piece is Pawn);
			//bishop
			//knight
			//rook
			//champion
			//wizard
			//queen
			//6 cells, 25px padding on sides?
			var pieces : Array = [
				Bishop,
				Knight,
				Rook,
				Champion,
				Wizard,
				Queen	
			];
			
			var p : Panel 	= new Panel();
				p.setStyle("borderStyle", "solid");
				p.width 	= cell.width * 6 + 70;
				p.height 	= cell.height + 50;
				p.title		= "Promote to:";
				p.layout	= "horizontal";
				
			var index : Number = 0;
			for each(var pieceClass : Class in pieces) {
				var c : Cell = new Cell();
					c.rank = 0;
					c.file = index++;
					c.piece = new pieceClass();
					c.piece.alignment = cell.piece.alignment;
					c.setStyle("borderStyle", "none");
					c.draw("#FFFFFF");
					c.addEventListener(CellSelectedEvent.CELL_SELECTED, function(event : CellSelectedEvent) : void {
						var cell : Cell = event.cell;
						var piece : Piece = cell.piece;
						PopUpManager.removePopUp(p);
						var i : Intent = new Intent(cell);
							i.type = Intent.INTENT_TYPE_PROMOTION;
							i.data = piece;
						IntentRegistry.handleIntent(i);						
					});
				p.addChild(c);		
			}	
			
			PopUpManager.addPopUp(p, mx.core.Application.application as WindowedApplication, true);
			PopUpManager.centerPopUp(p);
		}
	}
}