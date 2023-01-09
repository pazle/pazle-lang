module eval;

import std.stdio;
import std.file;
import std.string;
import std.conv;
import std.array;
import std.algorithm;

import node;
import shell;
import lexer;
import config;
import parser;

import Modules.console;
import Modules.exceptions;

import Object.lists;
import Object.strings;
import Object.boolean;
import Object.numbers;
import Object.classes;
import Object.datatype;
import Object.functions;
import Object.dictionary;


DataType[string] HASHTABLE, IMPORTED_MODULES;
string Err;


class Eval{
	int pos;
	bool end;
	Node cur;
	Node[] ast;
	string file;
	ERROR errors;
	DataType self;
	DataType ITER;
	DataType NEXT;
	DataType[string] info;
	DataType[string] hash;

	this(Node[] ast, DataType[string] hash, string file, ERROR errors){
		this.ast = ast;
		this.cur = cur;
		this.end = true;
		this.pos = -1;
		this.hash = hash;
		this.errors = errors;
		this.file = file;
		this.next();
		this.ITER = new Iter();
		this.NEXT = new Next();

		this.info = [
			"error": new None(),
			"loop": new None(),
			"return": new None(),
			"modified": new None()
			];

		this.evaluate();
	}

	void next(){
		this.pos += 1;

		if (this.pos < this.ast.length)
			this.cur = this.ast[this.pos];
		else
			this.end = false;
	}

	DataType IntOp(string op, DataType left, DataType right){
		if (op == "+")
			return new Number(left.number + right.number);
		
		else if (op == "-")
			return new Number(left.number - right.number);
		
		else if (op == "*")
			return new Number(left.number * right.number);
		
		else if (op == "/")
			return new Number(left.number / right.number);

		else if (op == "%")
			return new Number(left.number % right.number);

		else if (op == "=="){
			if (left.number == right.number)
				return new True();
			
			return new False();

		} else if (op == "!="){
			if (left.number != right.number)
				return new True();
			
			return new False();

		} else if (op == ">"){
			if (left.number > right.number)
				return new True();
			
			return new False();

		} else if (op == "<"){
			if (left.number < right.number)
				return new True();
			
			return new False();

		} else if (op == "<="){
			if (left.number <= right.number)
				return new True();
			
			return new False();

		} else if (op == ">="){
			if (left.number >= right.number)
				return new True();
			
			return new False();

		} else if (op == "AA"){
			return new Number(left.number+1);

		} else if (op == "MM"){
			return new Number(left.number-1);

		} else if (op == "IN"){
			if (find(right.__str__, left.__str__).length)
				return new True();

			return new False();

		} else if (op == "OR"){
			if (left.capable || right.capable)
				return new True();
			
			return new False();

		} else if (op == "AND"){
			if (left.capable && right.capable)
				return new True();
			
			return new False();

		} else if (op == "NOT"){
			if (right.capable)
				return new False();
			
			return new True();

		}

		return new DataType();
	}

	DataType StrOp(string op, DataType left, DataType right){
		if (op == "+"){
			return new String(left.__str__ ~ right.__str__);

		} else if (op == "=="){
			if (left.__str__ == right.__str__)
				return new True();
			
			return new False();

		} else if (op == "!="){
			if (left.__str__ != right.__str__)
				return new True();
			
			return new False();

		} else if (op == "IN"){
			if (find(right.__str__, left.__str__).length)
				return new True();

			return new False();

		} else if (op == "OR"){
			if (left.capable || right.capable)
				return new True();
			
			return new False();

		} else if (op == "AND"){
			if (left.capable && right.capable)
				return new True();
			
			return new False();

		} else if (op == "NOT"){
			if (right.capable)
				return new False();
			
			return new True();

		} else if (op == "*"){
			string mult;

			for(double i = 0; i < right.number; i++){
				mult ~= left.__str__;
			}

			return new String(mult);		
		} 

		return new DataType();
	}

	DataType BoolOp(string op, DataType left, DataType right){
		if (op == "=="){
			if (left.__str__ == right.__str__){
				return new True();
			}
			return new False();

		} else if (op == "!="){
			if (left.__str__ != right.__str__){
				return new True();
			}
			return new False();

		} else if (op == "IN"){
			if (find(right.__str__, left.__str__).length){
				return new True();
			}

			return new False();

		} else if (op == "OR"){
			if (left.capable || right.capable){
				return new True();
			}
			return new False();

		} else if (op == "AND"){
			if (left.capable && right.capable){
				return new True();
			}
			return new False();

		} else if (op == "NOT"){
			if (right.capable){
				return new False();
			}
			return new True();

		}

		return new None();
	}

	DataType Package(Node data){
		DataType left = this.visit(data.leftRight[0]);
		DataType right = this.visit(data.leftRight[1]);

		if (typeid(left) == typeid(Number))
			return IntOp(data.str, left, right);
		else
			return BoolOp(data.str, left, right);
		
		return new DataType();
	}

	DataType Function(Node data){
		DataType[] defaults;

		foreach(Node i; data.leftRight)
			defaults ~= this.visit(i);

		return new Func(data.str, data.args, defaults, data.params, this.hash, this.file, this.errors);
	}

	DataType ListData(Node data){
		DataType[] list;

		foreach(Node i; data.params){
			list ~= this.visit(i);
		}

		return new List(list);
	}

	DataType DictData(Node data){
		DataType[string] dict; 

		for(int i = 0; i < data.params.length; i++)
			dict[data.args[i]] = this.visit(data.params[i]);

		return new Dict(dict);
	}

	DataType Format(Node data){
		string str;
		foreach(Node i; data.params){
			if (typeid(i) == typeid(StringNode)){
				str ~= i.str;
			} else {
				str ~= this.visit(i).__str__;
			}
		}
	
		return new String(str);
	}

	DataType cAssign(Node data){
		if (this.visit(data.params[0]).capable)
			return this.visit(data.params[1]);
		else
			return this.visit(data.params[2]);

		return new DataType();
	}

	DataType visit(Node data){
		if (typeid(data) == typeid(IdNode)){

			if (data.str in this.hash)
				return this.hash[data.str];

			else {
				Err = "VarError||var '" ~ data.str ~ "' is not defined.";
				this.errors.traceback ~= new Locate(data.line, this.file, data.index);

				throw new Exception(Err, this.file, cast(ulong)data.line);
			}

		} else if (typeid(data) == typeid(CallNode)){
			return this.call_function(data);

		} else if (typeid(data) == typeid(GetNode)){
			return this.get_attribute(data);

		} else if (typeid(data) == typeid(NumberNode)){
			return new Number(data.f64);

		} else if (typeid(data) == typeid(StringNode)){
			return new String(data.str);

		} else if (typeid(data) == typeid(BinaryNode)){
			return this.Package(data);

		} else if (typeid(data) == typeid(FormatNode)){
			return this.Format(data);

		} else if (typeid(data) == typeid(ListNode)){
			return this.ListData(data);

		} else if (typeid(data) == typeid(NullNode)){
			return new None();

		} else if (typeid(data) == typeid(TrueNode)){
			return new True();
		
		} else if (typeid(data) == typeid(FalseNode)){
			return new False();

		} else if (typeid(data) == typeid(IndexNode)) {
			return this.get_index(data);

		} else if (typeid(data) == typeid(FunctionNode)){
			return this.Function(data);

		} else if (typeid(data) == typeid(DictNode)){
			return this.DictData(data);

		} else if (typeid(data) == typeid(cAssignNode)){
			return this.cAssign(data);
		}

		return new DataType();
	}

	void make_variable(){
		this.hash[this.cur.str] = this.visit(this.cur.expr);
	}

	DataType call_function(Node data){
		DataType fun = this.visit(data.expr);
		DataType[] args;
		ERROR err = this.errors;

		foreach(Node i; data.params)
			args ~= this.visit(i);

		this.hash["FN_LOC"].__array__[0] = new String(this.file);
		this.hash["FN_LOC"].__array__[1] = new Number(data.line);

		err.traceback ~= new Locate(data.line, this.file, data.index);
		DataType retun = fun.__call__(args);

		err.traceback = err.traceback.remove(err.traceback.length-1);
		return retun;
	}

	DataType get_attribute(Node data){
		DataType key = this.visit(data.expr);

		if (data.exe){
			key.attrs[data.str] = this.visit(data.expr2);
			return new None();
		}

		if (data.str in key.attrs)
			return key.attrs[data.str];

		// REPORTING ERROR
		Err = "PropertyError||'" ~ key.__type__ ~ "' object has no attribute '"~ data.str~"'";
		this.errors.traceback ~= new Locate(data.line, this.file, data.index);

		throw new Exception(Err, this.file, cast(ulong)data.line);
	}

	DataType get_index(Node data){
		DataType key = this.visit(data.leftRight[0]);
		DataType index = this.visit(data.leftRight[1]);

		if (data.exe){
			if (typeid(key) == typeid(List) || typeid(key) == typeid(Dict)){
				key.__index__([index, this.visit(data.leftRight[2])]);
			}
		} else {
			if (typeid(key) == typeid(List) || typeid(key) == typeid(String) || typeid(Dict)){
				return key.__call__([index]);
			}
		}

		return new None();
	}

	void if_flow(Node[] data){
		DataType[string] inform;

		foreach(Node i; data){
			if(this.visit(i.expr).capable){
				inform = new Eval(i.params, this.hash, this.file, this.errors).info;

				if (inform["modified"].capable){
					this.info = inform;
					this.end = false;
				}

				break;
			}
		}
	}

	void while_flow(Node data){
		if (this.visit(data.expr).capable){
			DataType[string] res = new Eval(data.params, this.hash, this.file, this.errors).info;

			if (res["modified"].capable){
				if (res["modified"].__str__ == "return"){
					this.info["modified"] = res["modified"];
					this.info["return"] = res["return"];
					this.end = false;
				
				} else if (res["modified"].__str__ == "error"){
					this.info["modified"] = res["modified"];
					this.info["return"] = res["return"];
					this.end = false;
				}
			}
		}
	}

	void switch_flow(Node data){
		string Qn = this.visit(data.expr).__str__;
		string Ans;

		foreach(Node i; data.params){
			Ans = this.visit(i.expr).__str__;

			if (Ans == Qn){
				new Eval(i.params, this.hash, this.file, this.errors);

				if (i.opt)
					break;
			}
		}
	}

	void for_flow(Node data){
		DataType i = this.ITER.__call__([visit(data.expr)]);
		DataType x = this.NEXT.__call__([i]);

		if (typeid(x) != typeid(EOI)){
			this.hash[data.str] = x;
			DataType[string] res = new Eval(data.params ~ new FrNode(data.str, i), this.hash, this.file, this.errors).info;

			if (res["modified"].capable){
				if (res["modified"].__str__ == "return"){
					this.info["modified"] = res["modified"];
					this.info["return"] = res["return"];
					this.end = false;
				
				} else if (res["modified"].__str__ == "error"){
					this.info["modified"] = res["modified"];
					this.info["return"] = res["return"];
					this.end = false;
				}
			}
		}
	}

	void class_data(Node data){
		string[] attrs;

		foreach(Node i; data.params){
			if (typeid(i) == typeid(FunctionNode))
				attrs ~= i.str;

			else if (typeid(i) == typeid(VarNode))
				attrs ~= i.str;			
		}

		this.hash[data.str] = new Class(data.str, data.leftRight,
			data.params, this.hash, attrs, this.file, this.errors);
	}

	void try_flow(Node data){
		DataType[string] res;

		try {
			res = new Eval(data.params[0].params, this.hash, this.file, this.errors).info;

		} catch (Exception e){
			if (data.params.length > 1){
				this.errors.traceback = this.errors.traceback.remove(this.errors.traceback.length-1);

				string[] errT = split(e.msg, "||");
				Node E = data.params[1];

				if (errT.length == 1)
					this.hash[E.str] = new _Exception(errT[0], e.file, e.line);

				else {
					if (errT[0] == "Exception")
						this.hash[E.str] = new _Exception(errT[1], e.file, e.line, "Exception");

					else
						this.hash[E.str] = new _Exception(errT[1], e.file, e.line, errT[0]);
				}

				res = new Eval(E.params, this.hash, this.file, this.errors).info;
			}
		}
	}

	void import_module(Node data){
		string[] modules = data.args;
		string paths;

		if (typeid(data.expr) == typeid(NullNode)){
			foreach(string i, u; data.strs){
				paths = config.check(IMPORTED_MODULES["pazle"].attrs["path"], i, IMPORTED_MODULES);

				if (paths.length)
					this.hash[u] = config.act(this, paths, i, IMPORTED_MODULES);

				else {
					Err = "ImportError||Module '" ~ i ~ "' is not found.";
					this.errors.traceback ~= new Locate(data.line, this.file, data.index);

					throw new Exception(Err, this.file, cast(ulong)data.line);
				}
			}
		
		} else {
			string Module_path, path;

			foreach(string i, u; data.strs){
				path = this.visit(data.expr).__str__ ~ "/" ~ i;
				Module_path = config.check(IMPORTED_MODULES["pazle"].attrs["path"], path, IMPORTED_MODULES);

				if (Module_path.length)
					this.hash[u] = config.act(this, Module_path, i, IMPORTED_MODULES);
				
				else {
					Err = "ImportError||Module path '" ~ path ~ "' is not found.";
					this.errors.traceback ~= new Locate(data.line, this.file, data.index);

					throw new Exception(Err, this.file, cast(ulong)data.line);
				}
			}
		}
	}

	void include_module(){
		foreach (string i; this.cur.args){
			if (exists(i))
				config.Include(i, this);
			
			else {
				Err = "ImportError||file '" ~ i ~ "' is not found.";
				this.errors.traceback ~= new Locate(this.cur.line, this.file, this.cur.index);

				throw new Exception(Err, this.file, cast(ulong)this.cur.line);
			}
		}
	}

	void evaluate(){
		while (this.end){
			if (typeid(this.cur) == typeid(VarNode)){
				this.make_variable();

			} else if (typeid(this.cur) == typeid(CallNode)){
				this.visit(this.cur);

			} else if (typeid(this.cur) == typeid(GetNode)){
				this.visit(this.cur);
				
			} else if (typeid(this.cur) == typeid(IfStatementNode)){
				this.if_flow(this.cur.params);

			} else if (typeid(this.cur) == typeid(WhlNode)) {
				if (this.visit(cur.expr).capable){
					this.pos = -1;
				} else {
					break;
				}

			} else if (typeid(this.cur) == typeid(FrNode)) {
				DataType x = this.NEXT.__call__([this.cur.fetch]);

				if (typeid(x) != typeid(EOI)){
					this.hash[this.cur.str] = x;
					this.pos = -1;

				} else{
					break;
				}

			} else if (typeid(this.cur) == typeid(SwNode)) {
				this.switch_flow(this.cur);

			} else if (typeid(this.cur) == typeid(IndexNode)){
				this.visit(this.cur);

			} else if (typeid(this.cur) == typeid(BreakNode)){
				this.info["loop"] = new String(this.cur.str);
				this.info["modified"] = new String("loop");
				break;

			} else if (typeid(this.cur) == typeid(ReturnNode)) {
				DataType res = this.visit(this.cur.expr);
				this.info["return"] = res;
				this.info["modified"] = new String("return");
				break;

			} else if (typeid(this.cur) == typeid(WhileNode)) {
				this.while_flow(this.cur);

			} else if (typeid(this.cur) == typeid(ForNode)) {
				this.for_flow(this.cur);

			} else if (typeid(this.cur) == typeid(TryNode)) {
				this.try_flow(this.cur);

			} else if (typeid(this.cur) == typeid(FunctionNode)){
				this.hash[this.cur.str] = this.visit(this.cur);

			} else if (typeid(this.cur) == typeid(ClassNode)){
				this.class_data(this.cur);
			
			} else if (typeid(this.cur) == typeid(ImportNode)){
				this.import_module(this.cur);

			} else if (typeid(this.cur) == typeid(IncludeNode)){
				this.include_module();

			}

			this.next();
		}
	}
}


