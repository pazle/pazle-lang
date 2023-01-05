module Object.bytes;

import std.stdio;
import std.conv;
import std.uni;

import Object.numbers;
import Object.boolean;
import Object.datatype;


class Bytes: DataType{
	byte[] bytes;
	DataType[string] attributes;

	this(byte[] bytes){
		this.bytes = bytes;
		this.attributes = attrs;
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override string __str__(){
		return cast(string)this.bytes;
	}

	override string __json__(){
		return "\"" ~ cast(string)this.bytes ~ "\"";
	}

	override byte[] __bytes__(){
		return this.bytes;
	}

	override string __type__(){
		return "bytes";
	}

	override DataType __length__(){
		return new Number(this.bytes.length);
	}

	override bool capable(){
		if (this.bytes.length)
			return true;
		
		return false;
	}
}


class Chars: DataType{
	char[] bytes;
	DataType[string] attributes;

	this(char[] bytes){
		this.bytes = bytes;
		this.attributes = attrs;
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override string __str__(){
		return cast(string)this.bytes;
	}

	override string __json__(){
		return "\"" ~ cast(string)this.bytes ~ "\"";
	}

	override DataType __length__(){
		return new Number(this.bytes.length);
	}

	override char[] __chars__(){
		return this.bytes;
	}

	override string __type__(){
		return "bytes";
	}

	override bool capable(){
		if (this.bytes.length)
			return true;
		
		return false;
	}
}
