module Object.numbers;

import std.stdio;
import std.conv;
import std.uni;

import Object.datatype;


class Number: DataType{
	long ldata;
	double data;
	DataType[] attrs;

	this(double data){
		this.data = data;
		this.ldata = cast(long)(data);
		this.attrs = attrs;
	}

	override double number(){
		return this.data;
	}

	override long number2(){
		return this.ldata;
	}

	override long num(){
		return this.ldata;
	}

	override string __str__(){
		return to!string(this.data);
	}

	override string __type__(){
		return "number";
	}

	override string __json__(){
		return this.__str__;
	}

	override bool capable(){
		if (this.data == 0){
			return false;
		}
		return true;
	}
}


