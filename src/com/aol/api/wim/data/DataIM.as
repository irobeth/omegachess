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
package com.aol.api.wim.data {
    import com.aol.api.wim.data.types.DataIMType;
    
    /**
     * This object represents a "data IM" with base64 encoded data.
     * This object extends the <code>IM</code> object by adding a capabilityUUID string,
     * a dataType, and an optional inviteMessage.
     * 
     * The message property is used in this case to store the (optionally) base64 encoded message.
     */    
    public class DataIM extends IM {
        
        public var capabilityUUID:String;
        public var dataType:String;
        public var inviteMessage:String;
        public var base64Encoded:Boolean;
        
        /**
         * 
         * @param dataMsg
         * @param dataType A string representing the data type. Valid constants are available in the <code>DataIMType</code> object.
         * @param timestamp
         * @param sender
         * @param recipient
         * @param capability
         * @param inviteMessage
         * 
         */        
        public function DataIM(dataMsg:String, dataType:String, timestamp:Date, sender:User, recipient:User, capability:String, inviteMessage:String=null, isBase64Encoded:Boolean=false) {
            
            super(dataMsg, timestamp, sender, recipient, false, false);
            this.base64Encoded = isBase64Encoded;
            this.capabilityUUID = capability;
            this.dataType = dataType;
            this.inviteMessage = inviteMessage;
        }
        
        override public function toString():String {
            
            return "[IM = [" + super.toString() + "]" + 
                   ", dataType='" + dataType + "'" + 
                   ", capabilityUUID=" + capabilityUUID + 
                   ", inviteMessage=" + inviteMessage + 
            	   ", base64Encoded='" + base64Encoded + "'" +
                   "]";
        }
        
    }
}
