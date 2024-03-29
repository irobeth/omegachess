/* 
Copyright (c) 2008 AOL LLC
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
Neither the name of the AOL LCC nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. 
*/

package com.aol.api.wim.transactions {
    import com.aol.api.wim.Session;
    import com.aol.api.wim.events.MemberDirectoryEvent;
    
    import flash.events.Event;
    import flash.events.IOErrorEvent;

    public class GetMemberDirectory extends Transaction {
        protected var language:String;
        
        protected var _tempRequestId:uint;
        
        public function GetMemberDirectory(session:Session, language:String) {
            super(session);
            this.language = language;
            _tempRequestId = 0;
            addEventListener(MemberDirectoryEvent.DIRECTORY_GETTING, doGet, false, 0, true);
        }
        
        public function run(ids:Array, level:String, context:Object):void {
            var event:MemberDirectoryEvent = new MemberDirectoryEvent(MemberDirectoryEvent.DIRECTORY_GETTING, true, true);
            event.searchTerms = {};
            event.searchTerms.ids = new Array();
            for (var i:int=0; i<ids.length; i++)
            {
                event.searchTerms.ids[i] = ids[i];
            }
            event.level = level;
            event.context = context;
            dispatchEvent(event);
        }
        
        protected function doGet(event:MemberDirectoryEvent):void {
            var requestId:uint = storeRequest(event);
            event.requestId = requestId;
            _tempRequestId = requestId;
            var method:String = "memberDir/get";
            var query:String =
                "?f=amf3" +
                "&r=" + requestId +
                "&aimsid=" + _session.aimsid +
                "&locale=" + language;
                
            for (var i:int=0; i<event.searchTerms.ids.length; i++)
            {
                query+="&t=" + encodeURIComponent(event.searchTerms.ids[i]);                                  
            }
            
            query += "&infoLevel=" + event.level;                
                
            sendRequest(_session.apiBaseURL + method + query, "GET", event.context, 15000);
        }
        
        override protected function requestComplete(event:Event):void {
            super.requestComplete(event);
            if(!_response) return;
            
            var statusCode:uint = _response.statusCode;
            var statusText:String = _response.statusText;
            var requestId:uint = _response.requestId;
            
            var oldEvent:MemberDirectoryEvent = MemberDirectoryEvent(getRequest(requestId));
            var newEvent:MemberDirectoryEvent = new MemberDirectoryEvent(MemberDirectoryEvent.DIRECTORY_GET_RESULT, true, true);            
            newEvent.context = oldEvent.context;
            newEvent.searchTerms = oldEvent.searchTerms;
            newEvent.searchResults = [];
            newEvent.statusCode = statusCode;
            
            if (statusCode == 200) {
                _logger.debug("GetMemberDirectory response.data {0}", _response.data);
                if (_response.data.infoArray != null) {                
                    newEvent.searchResults = _response.data.infoArray;
                }
            } else {
                _logger.error("GetMemberDirectory request resulted in non-OK status: {0} - {1}", statusCode, statusText);
            }
            _tempRequestId = 0;
            dispatchEvent(newEvent);            
        }
        
        override protected function handleIOError(evt:IOErrorEvent):void
        {
            var oldEvent:MemberDirectoryEvent = MemberDirectoryEvent(getRequest(_tempRequestId));
            _logger.error("GetMemberDirectory request resulted in IO_ERROR: {0} - {1}", evt.type, evt.text);
            var newEvent:MemberDirectoryEvent = new MemberDirectoryEvent(MemberDirectoryEvent.DIRECTORY_GET_IO_ERROR);
            if (oldEvent)
            {
                if (oldEvent.context)
                {
                    newEvent.context = oldEvent.context;        
                }
                
                if (oldEvent.level)
                {
                    newEvent.level = oldEvent.level;
                }
            
                if (oldEvent.searchTerms)
                {
                    newEvent.searchTerms = oldEvent.searchTerms;
                }
            }

            newEvent.searchResults = [];            
            _tempRequestId = 0;
            dispatchEvent(newEvent);
        }
    }
}