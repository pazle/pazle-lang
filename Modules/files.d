module Modules.files;

import core.stdc.errno;
import std.exception;
import std.stdio;
import std.conv;
import std.file;

import Object.datatype;
import Object.boolean;
import Object.strings;
import Object.numbers;
import Object.bytes;
import Object.lists;


class Files: DataType{
	DataType[string] attributes;

	this(){
		this.attributes = [
			"read": new Read(),
			"readbin": new Readbin(),
			"write": new Write(),
			"writebin": new Writebin(),
			"append": new Append(),
			"appendbin": new Appendbin(),
			"size": new Size(),
			"open": new Open(),
		];
	}

	override DataType[string] attrs() { return this.attributes;}
	override string __str__() { return "file (builtin module)"; }
}


class Read: DataType{
	override DataType __call__(DataType[] params){
		return new String(readText(params[0].__str__));
	}
	override string __str__() {return "read (file method)"; }
}


class Readbin: DataType{
	override DataType __call__(DataType[] params){
		version(Posix){
			if (params.length > 1)
				return new Chars(cast(char[])read(params[0].__str__, params[1].number2));
		}
		return new Chars(cast(char[])read(params[0].__str__));
	}
	override string __str__() {return "readbin (file method)"; }
}


class Write: DataType{
	override DataType __call__(DataType[] params){
		std.file.write(params[0].__str__, params[1].__str__);
		return new None();
	}
	override string __str__() {return "write (file method)"; }
}


class Writebin: DataType{
	override DataType __call__(DataType[] params){
		std.file.write(params[0].__str__, params[1].__chars__);
		return new None();
	}
	override string __str__() {return "writebin (file method)"; }
}


class Append: DataType{
	override DataType __call__(DataType[] params){
		append(params[0].__str__, params[1].__str__);
		return new None();
	}
	override string __str__() {return "append (file method)"; }
}


class Appendbin: DataType{
	override DataType __call__(DataType[] params){
		append(params[0].__str__, params[1].__chars__);
		return new None();
	}
	override string __str__() {return "appendbin (file method)"; }
}


class Size: DataType{
	override DataType __call__(DataType[] params){
		return new Number(getSize(params[0].__str__));
	}
	override string __str__() {return "size (file method)"; }
}


class Open: DataType{
	int index;
	this(){ this.index = 0; }

	override DataType __call__(DataType[] params){
		this.index += 1;
		
		if (params.length > 1)
			return new OpenFile(this.index, params[0].__str__, params[1].__str__);

		return new OpenFile(this.index, params[0].__str__);
	}
	override string __str__() { return "open (file object)"; }
}


class OpenFile: DataType{
	int index;
	File stream;
	string name, mode;
	DataType[string] attributes;

	this(int index, string name, string mode = "r") {
		this.stream = File(name, mode);
		this.index = index;
		this.name = name;
		this.mode = mode;

		this.attributes = [
			"name": new String(name),
			"mode": new String(mode),
			"tell": new _Tell(this.stream),
			"close": new _Close(this.stream),
			"size": new _Size(this.stream),
			"flush": new _Flush(this.stream),
			"isopen": new _Isopen(this.stream),
			"read": new _Read(this.stream),
			"readln": new _Readln(this.stream),
			"readbin": new _Readbin(this.stream),
			"readbinln": new _Readbinln(this.stream),
			"write": new _Write(this.stream),
			"writebin": new _Writebin(this.stream),
			"writeln": new _Writeln(this.stream),
			"writebinln": new _Writebinln(this.stream),
			"seek": new _Seek(this.stream),
		];
	}

	override DataType[string] attrs() { return this.attributes;}
	override string __str__() { return "File (iostream " ~ to!string(this.index) ~ " name: '" ~this.name ~ "' mode: '" ~this.mode ~ "')"; }
}


class _Isopen: DataType{
	File stream;
	this(File stream){ this.stream = stream; }

	override DataType __call__(DataType[] params){
		if (this.stream.isOpen)
			return new True();
		
		return new False();
	}
	override string __str__() { return "isopen (file.open method)"; }
}


class _Flush: DataType{
	File stream;
	this(File stream){ this.stream = stream; }

	override DataType __call__(DataType[] params){
		this.stream.flush();
		return new None();
	}
	override string __str__() { return "flush (file.open method)"; }
}


class _Size: DataType{
	File stream;
	this(File stream){ this.stream = stream; }

	override DataType __call__(DataType[] params){
		return new Number(this.stream.size);
	}
	override string __str__() { return "size (file.open method)"; }
}


class _Close: DataType{
	File stream;
	this(File stream){ this.stream = stream; }

	override DataType __call__(DataType[] params){
		this.stream.close();
		return new None();
	}
	override string __str__() { return "close (file.open method)"; }
}


class _Tell: DataType{
	File stream;
	this(File stream){ this.stream = stream; }

	override DataType __call__(DataType[] params){
		return new Number(this.stream.tell);
	}
	override string __str__() { return "tell (file.open method)"; }
}

class _Read: DataType{
	File stream;
	char[8192] buffer;

	this(File stream){
		this.stream = stream;
		this.buffer = buffer;
	}

	override DataType __call__(DataType[] params){
		return new String(cast(string)this.stream.rawRead(this.buffer));
	}
	override string __str__() { return "read (file.open method)"; }
}


class _Readln: DataType{
	File stream;
	this(File stream){ this.stream = stream; }

	override DataType __call__(DataType[] params){
		if (params.length && params[0].__str__.length)
			return new String(this.stream.readln(params[0].__str__[0]));

		return new String(this.stream.readln());
	}
	override string __str__() { return "readln (file.open method)"; }
}


class _Readbinln: DataType{
	File stream;
	char[] buf;
	this(File stream){
		this.buf = buf;
		this.stream = stream;
	}

	override DataType __call__(DataType[] params){
		if (params.length && params[0].__str__.length)
			this.stream.readln(this.buf, params[0].__str__);
		else
			this.stream.readln(this.buf);

		return new Chars(this.buf);
	}
	override string __str__() { return "readbinln (file.open method)"; }
}



class _Readbin: DataType{
	File stream;
	char[8192] buffer;

	this(File stream){
		this.stream = stream;
		this.buffer = buffer;
	}

	override DataType __call__(DataType[] params){
		return new Chars(this.stream.rawRead(this.buffer));
	}
	override string __str__() { return "read (file.open method)"; }
}


class _Writebin: DataType{
	File stream;
	this(File stream){ this.stream = stream; }

	override DataType __call__(DataType[] params){
		this.stream.rawWrite(params[0].__chars__);
		return new None();
	}
	override string __str__() { return "writebin (file.open method)"; }
}


class _Write: DataType{
	File stream;
	this(File stream){ this.stream = stream; }

	override DataType __call__(DataType[] params){
		this.stream.write(params[0].__str__);
		return new None();
	}
	override string __str__() { return "write (file.open method)"; }
}


class _Writebinln: DataType{
	File stream;
	this(File stream){ this.stream = stream; }

	override DataType __call__(DataType[] params){
		this.stream.writeln(params[0].__chars__);
		return new None();
	}
	override string __str__() { return "writebinln (file.open method)"; }
}


class _Writeln: DataType{
	File stream;
	this(File stream){ this.stream = stream; }

	override DataType __call__(DataType[] params){
		this.stream.writeln(params[0].__str__);
		return new None();
	}
	override string __str__() { return "writeln (file.open method)"; }
}


class _Seek: DataType{
	File stream;
	this(File stream){ this.stream = stream; }

	override DataType __call__(DataType[] params){
		if (params.length)
			if (params.length == 1)
				this.stream.seek(params[0].number2, 2);
			else
				this.stream.seek(params[0].number2, cast(int)params[1].number2);
		return new None();
	}
	override string __str__() { return "seek (file.open method)"; }
}


class Reuseopenfile: DataType{
	int index;
	File stream;
	string name, mode;
	DataType[string] attributes;

	this(File stream, string name, string mode) {
		this.stream = stream;
		this.index = 0;
		this.name = name;
		this.mode = mode;

		this.attributes = [
			"name": new String(name),
			"mode": new String(mode),
			"tell": new _Tell(this.stream),
			"close": new _Close(this.stream),
			"size": new _Size(this.stream),
			"flush": new _Flush(this.stream),
			"isopen": new _Isopen(this.stream),
			"read": new _Read(this.stream),
			"readln": new _Readln(this.stream),
			"readbin": new _Readbin(this.stream),
			"readbinln": new _Readbinln(this.stream),
			"write": new _Write(this.stream),
			"writebin": new _Writebin(this.stream),
			"writeln": new _Writeln(this.stream),
			"writebinln": new _Writebinln(this.stream),
			"seek": new _Seek(this.stream),
		];
	}

	override DataType[string] attrs() { return this.attributes;}
	override string __str__() { return "file (iostream " ~ to!string(this.index) ~ " name: '" ~this.name ~ "' mode: '" ~this.mode ~ "']"; }
}

