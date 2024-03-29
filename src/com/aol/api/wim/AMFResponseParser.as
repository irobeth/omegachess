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

package com.aol.api.wim {
    
    import com.aol.api.wim.data.BuddyList;
    import com.aol.api.wim.data.DataIM;
    import com.aol.api.wim.data.Group;
    import com.aol.api.wim.data.IM;
    import com.aol.api.wim.data.IMRawMessageData;
    import com.aol.api.wim.data.SMSInfo;
    import com.aol.api.wim.data.SMSSegment;
    import com.aol.api.wim.data.User;
    import com.aol.api.wim.interfaces.IResponseParser;

    public class AMFResponseParser implements IResponseParser {
        
        public function AMFResponseParser() {
            super();
        }

        public function parseUser(data:*):User {
            if(!data) { return null; }
            var u:User = new User();
            u.aimId             = data.aimId;
            u.displayId         = data.displayId;
            u.friendlyName      = data.friendly;
            u.state             = data.state;
            u.onlineTime        = data.onlineTime;
            u.awayTime          = data.awayTime; // in minutes?
            u.statusTime        = data.statusTime; // TODO: Turn statusTime into date
            u.awayMessage       = data.awayMsg;
            u.profileMessage    = data.profileMsg;
            u.statusMessage     = data.statusMsg;
            u.buddyIconURL      = data.buddyIcon;
            u.presenceIconURL   = data.presenceIcon
            u.capabilities      = parseCapabilities(data.capabilities);
            u.countryCode       = data.ipCountry;
            u.sms               = parseSMSSegment(data.smsSegment);
            u.smsNumber         = data.smsNumber;
            u.bot               = parseBot(data);
            u.nonBuddy          = (data.nonBuddy > 0)?true:false;
            u.invisible         = (data.invisible && (data.invisible > 0))?true:false;
            u.userType          = data.userType;
            return u;
        }
        
        public function parseBot(data:*):Boolean {
            if (data.bot) {
                if (data.bot > 0) {
                    return true;
                }
            } 
            return false; 
        }
        
        public function parseSMSSegment(data:*):SMSSegment {
            if(!data) { return null; }
            var sms:SMSSegment = new SMSSegment();
            sms.initial     = data.initial;
            sms.single      = data.single;
            sms.trailing    = data.trailing;            
            return sms;           
        }
        
        public function parseBuddyList(data:*, owner:User=null):BuddyList {
            if(!data) { return null; }
            
            // Create group array
            var groups:Array = new Array();
            
            for each (var groupObj:Object in data.groups) {
                var g:Group = parseGroup(groupObj);//new Group(xmlGroup.name.text(), users);
                groups.push(g);
            }
            
            // We leave the owner undefined, because we parse with no context
            var bl:BuddyList = new BuddyList(owner, groups);
            return bl;
        }
        
        public function parseGroup(data:*):Group {
            // buddies array
            // 'name' string
            if(!data) {return null;}
            var buddies:Array = data.buddies;

            // Create user array
            var users:Array = new Array();
            
            for each (var buddyObj:Object in buddies) {
                users.push(parseUser(buddyObj));
            }
            
            var g:Group = new Group(data.name, users);
            if(data.recent == 1) g.recent = true;
            if(data.smart != null) g.smart = data.smart;
            return g;
        }
        
        public function parseIM(data:*, recipient:User=null, isOffline:Boolean=false, incoming:Boolean=true):IM {
            if(!data) { return null; }

            var source:User = null;
            var isAutoResponse:Boolean = false;
            if(!isOffline) {
                source = parseUser(data.source);
                isAutoResponse = data.autoresponse;
            } else {
                // we don't look for isAutoResponse
                // we use a 'aimId' string for a User, not Presence data 
                source = new User();
                source.aimId = data.aimId;
            }            
            var msg:String = data.message;
            var timestamp:uint = data.timestamp;
            
            var im:IM = new IM(msg, new Date(timestamp*1000), source, recipient, incoming, isAutoResponse, isOffline);
            
            if(data.rawMsg) {
                im.rawMessageData = new IMRawMessageData(data.rawMsg.base64Msg, data.rawMsg.memberCountry, data.rawMsg.clientCountry, data.rawMsg.ipCountry);
            }
            
            return im;
        }
        
        public function parseSMSInfo(data:*):SMSInfo {
            if(!data) { return null; }
            
            var smsInfo:SMSInfo = new SMSInfo();
            
            smsInfo.errorCode = Number(data.smsError);
            smsInfo.reasonText = data.smsReason ?  String(data.smsReason) : "";
            smsInfo.carrierId = Number(data.smsCarrierID);
            smsInfo.remainingCount = Number(data.smsRemainingCount);
            smsInfo.maxAsciiLength = Number(data.smsMaxAsciiLength);
            smsInfo.maxUnicodeLength = Number(data.smsMaxUnicodeLength);
            smsInfo.carrierName = data.smsCarrierName ? String(data.smsCarrierName) : "";
            smsInfo.carrierUrl = data.smsCarrierUrl ? String(data.smsCarrierUrl) : "";
            smsInfo.balanceGroup = data.smsBalanceGroup ? String(data.smsBalanceGroup) : "";
            
            return smsInfo;
        }
        
        // TODO: Verify that parseDataIM works once we get IM send/recv working
        public function parseDataIM(data:*, recipient:User=null):DataIM {
            if(!data) { return null; }
            var source:User         = parseUser(data.source);
            var msg:String          = data.dataIM;
            var capability:String   = data.dataCapability;
            var inviteMsg:String    = data.inviteMsg; // How do we determine if this value is null?
            var dataType:String  = data.dataType;
            return new DataIM(msg, dataType, new Date(), source, recipient, capability, inviteMsg);
        }
        
        private function parseCapabilities(data:*):Array {
            var caps:Array = new Array();
            
            if(data) {
                for each(var cap:String in data) {
                    //caps.push(capXML.capability.text());
                    caps.push(cap);
                }
            }
            return caps;
        }
        
    }
}