package
{
	//flex has no assert?
	public class Assertion
	{
		public function Assertion(expr : Boolean)
		{
			if(!expr) throw new Error("Assertion failed");
		}
	}
}