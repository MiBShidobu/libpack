require("libpack.format")

--[[
		Packing via formatting is easy; just pass a bunch of formatting flags.
	For each flag passed, the formatting functions go through the varargs, type
	check, and appends it to the packed variables string.

	Flags:
		> - packs as big-endian
		< - packs as little-endian
		a - string w/ length prefix (unsigned short)
		A - string w/ length prefix (unsigned long)
		b - signed byte
		B - unsigned byte
		d - double
		f - float
		h - signed short
		H - unsigned short
		l - signed long
		L - unsigned long
		q - signed long long
		Q - unsigned long long
]]--

-- Pack a byte and a prefixed short string
local packed_variables = libpack.format.pack("<ba", 128, "Hello there! This is a string, :D")

-- And then unpacking
local unpacked_byte, unpacked_string = libpack.format.unpack("<ba", packed_variables)