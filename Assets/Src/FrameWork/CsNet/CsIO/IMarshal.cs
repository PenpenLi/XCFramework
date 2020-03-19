﻿using System;

namespace XC.CsIO
{
    public sealed class MarshalException : Exception
    {
        public MarshalException()
        {
            UnityEngine.Debug.LogError(string.Format("protocol {0} unmarshal fail",Coder.CurLuaType));
        }
    }
    
    public sealed class CodecException : Exception
    {
        public CodecException(Exception e) : base("", e)
        {
            UnityEngine.Debug.LogError(e);
        }

        public CodecException(string message) : base(message)
        {
            UnityEngine.Debug.LogError(message);
        }

        public CodecException(string message, Exception e) : base(message, e)
        {
            UnityEngine.Debug.LogError(message);   
        }
    }


    public interface IMarshal
    {
        OctetsStream Marshal(OctetsStream os);
        OctetsStream Unmarshal(OctetsStream os); //throws MarshalException
    }
}   