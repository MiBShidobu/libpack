-- lua/includes/modules/libpack.format.lua

-- =============================================================================
-- >>> IMPORTS
-- =============================================================================
-- Internal
require("libpack")

-- =============================================================================
-- >>> FORMAT FLAGS
-- =============================================================================
local format_flags = {}

-- little-endian
format_flags["<"] = {}
local function pack(format_context, _)
	-- Changes the byte order to little-endian
	format_context.byte_order = false
	return nil, 1
end

format_flags["<"].pack		= pack
format_flags["<"].unpack	= pack

-- big-endian
format_flags[">"] = {}
local function pack(format_context, _)
	-- Changes the byte order to big-endian
	format_context.byte_order = true
	return nil, 1
end

format_flags[">"].pack		= pack
format_flags[">"].unpack	= pack

-- string w/ length prefix (unsigned short)
format_flags["a"] = {}
function format_flags.a.pack(format_context, unpacked_variables)
	-- Packs a string with a short prefixed length
	local unpacked_variable = table.remove(unpacked_variables, 1)
	if type(unpacked_variable) == "string" then
		return libpack.packUInt(#unpacked_variable, 16, format_context.byte_order)..unpacked_variable
	end

	error("unpacked variable invalid match flag 'a'")
end

function format_flags.a.unpack(format_context, packed_buffer)
	-- Unpacks a string with a short prefixed length
	local packed_length = #packed_buffer
	if packed_length > 1 then
		local string_length	= libpack.unpackUInt(string.sub(packed_buffer, 1, 2), 16, format_context.byte_order)
		local struct_length	= (string_length + 2)

		if packed_length >= struct_length then
			return string.sub(packed_buffer, 3, struct_length), struct_length + 1
		end
	end

	error("malformed packed variable for flag 'a'")
end

-- string w/ length prefix (unsigned long)
format_flags["A"] = {}
function format_flags.A.pack(format_context, unpacked_variables)
	-- Packs a string with a long prefixed length
	local unpacked_variable = table.remove(unpacked_variables, 1)
	if type(unpacked_variable) == "string" then
		return libpack.packUInt(#unpacked_variable, 32, format_context.byte_order)..unpacked_variable
	end

	error("unpacked variable invalid match flag 'A'")
end

function format_flags.A.unpack(format_context, packed_buffer)
	-- Unpacks a string with a long prefixed length
	local packed_length = #packed_buffer
	if packed_length > 3 then
		local string_length	= libpack.unpackUInt(string.sub(packed_buffer, 1, 4), 32, format_context.byte_order)
		local struct_length	= (string_length + 4)

		if packed_length >= struct_length then
			return string.sub(packed_buffer, 5, struct_length), struct_length + 1
		end
	end

	error("malformed packed variable for flag 'A'")
end

-- signed byte
format_flags["b"] = {}
function format_flags.b.pack(format_context, unpacked_variables)
	-- Packs a signed byte
	local unpacked_variable = table.remove(unpacked_variables, 1)
	if type(unpacked_variable) == "number" then
		return libpack.packInt(unpacked_variable, 8, format_context.byte_order)
	end

	error("unpacked variable invalid match flag 'b'")
end

function format_flags.b.unpack(format_context, packed_buffer)
	-- Unpacks a signed byte
	local packed_length = #packed_buffer
	if packed_length > 0 then
		return libpack.unpackInt(string.sub(packed_buffer, 1, 1), 8, format_context.byte_order), 2
	end

	error("malformed packed variable for flag 'b'")
end

-- unsigned byte
format_flags["B"] = {}
function format_flags.B.pack(format_context, unpacked_variables)
	-- Packs an unsigned byte
	local unpacked_variable = table.remove(unpacked_variables, 1)
	if type(unpacked_variable) == "number" then
		return libpack.packUInt(unpacked_variable, 8, format_context.byte_order)
	end

	error("unpacked variable invalid match flag 'B'")
end

function format_flags.B.unpack(format_context, packed_buffer)
	-- Unpacks an unsigned byte
	local packed_length = #packed_buffer
	if packed_length > 0 then
		return libpack.unpackUInt(string.sub(packed_buffer, 1, 1), 8, format_context.byte_order), 2
	end

	error("malformed packed variable for flag 'B'")
end

-- double
format_flags["d"] = {}
function format_flags.d.pack(format_context, unpacked_variables)
	-- Packs a double
	local unpacked_variable = table.remove(unpacked_variables, 1)
	if type(unpacked_variable) == "number" then
		return libpack.packDouble(unpacked_variable, format_context.byte_order)
	end

	error("unpacked variable invalid match flag 'd'")
end

function format_flags.d.unpack(format_context, packed_buffer)
	-- Unpacks a double
	local packed_length = #packed_buffer
	if packed_length > 0 then
		return libpack.unpackDouble(string.sub(packed_buffer, 1, 8), format_context.byte_order), 9
	end

	error("malformed packed variable for flag 'd'")
end

-- float
format_flags["f"] = {}
function format_flags.f.pack(format_context, unpacked_variables)
	-- Packs a float
	local unpacked_variable = table.remove(unpacked_variables, 1)
	if type(unpacked_variable) == "number" then
		return libpack.packFloat(unpacked_variable, format_context.byte_order)
	end

	error("unpacked variable invalid match flag 'f'")
end

function format_flags.f.unpack(format_context, packed_buffer)
	-- Unpacks a float
	local packed_length = #packed_buffer
	if packed_length > 0 then
		return libpack.unpackFloat(string.sub(packed_buffer, 1, 4), format_context.byte_order), 5
	end

	error("malformed packed variable for flag 'f'")
end

-- signed short
format_flags["h"] = {}
function format_flags.h.pack(format_context, unpacked_variables)
	-- Packs a signed short
	local unpacked_variable = table.remove(unpacked_variables, 1)
	if type(unpacked_variable) == "number" then
		return libpack.packInt(unpacked_variable, 16, format_context.byte_order)
	end

	error("unpacked variable invalid match flag 'h'")
end

function format_flags.h.unpack(format_context, packed_buffer)
	-- Unpacks a signed short
	local packed_length = #packed_buffer
	if packed_length > 1 then
		return libpack.unpackInt(string.sub(packed_buffer, 1, 2), 16, format_context.byte_order), 3
	end

	error("malformed packed variable for flag 'h'")
end

-- unsigned short
format_flags["H"] = {}
function format_flags.H.pack(format_context, unpacked_variables)
	-- Packs an unsigned short
	local unpacked_variable = table.remove(unpacked_variables, 1)
	if type(unpacked_variable) == "number" then
		return libpack.packUInt(unpacked_variable, 16, format_context.byte_order)
	end

	error("unpacked variable invalid match flag 'H'")
end

function format_flags.H.unpack(format_context, packed_buffer)
	-- Unpacks an unsigned short
	local packed_length = #packed_buffer
	if packed_length > 1 then
		return libpack.unpackUInt(string.sub(packed_buffer, 1, 2), 16, format_context.byte_order), 3
	end

	error("malformed packed variable for flag 'H'")
end

-- signed long
format_flags["l"] = {}
function format_flags.l.pack(format_context, unpacked_variables)
	-- Packs a signed long
	local unpacked_variable = table.remove(unpacked_variables, 1)
	if type(unpacked_variable) == "number" then
		return libpack.packInt(unpacked_variable, 32, format_context.byte_order)
	end

	error("unpacked variable invalid match flag 'l'")
end

function format_flags.l.unpack(format_context, packed_buffer)
	-- Unpacks a signed long
	local packed_length = #packed_buffer
	if packed_length > 3 then
		return libpack.unpackInt(string.sub(packed_buffer, 1, 4), 32, format_context.byte_order), 5
	end

	error("malformed packed variable for flag 'l'")
end

-- unsigned long
format_flags["L"] = {}
function format_flags.L.pack(format_context, unpacked_variables)
	-- Packs an unsigned long
	local unpacked_variable = table.remove(unpacked_variables, 1)
	if type(unpacked_variable) == "number" then
		return libpack.packUInt(unpacked_variable, 32, format_context.byte_order)
	end

	error("unpacked variable invalid match flag 'L'")
end

function format_flags.L.unpack(format_context, packed_buffer)
	-- Unpacks an unsigned long
	local packed_length = #packed_buffer
	if packed_length > 3 then
		return libpack.unpackUInt(string.sub(packed_buffer, 1, 4), 32, format_context.byte_order), 5
	end

	error("malformed packed variable for flag 'L'")
end

-- signed quad
format_flags["q"] = {}
function format_flags.q.pack(format_context, unpacked_variables)
	-- Packs a signed quad
	local unpacked_variable = table.remove(unpacked_variables, 1)
	if type(unpacked_variable) == "number" then
		return libpack.packInt(unpacked_variable, 64, format_context.byte_order)
	end

	error("unpacked variable invalid match flag 'q'")
end

function format_flags.q.unpack(format_context, packed_buffer)
	-- Unpacks a signed quad
	local packed_length = #packed_buffer
	if packed_length > 7 then
		return libpack.unpackInt(string.sub(packed_buffer, 1, 8), 64, format_context.byte_order), 9
	end

	error("malformed packed variable for flag 'q'")
end

-- unsigned quad
format_flags["Q"] = {}
function format_flags.Q.pack(format_context, unpacked_variables)
	-- Packs an unsigned long
	local unpacked_variable = table.remove(unpacked_variables, 1)
	if type(unpacked_variable) == "number" then
		return libpack.packUInt(unpacked_variable, 64, format_context.byte_order)
	end

	error("unpacked variable invalid match flag 'Q'")
end

function format_flags.Q.unpack(format_context, packed_buffer)
	-- Unpacks an unsigned quad
	local packed_length = #packed_buffer
	if packed_length > 7 then
		return libpack.unpackUInt(string.sub(packed_buffer, 1, 8), 64, format_context.byte_order), 9
	end

	error("malformed packed variable for flag 'Q'")
end

-- =============================================================================
-- >>> HELPER FUNCTIONS
-- =============================================================================
local function flag_iter(pack_format)
	local function iterator()
		if pack_format == "" then
			return nil
		end

		local char_flag			= pack_format:sub(1, 1)
		local flag_functions	= format_flags[char_flag]
		if not flag_functions then
			error("unknown format flag '"..char_flag.."'")
		end

		pack_format = pack_format:sub(2)
		return flag_functions.pack, flag_functions.unpack
	end

	return iterator
end

-- =============================================================================
-- >>> LIBRARY FORMAT FUNCTIONS
-- =============================================================================
--	Flags:
--		> - big-endian
--		< - little-endian
--		a - string w/ length prefix (unsigned short)
--		A - string w/ length prefix (unsigned long)
--		b - signed byte
--		B - unsigned byte
--		d - double
--		f - float
--		h - signed short
--		H - unsigned short
--		l - signed long
--		L - unsigned long
--		q - signed long long
--		Q - unsigned long long

local function pack(pack_format, ...)
	-- Packs variables into a binary format
	local packed_buffer			= ""
	local unpacked_variables	= {...}

	local format_context = {}
	for flag_pack, _ in flag_iter(pack_format) do
		packed_buffer	= packed_buffer..(flag_pack(format_context, unpacked_variables) or "")
		pack_format		= pack_format:sub(2)
	end

	return packed_buffer
end

local lua_unpack = unpack
local function unpack(pack_format, packed_buffer)
	-- Unpacks variables from a binary format
	local unpacked_variables = {}

	local format_context = {}
	for _, flag_unpack in flag_iter(pack_format) do
		local unpacked_variable, skipped_length	= flag_unpack(format_context, packed_buffer)
		packed_buffer							= packed_buffer:sub(skipped_length)

		if type(unpacked_variable) ~= "nil" then
			unpacked_variables[#unpacked_variables + 1] = unpacked_variable
		end
	end

	return lua_unpack(unpacked_variables)
end

-- =============================================================================
-- >>> LIBRARY DEFINITIONS
-- =============================================================================
-- namespace
libpack.format = libpack.format or {}

-- formatting
libpack.format.pack		= libpack.format.pack or pack
libpack.format.unpack	= libpack.format.unpack or unpack