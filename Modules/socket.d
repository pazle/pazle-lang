module Modules.socket;

import std.stdio;
import std.conv;
import std.socket;

import Object.datatype;
import Object.boolean;
import Object.strings;
import Object.numbers;
import Object.classes;
import Object.lists;
import Object.bytes;



class Close: DataType{
    Socket socket;

    this(Socket socket){
       this.socket = socket;
    }

    override DataType __call__(DataType[] params){ 
        this.socket.close();      
        return new None();
    }

    override string __str__() {
        return "close (Socket method)";
    }
}


SocketShutdown SHUT(int how){
    SocketShutdown H;

    if (how == H.SEND)
        return H.SEND;
    
    else if (how == H.RECEIVE)
        return H.RECEIVE;

    return H.BOTH;
}


class ShutDown: DataType{
    Socket socket;

    this(Socket socket){
       this.socket = socket;
    }

    override DataType __call__(DataType[] params){
        if (params.length)
            this.socket.shutdown(SHUT(cast(int)params[0].number2)); 

        this.socket.shutdown(SHUT(1)); 
        return new None();
    }

    override string __str__() {
        return "shutdown (Socket method)";
    }
}


class Receive: DataType{
    char[64000] request;
    Socket socket;

    this(Socket socket){
       this.socket = socket;
       this.request = request;
    }

    override DataType __call__(DataType[] params){
        auto amount = this.socket.receive(this.request);

        if (amount < 0)
            return new Chars([]);

        if (params.length)
            if (params[0].number2 <= amount)
                version(Windows)
                    return new Chars(this.request[0 .. cast(uint)params[0].number2]);
                else                    
                    return new Chars(this.request[0 .. params[0].number2]);

        return new Chars(this.request[0 .. amount]);
    }

    override string __str__() { return "recv (Socket method)"; }
}


class Send: DataType{
    Socket socket;
    this(Socket socket){ this.socket = socket; }

    override DataType __call__(DataType[] params){        
        this.socket.send(params[0].__chars__);
        return new None();
    }

    override string __str__() { return "send (Socket method)"; }
}


class Accept: DataType{
    Socket socket;
    this(Socket socket){ this.socket = socket; }

    override DataType __call__(DataType[] params){        
        return new SockClient(this.socket.accept());
    }

    override string __str__() { return "accept (Socket method)";}
}


class Listen: DataType{
    Socket socket;

    this(Socket socket){ this.socket = socket;}

    override DataType __call__(DataType[] params){
        this.socket.listen(to!int(params[0].number2));
        return new None();
    }

    override string __str__() { return "listen (Socket method)"; }
}


class Connect: DataType{
    Socket socket;

    this(Socket socket){
       this.socket = socket;
    }

    override DataType __call__(DataType[] params){
        if (params.length > 1)
            this.socket.connect(new InternetAddress(params[0].__str__, to!ushort(params[1].number2)));
        else
            this.socket.connect(new InternetAddress("localhost", 7700));
        return new None();
    }

    override string __str__() {
        return "connect]";
    }
}


class Bind: DataType{
    Socket socket;
    this(Socket socket){ this.socket = socket; }

    override DataType __call__(DataType[] params){
        this.socket.bind(new InternetAddress(params[0].__str__, to!ushort(params[1].number2)));
        return new None();
    }
    override string __str__() { return "bind (Socket method)"; }
}


class Blocking: DataType{
    Socket socket;
    this(Socket socket){ this.socket = socket; }

    override DataType __call__(DataType[] params){
        this.socket.blocking = false;
        return new None();
    }

    override string __str__() { return "blocking (Socket method)"; }
}


class NonBlocking: DataType{
    Socket socket;
    this(Socket socket){ this.socket = socket; }

    override DataType __call__(DataType[] params){
        this.socket.blocking = false;
        return new None();
    }

    override string __str__() { return "nonblocking (Socket method)"; }
}


class IsAlive: DataType{
    Socket socket;
    this(Socket socket){ this.socket = socket; }

    override DataType __call__(DataType[] params){
        if (this.socket.isAlive())
            return new True();

        return new False();
    }

    override string __str__() { return "isalive (Socket method)"; }
}


class Sock: DataType{
    DataType[string] attributes;
    Socket socket;

    this(Socket socket){
        this.socket = socket;
        this.socket.blocking = true;

        this.attributes = [
            "blocking": new Blocking(this.socket),
            "nonblocking": new NonBlocking(this.socket),
            "bind": new Bind(this.socket),
            "connect": new Connect(this.socket),
            "listen": new Listen(this.socket),
            "accept": new Accept(this.socket),
            "send": new Send(this.socket),
            "recv": new Receive(this.socket),
            "close": new Close(this.socket),
            "shutdown": new ShutDown(this.socket),
            "isalive": new IsAlive(this.socket),
            "hostname": new String(this.socket.hostName),
            "AF": new Number(cast(int)this.socket.addressFamily),
        ];

    }
    override DataType[string] attrs() {return this.attributes;}
    override string __str__() {return "Socket (object)";}
}


class SockClient: DataType{
    DataType[string] attributes;
    Socket socket;

    this(Socket socket){
        this.socket = socket;

        this.attributes = [
            "blocking": new Blocking(this.socket),
            "nonblocking": new NonBlocking(this.socket),
            "bind": new Bind(this.socket),
            "connect": new Connect(this.socket),
            "listen": new Listen(this.socket),
            "accept": new Accept(this.socket),
            "send": new Send(this.socket),
            "recv": new Receive(this.socket),
            "close": new Close(this.socket),
            "shutdown": new ShutDown(this.socket),
            "isalive": new IsAlive(this.socket),
            "hostname": new String(this.socket.hostName),
            "AF": new Number(cast(int)this.socket.addressFamily),
        ];

    }
    override DataType[string] attrs() {return this.attributes;}
    override string __str__() {return "socket (object)";}
}


AddressFamily AF(ushort _af){
    AddressFamily aF;

    if (_af == aF.INET6)
        return aF.INET6;

    else if (_af == aF.UNIX)
        return aF.UNIX;

    else if (_af == aF.IPX)
        return aF.IPX;

    else if (_af == aF.APPLETALK)
        return aF.APPLETALK;

    else if (_af == aF.UNSPEC)
        return aF.UNSPEC;

    return aF.INET;
}


SocketType SOCK(int _sk){
    SocketType sK;

    if (_sk == sK.DGRAM)
        return sK.DGRAM;

    else if (_sk == sK.RDM)
        return sK.RDM;

    else if (_sk == sK.RAW)
        return sK.RAW;

    else if (_sk == sK.SEQPACKET)
        return sK.SEQPACKET;

    return sK.STREAM;
}

class NewSocket: DataType{
    override DataType __call__(DataType[] params){
        if (params.length > 1)
            return new Sock(new Socket( AF(cast(ushort)params[0].number2), SOCK(cast(int)params[1].number2)) );
        
        else if (params[0].__str__ == "UDP")
            return new Sock(new UdpSocket());
        
        return new Sock(new TcpSocket());
    }

    override string __str__() {
        return "newSocket (socket object)";
    }
}


class GetAddr: DataType{
    override DataType __call__(DataType[] params){
        Address[] addr;
        DataType[] fd;

        if (params.length > 1)
            addr = getAddress(params[0].__str__, cast(ushort)params[1].number2);
        else
            addr = getAddress(params[0].__str__);


        foreach (Address i; addr){
            fd ~= new Obj_(i.toString, [
                            "addr": new String(i.toAddrString()),
                            "port": new Number(to!double(i.toPortString())),
                            "hostname": new String(i.toHostNameString()),
                            "servname": new String(i.toServiceNameString()),
                            "addrfamily": new String(to!string(i.addressFamily)),
                        ]);

        }


        return new List(fd);
    }

    override string __str__() {
        return "getAddr (socket method)";
    }
}


class LastSocketError: DataType{
    override DataType __call__(DataType[] params){ return new String(lastSocketError());}
    override string __str__() { return "last_socketError (socket method)";}
}


class LastBlockedFail: DataType{
    override DataType __call__(DataType[] params){
        if (wouldHaveBlocked())
            return new True();
        return new False();
    }
    override string __str__() { return "last_blockedFail (socket method)";}
}


DataType _AddressFamily(){
    return new Obj_("addrfamily (socket object)", [
            "IPX": new Number(AddressFamily.IPX),
            "UNIX": new Number(AddressFamily.UNIX),
            "INET": new Number(AddressFamily.INET),
            "INET6": new Number(AddressFamily.INET6),
            "UNSPEC": new Number(AddressFamily.UNSPEC),
            "APPLETALK": new Number(AddressFamily.APPLETALK),
        ]);
}


DataType _SocketType(){
    return new Obj_("sockettype (socket object)", [
            "RDM": new Number(SocketType.RDM),
            "RAW": new Number(SocketType.RAW),
            "DGRAM": new Number(SocketType.DGRAM),
            "STREAM": new Number(SocketType.STREAM),
            "SEQPACKET": new Number(SocketType.SEQPACKET),
        ]);
}

DataType _ShutDown(){
    return new Obj_("shutdown (socket object)", [
            "BOTH": new Number(SocketShutdown.BOTH),
            "SEND": new Number(SocketShutdown.SEND),
            "RECV": new Number(SocketShutdown.RECEIVE),
        ]);
}


class GetProtoByName: DataType{
    override DataType __call__(DataType[] params){
        auto proto = new Protocol;

        proto.getProtocolByName(params[0].__str__);
        return new Number(proto.type);
    }
    override string __str__() {return "getprotobyname (socket method)";}
}


class GetServByName: DataType{
    override DataType __call__(DataType[] params){
        if (params.length){
            auto serv = new Service;

            if (params.length > 1 && serv.getServiceByName(params[0].__str__, params[1].__str__))
                return new Number(serv.port);

            else if (serv.getServiceByName(params[0].__str__))
                return new Number(serv.port);
        }
        return new None();
    }
    override string __str__() {return "getservbyname (socket method)";}
}


class GetServByPort: DataType{
    override DataType __call__(DataType[] params){
        if (params.length){
            auto serv = new Service;

            if (params.length > 1 && serv.getServiceByPort(cast(ushort)params[0].number2, params[1].__str__))
                return new String(serv.name);

            else if (serv.getServiceByPort(cast(ushort)params[0].number2))
                return new String(serv.name);
        }
        return new None();
    }
    override string __str__() {return "getservbyport (socket method)";}
}


class GetHostByName: DataType{
    override DataType __call__(DataType[] params){
        Address[] addr = getAddress(params[0].__str__);
        DataType[] names;

        foreach(ad; addr)
            names ~= new String(ad.toAddrString());

        return new List(names);
    }
    override string __str__() {return "gethostbyname (socket method)";}
}

class Sockets: DataType{
    DataType[string] attributes;

    this(){
        this.attributes = [
            "newSocket": new  NewSocket(),
            "hostname": new String(Socket.hostName),
            "getaddr":new GetAddr(),
            "lastsocketError": new LastSocketError(),
            "lastblockedFail": new LastBlockedFail(),
            "getprotobyname": new GetProtoByName(),
            "getservbyname": new GetServByName(),
            "getservbyport": new GetServByPort(),
            "gethostbyname": new GetHostByName(),
            "AF": _AddressFamily(),
            "ST": _SocketType(),
            "SD": _ShutDown(),
        ];
    }

    override DataType[string] attrs() {
        return this.attributes;
    }

    override string __str__() {

        return "socket (builtin module)";
    }
}

