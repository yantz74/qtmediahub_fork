/****************************************************************************

This file is part of the QtMediaHub project on http://www.gitorious.org.

Copyright (c) 2009 Nokia Corporation and/or its subsidiary(-ies).*
All rights reserved.

Contact:  Nokia Corporation (qt-info@nokia.com)**

You may use this file under the terms of the BSD license as follows:

"Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
* Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
* Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
* Neither the name of Nokia Corporation and its Subsidiary(-ies) nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."

****************************************************************************/

.pragma library

function toHumanReadableBytes(bytes)
{
    var suffixes = [ 'bytes', 'KB', 'MB', 'TB' ] // qsTr?
    var idx = 0
    while (bytes > 1024 && idx < 3) {
        bytes /= 1024
        ++idx
    }
    return bytes.toFixed(2) + ' ' + suffixes[idx]
}

function ms2string(ms)
{
    var ret = "";

    if (ms == 0)
        return "00:00:00";

    var h = Math.floor(ms/(1000*60*60))
    var m = Math.floor((ms%(1000*60*60))/(1000*60))
    var s = Math.floor(((ms%(1000*60*60))%(1000*60))/1000)

    if (h >= 1) {
        ret += h < 10 ? "0" + h : h + "";
        ret += ":";
    }

    ret += m < 10 ? "0" + m : m + "";
    ret += ":";
    ret += s < 10 ? "0" + s : s + "";

    return ret;
}
