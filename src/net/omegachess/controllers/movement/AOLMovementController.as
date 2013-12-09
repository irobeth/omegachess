package net.omegachess.controllers.movement
{
	import com.aol.api.wim.Session;
	import com.aol.api.wim.data.User;
	import com.aol.api.wim.data.types.SessionState;
	import com.aol.api.wim.events.IMEvent;
	import com.aol.api.wim.events.SessionEvent;
	import com.hurlant.crypto.hash.SHA1;
	import com.hurlant.crypto.hash.SHA256;
	
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import mx.utils.StringUtil;
	
	import net.omegachess.classes.Board;
	import net.omegachess.classes.pieces.Locator;
	import net.omegachess.classes.pieces.Piece;
	import net.omegachess.components.AOLPlayConfigurationWindow;
	import net.omegachess.intents.Intent;
	import net.omegachess.intents.IntentRegistry;
	import net.omegachess.moves.movetypes.Move;
	import net.omegachess.moves.movetypes.StandardMove;
	import net.omegachess.populators.OCPNBoardPopulator;
	
	
	public class AOLMovementController implements IMovementController
	{
		const COMMAND_HANDSHAKE : String = "syn";
		const COMMAND_HANDSHAKE_SYNACK : String = "synack";
		const COMMAND_HANDSHAKE_ACK : String = "ack";		
		const COMMAND_START : String = "start";
		const COMMAND_MOVE : String = "move";
		
		private var secret1 : ByteArray;
		private var secret : String;
		private var config_open : Boolean = false;
		private var _session : Session;
		private var ourController : HumanMovementController = new HumanMovementController();
		private var board : Board;
		private var partner : User;
		private var aolWindow : AOLPlayConfigurationWindow;
		
		public function AOLMovementController()
		{										
			secret = "1.0";
		}
		
		public function init(board:Board):void
		{
//			trace(this.secret);
			this.board = board;		

			ourController.init(board);
			
			if(this._session === null) {
				if(this.config_open === false) {
					this.config_open = true;
					this.connectAOL(board);
				}
				return;
			}			
		}
		
		private function connectAOL(board : Board) : void {
			this.aolWindow = new AOLPlayConfigurationWindow();
			this.aolWindow.controller = this;
			this.aolWindow.open(true);	
			this.aolWindow.addEventListener(SessionEvent.STATE_CHANGED, handleConnect);		
		}
		
		private function handleConnect(event : SessionEvent) : void {
			if(event.session.sessionState === SessionState.ONLINE) {
				trace("Conneccted!");
				this._session = event.session;
				this._session.addEventListener(IMEvent.IM_RECEIVED, this.handleIM);
				//if we connected let's try to negotiate
				this.init(board);
			}					
		}
		
		public function challenge(aimID : String) : void {
			this.partner = new User();
			this.partner.aimId = aimID;
			this.sendIM(COMMAND_HANDSHAKE, [this.secret]);
		}
		
		private function handleIM(event : IMEvent) : void {			
			var verify : String = "";
			var sha : SHA256 = new SHA256();
			var imText : String = event.im.message;
			var results = imText.match(/@@(?P<command>([\w]+))(:(?P<param1>([\w\/]+)))?(:(?P<param2>([\w]+)))?(:(?P<param3>([\w]+)))?(:(?P<param4>([\w]+)))?(:(?P<param5>([\w]+)))?@@/i);
			
			try {
				Debug.show(Debug.INFO, "Task job", "Command:" + results.command);
				
				switch (results.command) {					
					//sent by first player
					case COMMAND_HANDSHAKE :						
						this.partner = event.im.sender;
						//send our secret because the player who is ringing will compare our secret to decide 
						this.sendIM(COMMAND_HANDSHAKE_SYNACK, [this.secret]);
					break;
					
					//sent by second player
					case COMMAND_HANDSHAKE_SYNACK :
						//synack so we should set our seed to the same as theirs...
						this.partner = event.im.sender;						
						this.sendIM(COMMAND_HANDSHAKE_ACK, [this.getPlayAlignment()]);
					break;
					
					//sent by first player, should include their color as param 1
					case COMMAND_HANDSHAKE_ACK :
						//Piece.ALIGNMENT_WHITE
						this.sendIM(COMMAND_START, [true]);
					break;
					
					case COMMAND_START :
						this.configMoveController();
						break;
					
					case COMMAND_MOVE : 
						this.processMove(results);
						break;
				}
			} catch( error : Error ) {
				//probably not for us...
			}
		}
		
		private function processMove(results : Object) : void {
			
			Debug.show(Debug.INFO, "Processing a move!", results.toString());
	
			try {
				var obp : OCPNBoardPopulator = new OCPNBoardPopulator(results.param1);
					obp.populate(board);			
			} catch (e:Error) {
				trace(e.message);
			}
			
			
//			trace(results.param1, results.param2);
//			trace(this.board.getCellAt(results.param1, results.param2));
//			trace(results.param3, results.param4);
//			trace(this.board.getCellAt(results.param3, results.param4));
//			var m : StandardMove 	= new StandardMove();
//				m.source			= this.board.getCellAt(results.param1, results.param2);
//				m.destination 		= this.board.getCellAt(results.param3, results.param4);
//		
//				trace(m.toACN());
//			Debug.show(Debug.INFO, "Processed", 'ACN: ' + m.toACN());
//				
//				this.sendMoveIntent(m);
		}
		
		private function sendMoveIntent(mov : Move) : void {
			var mdi : Intent = new Intent(this);
			mdi.type = Intent.INTENT_TYPE_MOVE_DECIDED;
			mdi.data = mov;
			
			IntentRegistry.handleIntent(mdi);
		}
		
		private function configMoveController() : void {
			IntentRegistry.registerIntentHandler(Intent.INTENT_TYPE_MOVE_DECIDED, this.handleMoveDecided, false);
		}
		
		private function handleMoveDecided(intent : Intent) : void {
			var move : Move = (intent.data as Move);
			this.sendIM(COMMAND_MOVE, [board.toOCPN()]);
		}
		
		private function getPlayAlignment() : Number {			
			switch(this.aolWindow.playAs.selectedItem) {
				case "White" : return Piece.ALIGNMENT_WHITE; break;
				case "Black" : return Piece.ALIGNMENT_BLACK; break;
				case "Random" : return Math.random() <= .5 ? Piece.ALIGNMENT_WHITE : Piece.ALIGNMENT_BLACK; break;
			}
			
			return Piece.ALIGNMENT_WHITE;
		};
		
		
		private function sendIM(c : String, params: Array) {
			
			var arrayString : String = params.join(":");
			
			var commandString : String = "@@" + c + /*":" + hash +*/ ":" + arrayString + "@@";
			
			this._session.sendIM(this.partner.aimId, commandString);
			
		}
		
		public function hasVisualNotifications():Boolean
		{
			return true;
		}
	}
}