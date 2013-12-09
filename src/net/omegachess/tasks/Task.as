package net.omegachess.tasks
{
	import flash.events.Event;
	
	import mx.containers.Canvas;
	import mx.core.Container;
	import mx.events.FlexEvent;
	
	public class Task extends Canvas
	{		
		private var _job : Function;
		private var _params : Array;
		
		private var _host : Container;
		
		public function Task() {
			super();
		}
		
		public function start(host : Container) : void {
			if(host != null) {
				_host = host;
			}
			
			this.includeInLayout = false;
			this.visible = false;			
			_host.addChild(this);			
			this.addEventListener(FlexEvent.CREATION_COMPLETE, startJob);
		}
		
		public function kill() : void {
			_host.removeChild(this);
			this.removeEventListener(FlexEvent.CREATION_COMPLETE, startJob);			
			
			var killedEvent : Event = new Event(Event.COMPLETE);
			this.dispatchEvent(killedEvent);
		}
		
		private function startJob(event : FlexEvent) : void {
			callLater(_job, _params);
		}
		
		public function set job( f : Function ) : void {
			_job = f;	
		}
		
		public function get job() : Function {
			return _job;	
		}
		
		public function set params( p : Array ) : void {
			_params = p;			
		}
		
		public function get params() : Array {
			return _params;
		}
	}
}