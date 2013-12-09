package net.omegachess.tests.bitboards
{
	import net.omegachess.classes.Bitboard;
	
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.asserts.assertTrue;
	import org.hamcrest.number.greaterThan;
	import org.hamcrest.number.greaterThanOrEqualTo;
	import org.hamcrest.number.lessThan;

	public class BinaryBitboardOperations
	{		
		[Before]
		public function setUp() : void {}
		
		[After]
		public function tearDown() : void {}
		
		[BeforeClass]
		public static function setUpBeforeClass() : void {}
		
		[AfterClass]
		public static function tearDownAfterClass() : void {}
		
		[Test( description="Test merge a bitboard where one bit is set and the other isn't" )]
		public function testMerge() : void {
			var board1 : Bitboard = new Bitboard();
			var board2 : Bitboard = new Bitboard();
			
			var i : Number = Math.floor(Math.random() * 12);
			var j : Number = Math.floor(Math.random() * 12);
			
			//random bit coords should be in bounds			
			assertThat(i, greaterThanOrEqualTo(0));
			assertThat(j, greaterThanOrEqualTo(0));
			assertThat(i, lessThan(12));
			assertThat(j, lessThan(12));
			
			board1.setBitAt(1, i, j);
			
			board1 = Bitboard.merge(board1, board2);
			assertEquals(1, board1.getBitAt(i,j));
		}
		
		[Test( description="Test merge a bitboard where both bits are set" )]
		public function testMergeBoth() : void {
			var board1 : Bitboard = new Bitboard();
			var board2 : Bitboard = new Bitboard();
			
			var i : Number = Math.floor(Math.random() * 12);
			var j : Number = Math.floor(Math.random() * 12);

			var i2 : Number = Math.floor(Math.random() * 12);
			var j2 : Number = Math.floor(Math.random() * 12);

			
			//random bit coords should be in bounds			
			assertThat(i, greaterThanOrEqualTo(0));
			assertThat(j, greaterThanOrEqualTo(0));
			assertThat(i, lessThan(12));
			assertThat(j, lessThan(12));

			assertThat(i2, greaterThanOrEqualTo(0));
			assertThat(j2, greaterThanOrEqualTo(0));
			assertThat(i2, lessThan(12));
			assertThat(j2, lessThan(12));

			
			board1.setBitAt(1, i, j);
			board2.setBitAt(1, i2, j2);
			
			board1 = Bitboard.merge(board1, board2);
			assertEquals(1, board1.getBitAt(i,j));
			assertEquals(1, board1.getBitAt(i2,j2));			
		}
		
		[Test( description="Test exclude a bitboard where one bit is set and the other isn't" )]
		public function testExcludeSource() : void {
			var board1 : Bitboard = new Bitboard();
			var board2 : Bitboard = new Bitboard();
			
			var i : Number = Math.floor(Math.random() * 12);
			var j : Number = Math.floor(Math.random() * 12);
			
			//random bit coords should be in bounds			
			assertThat(i, greaterThanOrEqualTo(0));
			assertThat(j, greaterThanOrEqualTo(0));
			assertThat(i, lessThan(12));
			assertThat(j, lessThan(12));
			
			board1.setBitAt(1, i, j);
			
			board1 = Bitboard.exclude(board1, board2);
			assertEquals(1, board1.getBitAt(i,j));
		}
		
		[Test( description="Test exclude a bitboard where both bits are set" )]
		public function testExcludeBoth() : void {
			var board1 : Bitboard = new Bitboard();
			var board2 : Bitboard = new Bitboard();
			
			var i : Number = Math.floor(Math.random() * 12);
			var j : Number = Math.floor(Math.random() * 12);
			
			//random bit coords should be in bounds			
			assertThat(i, greaterThanOrEqualTo(0));
			assertThat(j, greaterThanOrEqualTo(0));
			assertThat(i, lessThan(12));
			assertThat(j, lessThan(12));
			
			board1.setBitAt(1, i, j);
			board2.setBitAt(1, i, j);
			
			board1 = Bitboard.exclude(board1, board2);
			assertEquals(0, board1.getBitAt(i,j));
		}
		
		[Test( description="Test AND a bitboard where one bit is set and the other isn't" )]
		public function testAndSource() : void {
			var board1 : Bitboard = new Bitboard();
			var board2 : Bitboard = new Bitboard();
			
			var i : Number = Math.floor(Math.random() * 12);
			var j : Number = Math.floor(Math.random() * 12);
			
			//random bit coords should be in bounds			
			assertThat(i, greaterThanOrEqualTo(0));
			assertThat(j, greaterThanOrEqualTo(0));
			assertThat(i, lessThan(12));
			assertThat(j, lessThan(12));
			
			board1.setBitAt(1, i, j);
			
			board1 = Bitboard.and(board1, board2);
			assertEquals(0, board1.getBitAt(i,j));
		}
		
		[Test( description="Test AND a bitboard where both bits are set" )]
		public function testAndBoth() : void {
			var board1 : Bitboard = new Bitboard();
			var board2 : Bitboard = new Bitboard();
			
			var i : Number = Math.floor(Math.random() * 12);
			var j : Number = Math.floor(Math.random() * 12);
			
			//random bit coords should be in bounds			
			assertThat(i, greaterThanOrEqualTo(0));
			assertThat(j, greaterThanOrEqualTo(0));
			assertThat(i, lessThan(12));
			assertThat(j, lessThan(12));
			
			board1.setBitAt(1, i, j);
			board2.setBitAt(1, i, j);
			
			board1 = Bitboard.and(board1, board2);
			assertEquals(1, board1.getBitAt(i,j));
		}
	}
}