package net.omegachess.tests.movement
{
	import mx.containers.Canvas;
	
	import net.omegachess.classes.Board;
	import net.omegachess.classes.pieces.King;
	import net.omegachess.classes.pieces.Pawn;
	import net.omegachess.components.Cell;
	import net.omegachess.controllers.HumanMovementController;
	import net.omegachess.moves.movetypes.Capture;
	import net.omegachess.moves.movetypes.EnPassantCapture;
	import net.omegachess.moves.movetypes.Move;
	import net.omegachess.moves.movetypes.PawnFirstMove;
	import net.omegachess.populators.IBoardPopulator;
	import net.omegachess.populators.PawnTestCasePopulator;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.number.greaterThan;

	public class PawnMovements
	{	
		private var board : Board;
		
		[Before]
		public function setUp():void {			
			board = new Board();		
			
			var populator : IBoardPopulator = new PawnTestCasePopulator();
			
			populator.populate(board);
		}
		
		[After]
		public function tearDown():void
		{
		}
		
		[BeforeClass]
		public static function setUpBeforeClass():void {

		}
		
		[AfterClass]
		public static function tearDownAfterClass():void
		{
		}
		
		[Test( description="PawnTestCasePopulator populated correctly?" )]
		public function testPopulation() : void {		
			assertTrue(
				board.getCellAt(3, 2).piece is Pawn
			);
			assertTrue(
				board.getCellAt(2, 1).piece is Pawn
			);
			assertTrue(
				board.getCellAt(1, 6).piece is King
			);
			assertTrue(
				board.getCellAt(10, 6).piece is King
			);
		}
		
		[Test( description="White pawn can PawnFirstMove?" )]
		public function testWhiteFirstMove() : void {					
			var cell : Cell = board.getCellAt(2,1);
			var movementController : HumanMovementController = new HumanMovementController();
			var availableMoves : Array = movementController.getMoves(cell, board);
			//assertThat(availableMoves.length, greaterThan(1)); //more than one means there's first moves
			var hasFirstMove : Boolean = false;
			
			for each(var m : Move in availableMoves) {
				if(m is PawnFirstMove) {
					hasFirstMove = true;
				}
			}
			assertTrue(hasFirstMove);
		}
		
		[Test( description="First move triggers en passant?" )]
		public function testEnPassant() : void {					
			var cell : Cell = board.getCellAt(2,1);
			var movementController : HumanMovementController = new HumanMovementController();
			var availableMoves : Array = movementController.getMoves(cell, board);
			//assertThat(availableMoves.length, greaterThan(1)); //more than one means there's first moves
			
			for each(var m : Move in availableMoves) {
				if(m is PawnFirstMove) {
					board = m.apply(board);
					assertNotNull(board.enPassantPawn);
					assertNotNull(board.enPassantTargets);
					return;
				}
			}		
			
			assertTrue(false); //fail the test if we made it here
		}
		
		[Test( description="White pawn can capture black pawn?" )]
		public function testCapture() : void {					
			var cell : Cell = board.getCellAt(2,1);
			var movementController : HumanMovementController = new HumanMovementController();
			var availableMoves : Array = movementController.getMoves(cell, board);
			//assertThat(availableMoves.length, greaterThan(1)); //more than one means there's first moves
			var hasCapture : Boolean = false;
			
			for each(var m : Move in availableMoves) {
				if(m is Capture) {
					hasCapture = true;
				}
			}
			assertTrue(hasCapture);
		}
		
		[Test( description="First move triggers en passant, and black pawn can move en passant" )]
		public function testEnPassantCapture() : void {					
			var cell : Cell = board.getCellAt(2,1);
			var cell2 : Cell = board.getCellAt(3,2);
			var movementController : HumanMovementController = new HumanMovementController();
			var availableMoves : Array = movementController.getMoves(cell, board);
			//assertThat(availableMoves.length, greaterThan(1)); //more than one means there's first moves
			
			for each(var m : Move in availableMoves) {
				if(m is PawnFirstMove) {
					board = m.apply(board);
					assertNotNull(board.enPassantPawn);
					assertNotNull(board.enPassantTargets);
					break;
				}
			}
			
			availableMoves = movementController.getMoves(cell2, board);
			for each(var m : Move in availableMoves) {
				if(m is EnPassantCapture) {
					return;					
				}
			}		
			assertTrue(false); //fail the test if we made it here
		}
	}
}