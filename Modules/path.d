module Modules.path;

import core.stdc.errno;
import std.exception;
import std.stdio;
import std.conv;
import std.file;
import std.path;
import std.datetime: SysTime, Clock, seconds;

import Object.datatype;
import Object.boolean;
import Object.strings;
import Object.numbers;
import Object.classes;
import Object.bytes;
import Object.lists;


class Paths: DataType{
	DataType[string] attributes;

	this(){
		this.attributes = [
			"cd": new Cd(),

			"readdir": new Readdir(),
			"cwd": new Cwd(),

			"dirsep": new String(dirSeparator),
			"pathsep": new String(pathSeparator),

			"readlink": new Linksto(),
			"ext": new Extension(),
			"isdir": new Isdir(),
			"isfile": new Isfile(),
			"islink": new Islink(),
			"rename": new Rename(),
			"remove": new Remove(),
			"mkdir": new Mkdir(),
			"rmdir": new Rmdir(),
			"mklink": new Mklink(),
			"exists": new Exists(),
			"copy": new Copy(),
			"absolute": new Absolute(),
			"isabsolute_path": new Isabsolute(),
			"relative": new Relative(),

			"tempdir": new Tempdir(),

			"basename": new Basename(),
			"dirname": new Dirname(),
			"drivename": new Drivename(),
			"rootname": new Rootname(),

			"split": new Split(),
			"freespace": new Freespace(),
			"stat": new Stat(),
			"s_drive": new Stripdrive(),
			"stripExtension": new StripExtension(),
			"starts_at_root": new Startsroot(),
			"isvalid_filename": new Isvalidfilename(),
			"isvalid_path": new Isvalidpathname(),
		];
	}

	override DataType[string] attrs() { return this.attributes;}
	override string __str__() { return "path (builtin module)"; }
}


class Cwd: DataType{
	override DataType __call__(DataType[] params){
		return new String(getcwd());
	}
	override string __str__() {return "cwd (path method)"; }
}


class Tempdir: DataType{
	override DataType __call__(DataType[] params){
		return new String(tempDir());
	}
	override string __str__() {return "tempdir (path method)"; }
}


class Exists: DataType{
	override DataType __call__(DataType[] params){
		if (exists(params[0].__str__))
			return new True();

		return new False();
	}
	override string __str__() {return "exists (path method)"; }
}


class Remove: DataType{
	override DataType __call__(DataType[] params){
		remove(params[0].__str__);
		return new None();
	}
	override string __str__() {return "remove (path method)"; }
}



class Isdir: DataType{
	override DataType __call__(DataType[] params){
		if (isDir(params[0].__str__))
			return new True();

		return new False();
	}
	override string __str__() {return "isdir (path method)"; }
}


class Isfile: DataType{
	override DataType __call__(DataType[] params){
		if (params.length){
			if (isFile(params[0].__str__))
				return new True();
		}
		return new False();
	}
	override string __str__() {return "isfile (path method)"; }
}


class Islink: DataType{
	override DataType __call__(DataType[] params){
		if (params.length){
			if (isSymlink(params[0].__str__))
				return new True();
		}
		return new False();
	}
	override string __str__() {return "islink (path method)"; }
}


class Linksto: DataType{
	override DataType __call__(DataType[] params){
		version(Posix){
			if (params.length)
				return new String(readLink(params[0].__str__));
		}
		return new False();
	}
	override string __str__() {return "readlink (path method)"; }
}


class Mklink: DataType{
	override DataType __call__(DataType[] params){
		version(Posix){
			if (params.length > 1)
				symlink(params[0].__str__, params[1].__str__);
		}
		
		return new Number(1);
	}
	override string __str__() {return "mklink (path method)"; }
}


class Readdir: DataType{
	override DataType __call__(DataType[] params){
		string def = "";
		List paths = new List([]);

		if (params.length)
			def = params[0].__str__;

		foreach (string i; dirEntries(def, SpanMode.shallow))
		    paths.__act__(new String(i));
		
		return paths;
	}
	override string __str__() {return "readdir (path method)"; }
}


class Mkdir: DataType{
	override DataType __call__(DataType[] params){
		if (params.length)
			mkdirRecurse(params[0].__str__);

		return new None();
	}
	override string __str__() {return "mkdir (path method)"; }
}


class Rmdir: DataType{
	override DataType __call__(DataType[] params){
		if (params.length)
			rmdirRecurse(params[0].__str__);

		return new None();
	}
	override string __str__() {return "rmdir (path method)"; }
}


class Rename: DataType{
	override DataType __call__(DataType[] params){
		if (params.length > 1)
			rename(params[0].__str__, params[1].__str__);

		return new None();
	}
	override string __str__() {return "rename (path method)"; }
}


class Copy: DataType{
	override DataType __call__(DataType[] params){
		if (params.length > 1)
			copy(params[0].__str__, params[1].__str__);

		return new None();
	}
	override string __str__() {return "copy (path method)"; }
}


class Cd: DataType{
	override DataType __call__(DataType[] params){
		if (params.length)
			chdir(params[0].__str__);

		return new None();
	}
	override string __str__() {return "cd (path method)"; }
}


class Absolute: DataType{
	override DataType __call__(DataType[] params){
		if (params.length)
			return new String(absolutePath(params[0].__str__));

		return new None();
	}
	override string __str__() {return "absolute (path method)"; }
}


class Relative: DataType{
	override DataType __call__(DataType[] params){
		if (params.length)
			return new String(relativePath(params[0].__str__));

		return new None();
	}
	override string __str__() {return "relative (path method)"; }
}


class Isabsolute: DataType{
	override DataType __call__(DataType[] params){
		if (params.length)

			if (isAbsolute(params[0].__str__))
				return new True();

		return new False();
	}
	override string __str__() {return "isabsolute (path method)"; }
}


class Startsroot: DataType{
	override DataType __call__(DataType[] params){
		if (params.length)

			if (isRooted(params[0].__str__))
				return new True();

		return new False();
	}
	override string __str__() {return "starts_at_root (path method)"; }
}


class Isvalidfilename: DataType{
	override DataType __call__(DataType[] params){
		if (params.length && params[0].__str__.length)

			if (isValidFilename(params[0].__str__))
				return new True();

		return new False();
	}
	override string __str__() {return "isvalid_name (path method)"; }
}


class Isvalidpathname: DataType{
	override DataType __call__(DataType[] params){
		if (params.length && params[0].__str__.length)

			if (isValidPath(params[0].__str__))
				return new True();

		return new False();
	}
	override string __str__() {return "isvalid_path (path method)"; }
}


class Basename: DataType{
	override DataType __call__(DataType[] params){		
		return new String(baseName(params[0].__str__));
	}
	override string __str__() {return "basename (path method)"; }
}


class Dirname: DataType{
	override DataType __call__(DataType[] params){		
		return new String(dirName(params[0].__str__));
	}
	override string __str__() {return "dirname (path method)"; }
}



class Drivename: DataType{
	override DataType __call__(DataType[] params){
		return new String(driveName(params[0].__str__));
	}
	override string __str__() {return "drivename (path method)"; }
}


class Rootname: DataType{
	override DataType __call__(DataType[] params){
		return new String(rootName(params[0].__str__));
	}
	override string __str__() {return "rootname (path method)"; }
}


class Split: DataType{
	override DataType __call__(DataType[] params){
		List paths = new List([]);

		if (params.length) {
			foreach(string i; pathSplitter(params[0].__str__))
				paths.__act__(new String(i));
		}

		return paths;
	}
	override string __str__() {return "split (path method)"; }
}


class Stripdrive: DataType{
	override DataType __call__(DataType[] params){
		if (params.length) 
			new String(stripDrive(params[0].__str__));

		return new None();
	}
	override string __str__() {return "s_drive (path method)"; }
}


class StripExtension: DataType{
	override DataType __call__(DataType[] params){
		return new String(stripExtension(params[0].__str__));
	}
	override string __str__() {return "stripExtension (path method)"; }
}


class Extension: DataType{
	override DataType __call__(DataType[] params){
		return new String(extension(params[0].__str__));
	}
	override string __str__() {return "ext (path method)"; }
}


class Freespace: DataType{
	override DataType __call__(DataType[] params){
		if (params.length) 
			return new Number(getAvailableDiskSpace(params[0].__str__));

		return new None();
	}
	override string __str__() {return "freespace (path method)"; }
}


class Stat: DataType{
	override DataType __call__(DataType[] params){
		if (params.length) {
			SysTime accessTime, modificationTime;
			getTimes(params[0].__str__, accessTime, modificationTime);

			return new Obj_("stat (path object)", [
					"t_access": new String(accessTime.toString),
					"t_modification": new String(modificationTime.toString),
				]);
		}

		return new None();
	}
	override string __str__() {return "stat (path method)"; }
}

