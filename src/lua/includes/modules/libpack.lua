-- lua/includes/modules/libpack.lua

-- =============================================================================
-- >>> HELPER FUNCTIONS
-- =============================================================================
local function convert_bits_to_width(bit_count)
	-- Converts a number of bits into a fixed width
	return math.ceil(math.floor(bit_count) / 8)
end

local function truncate_number(source_float)
	-- Truncates a float into an integer
	return source_float > 0 and math.floor(source_float) or math.ceil(source_float)
end

-- =============================================================================
-- >>> LIBRARY HELPER FUNCTIONS
-- =============================================================================
-- Packers
local function packDouble(unpacked_float)
	-- Packs a floating-point double-percision number

end

local function packFloat(unpacked_float)
	-- Packs a floating-point single-percision number
end

local function packUInt(unpacked_number, bit_count, byte_order)
	-- Packs a unsigned integer
	local packed_width = convert_bits_to_width(bit_count)

	local packed_unsigned = ""
	for packed_index=1, packed_width do
		if byte_order then
			packed_unsigned = string.char(unpacked_number % 256)..packed_unsigned

		else
			packed_unsigned = packed_unsigned..string.char(unpacked_number % 256)
		end

		unpacked_number = truncate_number(unpacked_number / 256)
	end

	return packed_unsigned
end

local function packInt(unpacked_number, bit_count, byte_order)
	-- Unpacks a signed integer
	if unpacked_number < 0 then
		unpacked_number = unpacked_number + (2 ^ bit_count)
	end

	return packUInt(unpacked_number, bit_count, byte_order)
end

local function packString(unpacked_string, bit_count, byte_order)
	-- Packs a string with a prefixed length
	return packUInt(#unpacked_string, bit_count, byte_order)..unpacked_string
end

-- Unpackers
local function unpackDouble(packed_double, byte_order)
	-- Unpacks a floating-point double-percision number
end

local function unpackFloat(packed_float, byte_order)
	-- Unpacks a floating-point single-percision number
end

local function unpackUInt(packed_number, bit_count, byte_order)
	-- Unpacks a unsigned integer
	local packed_width = convert_bits_to_width(bit_count)

	local unpacked_unsigned = 0
	for packed_index=1, packed_width do
		if byte_order then
			unpacked_unsigned = (unpacked_unsigned * 256) + packed_number:byte(packed_index)

		else
			unpacked_unsigned = (unpacked_unsigned * 256) + packed_number:byte(packed_width - (packed_index - 1))
		end
	end

	return unpacked_unsigned
end

local function unpackInt(packed_number, bit_count, byte_order)
	-- Unpacks a signed integer
	local unpacked_unsigned = unpackUInt(packed_number, bit_count, byte_order)
	if unpacked_unsigned >= 2 ^ (bit_count - 1) then
		return unpacked_unsigned - (2 ^ bit_count)
	end

	return unpacked_unsigned
end

local function unpackString(packed_string, bit_count, byte_order)
	-- Unpacks a string with a prefixed length
	local packed_width	= convert_bits_to_width(bit_count)
	local packed_length	= unpackUInt(string.sub(packed_string, 1, packed_width), bit_count, byte_order)

	return string.sub(packed_string, packed_width + 1, packed_length + packed_width)
end

-- =============================================================================
-- >>> LIBRARY DEFINITIONS
-- =============================================================================
-- namespace
libpack = libpack or {}

-- packing
libpack.packDouble	= libpack.packDouble or packDouble
libpack.packFloat	= libpack.packFloat or packFloat
libpack.packInt		= libpack.packInt or packInt
libpack.packString	= libpack.packString or packString
libpack.packUInt	= libpack.packUInt or packUInt

-- unpacking
libpack.unpackDouble	= libpack.unpackDouble or unpackDouble
libpack.unpackFloat		= libpack.unpackFloat or unpackFloat
libpack.unpackInt		= libpack.unpackInt or unpackInt
libpack.unpackString	= libpack.unpackString or unpackString
libpack.unpackUInt		= libpack.unpackUInt or unpackUInt