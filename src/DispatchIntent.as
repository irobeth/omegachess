// ActionScript file
package {
	import net.omegachess.intents.Intent;
	import net.omegachess.intents.IntentRegistry;

	public static function dispatchIntent( i : Intent) {
		IntentRegistry.handleIntent(i);
	}
}