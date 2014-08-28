﻿module seeds.ColumnConverter;

import std.conv;
import std.datetime;
import std.regex;

class ColumnConversionException : Exception {
	this(string s) { super(s); }
}

class ColumnConverter(Options ...) {
	static T convert(T)(string data) {
		return to!(T)(data);
	}

	static T convert(T : bool)(string data) {
		if(data.length == 0) return false;
		import std.stdio;
		writeln(data);
		if (match(data, ctRegex!(`^[fn0]`, "i"))) return false;
		return true;
	}

	static T convert(T : Date)(string data) {
		return Date();
	}

	static Date dayMonthYear(string data) {
		auto m = splitDate(data);
		if (m) {
			return Date(to!int(m.captures[3]), to!int(m.captures[2]), to!int(m.captures[1]));
		} else {
			throw new ColumnConversionException("Could not convert '" ~ data ~ "' to Date (DMY)");
		}
	}
	
	static Date monthDayYear(string data) {
		auto m = splitDate(data);
		if (m) {
			return Date(to!int(m.captures[3]), to!int(m.captures[1]), to!int(m.captures[2]));
		} else {
			throw new ColumnConversionException("Could not convert '" ~ data ~ "' to Date (MDY)");
		}
	}
	
	protected {
		static auto splitDate(string data) {
			static const string separator = `[\\\/-]`;
			static auto dateRegex = ctRegex!(`^(\d{1,2})` ~ separator ~ `(\d{1,2})` ~ separator ~ `(\d{4}|\d{2})$`);
			return match(data, dateRegex);
		}
	}
}

alias DefaultColumnConverter = ColumnConverter!();

unittest {
	assert(DefaultColumnConverter.convert!int("123") == 123);
}
