package net.omegachess.tests.bitboards
{	
	import net.omegachess.classes.Bitboard;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.number.greaterThan;
	import org.hamcrest.number.greaterThanOrEqualTo;
	import org.hamcrest.number.lessThan;

	public class BasicBitboardOperations
	{		
		[Before]
		public function setUp() : void {}
		
		[After]
		public function tearDown() : void {}
		
		[BeforeClass]
		public static function setUpBeforeClass() : void {}
		
		[AfterClass]
		public static function tearDownAfterClass() : void {}
		
		[Test( description="Test create a bitboard and ensure it's zeroed out" )]
		public function testDefault() : void {
			var board : Bitboard = new Bitboard();
			for(var i : Number = 0; i < 12; i ++) {
				for(var j : Number = 0; j < 12; j++) {
					assertEquals(0, board.getBitAt(i, j));
				}
			}
		}
		
		[Test( description="Test silent set a bit and retrieve it" )]
		public function testSilentSet() : void {
			var board : Bitboard = new Bitboard();
			var i : Number = Math.floor(Math.random() * 12);
			var j : Number = Math.floor(Math.random() * 12);
			
			//random bit coords should be in bounds			
			assertThat(i, greaterThanOrEqualTo(0));
			assertThat(j, greaterThanOrEqualTo(0));
			assertThat(i, lessThan(12));
			assertThat(j, lessThan(12));
			
			board.silentSetBitAt(1, i, j);
			assertEquals(1, board.getBitAt(i,j));
		}
		
		[Test(expects="Error",description="Test set a bit out of bounds that throws exception")]
		public function testSetException() : void {
			var board : Bitboard = new Bitboard();
			
			board.setBitAt(1, 99,99);			
		}
	}
}