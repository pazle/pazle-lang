module node;

import eval;

import std.stdio;
import Object.datatype;


class Token{
	string value;
	string type;
	int tab, line, loc;

	this(string value, string type, int pos, int line, int loc){
		this.value = value;
		this.type = type;
		this.tab = pos;
		this.line = line;
		this.loc = loc;
	}
}


class Node{

	string str(){
		return "undef";
	}

	double f64(){
		return 0.1;
	}

	int exe(){
		return 0;
	}

	int line(){
		return 0;
	}

	int index(){
		return 0;
	}

	bool opt(){
		return false;
	}

	Node[] leftRight(){
		return [];
	}

	Node expr(){
		return new Node;
	}

	Node expr2(){
		return new Node;
	}

	Node[] params(){
		return [new Node];
	}

	string[] args(){
		return [""];
	}

	string[string] strs(){
		return strs;
	}

	DataType fetch(){
		return new DataType();
	}
}


class IdNode: Node{
	int pos, loc;
	string key;

	this(string key, int pos = 0, int loc = 0){
		this.key = key;
		this.pos = pos;
		this.loc = loc;
	}

	override string str(){
		return this.key;
	}

	override int line(){
		return this.pos;
	}

	override int index(){
		return this.loc;
	}
}


class NumberNode: Node{
	double value;

	this(double value){
		this.value = value;
	}

	override double f64(){
		return this.value;
	}
}


class StringNode: Node{
	string value;

	this(string value){
		this.value = value;
	}

	override string str(){
		return this.value;
	}
}


class FormatNode: Node{
	Node[] forms;

	this(Node[] forms){
		this.forms = forms;
	}

	override Node[] params(){
		return this.forms;
	}
}

class cAssignNode: Node{
	Node[] forms;

	this(Node[] forms){
		this.forms = forms;
	}

	override Node[] params(){
		return this.forms;
	}
}


class ListNode: Node{
	Node[] list;

	this(Node[] list){
		this.list = list;
	}

	override Node[] params(){
		return this.list;
	}
}

class ImportNode: Node{
	int loc, pos;
	string[string] modules;
	Node path;

	this(string[string] modules, Node path, int pos = 0, int loc=0){
		this.modules = modules;
		this.path = path;
		this.pos = pos;
		this.loc = loc;
	}

	override string[string] strs(){
		return this.modules;
	}

	override Node expr(){
		return this.path;
	}

	override int line(){
		return this.pos;
	}

	override int index(){
		return this.loc;
	}
}

class IncludeNode: Node{
	string[] modules;
	int loc, pos;

	this(string[] modules, int pos = 0, int loc = 0){
		this.modules = modules;
		this.pos = pos;
		this.loc = loc;
	}

	override string[] args(){
		return this.modules;
	}

	override int line(){
		return this.pos;
	}

	override int index(){
		return this.loc;
	}
}


class DictNode: Node{
	string[] keys;
	Node[] values;

	this(string[] keys, Node[] values){
		this.keys = keys;
		this.values = values;
	}

	override string[] args(){
		return this.keys;
	}

	override Node[] params(){
		return this.values;
	}
}


class TrueNode: Node{
}

class FalseNode: Node{
}

class NullNode: Node{
}


class BinaryNode: Node{
	Node left;
	string op;
	Node right;
	int pos, loc;

	this(Node left, string op, Node right, int pos = 0, int loc = 0){
		this.left = left;
		this.op = op;
		this.right = right;
		this.pos = pos;
		this.loc = loc;
	}

	override Node[] leftRight(){
		return [this.left, this.right];
	}

	override string str(){
		return this.op;
	}

	override int line(){
		return this.pos;
	}

	override int index(){
		return this.loc;
	}
}


class VarNode: Node{
	string key;
	Node ast;

	this(string key, Node ast){
		this.key = key;
		this.ast = ast;
	}

	override string str(){
		return this.key;
	}

	override Node expr(){
		return this.ast;
	}
}


class CallNode: Node{
	int pos, loc;
	Node ast;
	Node[] args;

	this(Node ast, Node[] args, int pos = 0, int loc = 0){
		this.ast = ast;
		this.args = args;
		this.pos = pos;
		this.loc = loc;
	}

	override Node expr(){
		return this.ast;
	}

	override Node[] params(){
		return this.args;
	}

	override int line(){
		return this.pos;
	}

	override int index(){
		return this.loc;
	}
}


class GetNode: Node{
	int assign, loc, pos;
	Node ast;
	string key;
	Node value;

	this(Node ast, string key, int assign, Node value, int pos = 0, int loc=0){
		this.ast = ast;
		this.key = key;
		this.assign = assign;
		this.value = value;
		this.pos = pos;
		this.loc = loc;
	}

	override int exe(){
		return this.assign;
	}

	override Node expr(){
		return this.ast;
	}

	override Node expr2(){
		return this.value;
	}

	override string str(){
		return this.key;
	}

	override int line(){
		return this.pos;
	}

	override int index(){
		return this.loc;
	}
}

class IndexNode: Node{
	int assign, pos;
	Node ast;
	Node index;
	Node value;

	this(Node ast, Node index, int assign, Node value, int pos = 0){
		this.ast = ast;
		this.index = index;
		this.assign = assign;
		this.value = value;
		this.pos = pos;
	}

	override int exe(){
		return this.assign;
	}

	override Node[] leftRight(){
		return [this.ast, this.index, this.value];
	}

	override int line(){
		return this.pos;
	}
}


class FunctionNode: Node{
	string key;
	Node[] code;
	string[] par;
	Node[] defaults;

	this(string key, string[] par, Node[] defaults, Node[] code){
		this.key = key;
		this.par = par;
		this.code = code;
		this.defaults = defaults;
	}

	override string str(){
		return this.key;
	}

	override Node[] params(){
		return this.code;
	}

	override Node[] leftRight(){
		return this.defaults;
	}

	override string[] args(){
		return this.par;
	}
}


class ClassNode: Node{
	string name;
	Node[] args;
	Node[] code;

	this(string name, Node[] args, Node[] code){
		this.name = name;
		this.args = args;
		this.code = code;
	}

	override string str(){
		return this.name;
	}

	override Node[] params(){
		return this.code;
	}

	override Node[] leftRight(){
		return this.args;
	}
}


class ReturnNode: Node{
	Node ast;

	this(Node ast){
		this.ast = ast;
	}

	override Node expr(){
		return this.ast;
	}
}


class IfNode: Node{
	Node ast;
	Node[] code;

	this(Node ast, Node[] code){
		this.ast = ast;
		this.code = code;
	}

	override Node expr(){
		return this.ast;
	}

	override Node[] params(){
		return this.code;
	}
}


class IfStatementNode: Node{
	Node[] code;

	this(Node[] code){
		this.code = code;
	}

	override Node[] params(){
		return this.code;
	}
}


class WhlNode: Node{
	Node ast;

	this(Node ast){
		this.ast = ast;
	}

	override Node expr(){
		return this.ast;
	}
}


class WhileNode: Node{
	Node ast;
	Node[] code;

	this(Node ast, Node[] code){
		this.ast = ast;
		this.code = code;
	}

	override Node expr(){
		return this.ast;
	}

	override Node[] params(){
		return this.code ~ new WhlNode(this.ast);
	}
}


class FrNode: Node{
	string keys;
	DataType expr;

	this(string keys, DataType expr){
		this.keys = keys;
		this.expr = expr;
	}

	override DataType fetch(){
		return this.expr;
	}

	override string str(){
		return this.keys;
	}
}


class ForNode: Node{
	Node ast;
	Node[] code;
	string keys;

	this(string keys, Node ast, Node[] code){
		this.ast = ast;
		this.code = code;
		this.keys = keys;
	}

	override Node expr(){
		return this.ast;
	}

	override string str(){
		return this.keys;
	}

	override Node[] params(){
		return this.code;
	}
}


class SwNode: Node{
	Node ast;
	Node[] code;

	this(Node ast, Node[] code){
		this.ast = ast;
		this.code = code;
	}

	override Node expr(){
		return this.ast;
	}

	override Node[] params(){
		return this.code;
	}
}


class CsNode: Node{
	bool bk;
	Node ast;
	Node[] code;

	this(Node ast, Node[] code, bool bk){
		this.bk = bk;
		this.ast = ast;
		this.code = code;
	}

	override Node expr(){
		return this.ast;
	}

	override Node[] params(){
		return this.code;
	}

	override bool opt(){
		return this.bk;
	}
}

class BreakNode: Node{
	string log;

	this(string log){
		this.log = log;
	}

	override string str(){
		return this.log;
	}
}


class ERROR{
	Node[] traceback;
	
	this(){
		this.traceback = traceback;
	}
}

class Locate: Node{
	int pos, loc;
	string file;

	this(int pos, string file, int loc = 0){
		this.file = file;
		this.pos = pos;
		this.loc = loc;
	}

	override string str(){
		return this.file;
	}

	override int line(){
		return this.pos;
	}

	override int index(){
		return this.loc;
	}
}


class CatchNode: Node{
	string id;
	Node[] code;

	this(string id, Node[] code){
		this.id = id;
		this.code = code;
	}

	override Node[] params(){
		return this.code;
	}

	override string str(){
		return this.id;
	}
}

class TryNode: Node{
	Node[] code;

	this(Node[] code){
		this.code = code;
	}

	override Node[] params(){
		return this.code;
	}
}
