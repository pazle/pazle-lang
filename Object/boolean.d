module Object.boolean;

import Object.datatype;


class None: DataType{
	DataType[string] attributes;

	this(){
		this.attributes = attributes;
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override string __json__(){
		return "null";
	}

	override string __type__(){
		return "null";
	}

	override string __str__(){
		return "null";
	}
}

class True: DataType{
	DataType[string] attributes;

	this(){
		this.attributes = attributes;
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override string __str__(){
		return "true";
	}

	override string __type__(){
		return "true";
	}

	override string __json__(){
		return "true";
	}

	override bool capable(){
		return true;
	}
}


class False: DataType{
	DataType[string] attributes;

	this(){
		this.attributes = attributes;
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override string __str__(){
		return "false";
	}

	override string __type__(){
		return "false";
	}

	override string __json__(){
		return "false";
	}
}


DataType bool_sort(bool x){
	if (x)
		return new True();

	return new False();
}


class EOI: DataType{
	DataType[string] attributes;

	this(){
		this.attributes = attributes;
	}

	override DataType[string] attrs(){
		return this.attributes;
	}

	override string __str__(){
		return "NaN";
	}

	override string __type__(){
		return "NaN";
	}

	override string __json__(){
		return "NaN";
	}
}

