module lexer;

import node;

import std.uni;
import std.conv;
import std.range;
import std.stdio;
import std.array;
import std.digest;
import std.algorithm;
import std.typecons;



string letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_$";
string keys =  "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_$?!1234567890";
string numbers = "1234567890";
string numbs = "1234567890e.x_";
string meters = "?;,({[]}):.";
string expr = "=!<>";
string aliases = "&|";
string operators = "+-*/%";


class Lex{
	int pos, line, tab, loc;
	Token[] tokens;
	string code;
	char tok;
	bool end;

	this(string code){
		this.code = code;
		this.pos = -1;
		this.tok = tok;
		this.loc = -1;
		this.tab = 0;
		this.line = 1;
		this.tokens = tokens;
		this.end = true;
		this.next();
		this.parse();
	}

	void next(){
		this.pos += 1;
		this.loc += 1;

		//writeln(this.loc,"  ", this.tok,"  ", this.line);

		if (this.pos < this.code.length){
			this.tok = this.code[this.pos];
		} else {
			this.end = false;
		}
	}

	void back(){
		this.pos -= 1;
		this.loc -= 1;

		this.tok = this.code[this.pos];
	}

	void rString(){
		char quot = this.tok;
		string str;
		this.next();

		while (this.end && this.tok != quot && this.tok != '\n'){
			if (this.tok == '\\'){
				this.next();
				str ~= '\\';

				if (this.end){
					str ~= this.tok;
					this.next();
				}

			} else {
				str ~= this.tok;
				this.next();
			}
		}

		this.next();
		this.tokens ~= new Token(str, "STR", this.tab, this.line, this.loc);
	}

	void lex_keywords(){
		string key;
		while (this.end && find(keys, this.tok).length){
			key ~= this.tok;
			this.next();
		}

		this.loc-=1;

		switch (key){
			case "if":
				this.tokens ~= new Token(key, "IF", this.tab, this.line, this.loc);
				break;
			case "else":
				this.tokens ~= new Token(key, "ELSE", this.tab, this.line, this.loc);
				break;
			case "elif":
				this.tokens ~= new Token(key, "ELIF", this.tab, this.line, this.loc);
				break;
			case "in":
				this.tokens ~= new Token(key, "IN", this.tab, this.line, this.loc);
				break;
			case "return":
				this.tokens ~= new Token(key, "RET", this.tab, this.line, this.loc);
				break;
			case "true":
				this.tokens ~= new Token(key, "TRUE", this.tab, this.line, this.loc);
				break;
			case "false":
				this.tokens ~= new Token(key, "FALSE", this.tab, this.line, this.loc);
				break;
			case "null":
				this.tokens ~= new Token(key, "NONE", this.tab, this.line, this.loc);
				break;
			case "while":
				this.tokens ~= new Token(key, "WHILE", this.tab, this.line, this.loc);
				break;
			case "for":
				this.tokens ~= new Token(key, "FOR", this.tab, this.line, this.loc);
				break;
			case "switch":
				this.tokens ~= new Token(key, "SWITCH", this.tab, this.line, this.loc);
				break;
			case "case":
				this.tokens ~= new Token(key, "CASE", this.tab, this.line, this.loc);
				break;
			case "break":
				this.tokens ~= new Token(key, "BREAK", this.tab, this.line, this.loc);
				break;
			case "default":
				this.tokens ~= new Token(key, "DF", this.tab, this.line, this.loc);
				break;
			case "continue":
				this.tokens ~= new Token("cont", "CONT", this.tab, this.line, this.loc);
				break;
			case "try":
				this.tokens ~= new Token(key, "TRY", this.tab, this.line, this.loc);
				break;
			case "except":
				this.tokens ~= new Token(key, "CATCH", this.tab, this.line, this.loc);
				break;
			case "def":
				this.tokens ~= new Token(key, "FN", this.tab, this.line, this.loc);
				break;
			case "function":
				this.tokens ~= new Token(key, "FN", this.tab, this.line, this.loc);
				break;
			case "and":
				this.tokens ~= new Token(key, "AND", this.tab, this.line, this.loc);
				break;
			case "or":
				this.tokens ~= new Token(key, "OR", this.tab, this.line, this.loc);
				break;
			case "not":
				this.tokens ~= new Token(key, "NOT", this.tab, this.line, this.loc);
				break;
			case "import":
				this.tokens ~= new Token(key, "IM", this.tab, this.line, this.loc);
				break;
			case "from":
				this.tokens ~= new Token(key, "FR", this.tab, this.line, this.loc);
				break;
			case "as":
				this.tokens ~= new Token(key, "AS", this.tab, this.line, this.loc);
				break;
			case "defobject":
				this.tokens ~= new Token(key, "CL", this.tab, this.line, this.loc);
				break;
			case "let":
				break;
			default:
				if (key == "r" && find("'\"", this.tok).length){
					this.rString();

				} else if (key == "f" && find("'\"", this.tok).length){
					this.tokens ~= new Token(this.lex_string, "FMT", this.tab, this.line, this.loc);

				} else {
					this.tokens ~= new Token(key, "ID", this.tab, this.line, this.loc);
				}

				break;
		}

		this.loc += 1;
	}

	void lex_operators(){
		string toky;
		toky ~= this.tok;
		this.next();

		if (this.tok == '='){
			this.tokens ~= new Token(toky, "AA", this.tab, this.line, this.loc);
			this.next();

		} else if (this.tok == '/'){
			while (this.end && this.tok != '\n')
				this.next;

			this.next();
			
		} else
			this.tokens ~= new Token(toky, toky, this.tab, this.line, this.loc-1);
	}

	void lex_meters(){
		string[char] metersCase = ['.': ".", ',': ",", ';': ";", ':': ":", '[': "[", ']': "]", '{': "{", '}': "}", '(': "(", ')': ")", '?':"?"];
		this.tokens ~= new Token(metersCase[this.tok], metersCase[this.tok], this.tab, this.line, this.loc);
		this.next();
	}

	void lex_expr(){
		string option;
		option ~= this.tok;
		this.next();

		if (this.tok == '='){
			this.next();

			switch (option){
				case "=":
					this.tokens ~= new Token("==", "==", this.tab, this.line, this.loc);
					break;
				case "<":
					this.tokens ~= new Token("<=", "<=", this.tab, this.line, this.loc);
					break;
				case ">":
					this.tokens ~= new Token(">=", ">=", this.tab, this.line, this.loc);
					break;
				default:
					this.tokens ~= new Token("!=", "!=", this.tab, this.line, this.loc);
					break;
			}

		} else if (this.tok == '>' && option == "="){
			this.next();
			this.tokens ~= new Token("=>", "ARR", this.tab, this.line, this.loc);

		} else if (option == "!") {
			this.tokens ~= new Token(option, "NOT", this.tab, this.line, this.loc);


		} else {
			this.tokens ~= new Token(option, option, this.tab, this.line, this.loc);
		}
	}

	string get_hexidecimal(){
		this.next();
		string hex;

		while (this.end && find("0123456789abcdef", this.tok).length){
			hex ~= this.tok;
			this.next();
		}

		this.back();

		long hexed = to!long(hex, 16);
		return to!string(hexed);
	}

	string get_exp_num(){
		this.next();

		string Exp;
		string zeros;

		while (this.end && find("0123456789", this.tok).length){
			Exp ~= this.tok;
			this.next();
		}

		for(int i = 0; i < to!int(Exp); i++)
			zeros ~= "0";

		return zeros;
	}

	void pass(){}

	void lex_number(){
		string num;

		while (this.end && find(numbs, this.tok).length){
			if (this.tok == '_')
				pass;

			else if (this.tok == 'x')
				num = get_hexidecimal();

			else if (this.tok == 'e')
				num ~= get_exp_num();
			
			else
				num ~= this.tok;
			
			this.next();
		}

		this.tokens ~= new Token(num, "NUM", this.tab, this.line, this.loc);
	}

	void Aliases(){
		string op;
		op ~= this.tok;
		this.next();

		if (find("&|", this.tok).length){
			op ~= this.tok;
			this.next();
		}

		if (op == "&&"){
			this.tokens ~= new Token(op, "AND", this.tab, this.line, this.loc);
		} else {
			this.tokens ~= new Token(op, "OR", this.tab, this.line, this.loc);
		}
	}

	string get_hex_unicode(){
		string hex;

		while (hex.length < 2) {
			this.next();
			hex ~= this.tok;
		}

		return std.range.chunks(hex, 2).map!(i => cast(char)i.to!ubyte(16)).array;
	}

	string get_escaped(){
		this.next();

		string str;
		char[char] escapes = ['r':'\r', 't':'\t', 'n':'\n', 'b':'\b', '\\':'\\', '0':'\0', 'a':'\a', 'f':'\f', 'v':'\v', '\'':'\'', '"': '\"', '`':'`', '?': '\?'];

		if (this.end) {
			if (find("rtnb0afv?\\'\"", this.tok).length)
				return (str ~ escapes[this.tok]);

			else if (this.tok == 'x')
				return get_hex_unicode();
		}

		return "";
	}

	string lex_string(){
		char key;
		char quot = this.tok;
		string str, chars;
		this.next();

		while (this.end && this.tok != quot && this.tok != '\n'){
			if (this.tok == '\\')
				str ~= get_escaped();
			else 
				str ~= this.tok;
			
			this.next();
		}

		this.next();
		return str;
	}

	string lex_multline_string(){
		string str;
		char key;
		this.next();

		while (this.end && this.tok != '`'){
			if (this.tok == '\\')
				str ~= get_escaped();
			else
				str ~= this.tok;

			this.next();
		}

		this.next();
		return str;
	}

	void parse(){
		while (this.end){
			if (find(letters, this.tok).length){
				this.lex_keywords();

			} else if (find(meters, this.tok).length){
				this.lex_meters();

			} else if (find(operators, this.tok).length){
				this.lex_operators();

			} else if (find("\"'", this.tok).length){
				this.loc-=1;
				this.tokens ~= new Token(this.lex_string, "STR", this.tab, this.line, this.loc);
				this.loc+=1;

			} else if (find(numbers, this.tok).length){
				this.lex_number();

			} else if (this.tok == '\n'){
				this.tokens ~= new Token("\\n", "NL", this.tab, this.line, this.loc);
				this.tab = 0;
				this.loc = -1;
				
				this.next();
				this.line += 1;

			} else if (this.tok == '\t'){
				this.tab += 1;
				this.next();

			} else if (find("&|", this.tok).length) {
				this.Aliases();

			} else if (find(expr, this.tok).length){
				this.lex_expr();

			} else if (this.tok == '#') {
				this.next();

				while (this.end && this.tok != '\n')
					this.next();
				
				this.next();

			} else if(this.tok == '`'){
				this.tokens ~= new Token(this.lex_multline_string, "STR", this.tab, this.line, this.loc);

			} else if (this.tok == ' ') {
				string tabz;

				while (this.end && this.tok == ' '){
					tabz ~= this.tok;
					this.next();

					if (tabz == "  "){
						tabz = "";
						this.tab += 1;
					}
				}

			} else {
				this.next();
			}
		}

		if (this.tokens.length > 0){
			this.tokens ~= new Token("EOF", "NL", this.tab, this.line, this.loc);
		}		
	}
}


