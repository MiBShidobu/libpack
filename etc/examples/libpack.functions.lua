require("libpack")

--[[
		Like packing via formatting, packing via direct function
	calls is also possible and simple. For packing with Int, UInt,
	and String values, use the correct amount of bits to accordence
	of the range of your values. See: en.wikipedia.org/wiki/Integer_(computer_science)#Common_integral_data_types

		For the third argument of the Int, UInt, and String functions, it is a boolean.
	Passing true orders the packed byte by Most Significant Byte (MSB); passing false
	orders the packed bytes by Least Significant Byte (LSB). Usually MSB is referred
	to as big-endian and LSB as little-endian. By default, it uses little-endian.
]]--

-- Packing a unsigned integer as a byte with two-width packed
-- The packed width needed is automatically calculated from the number of bits
local packed_integer = libpack.packUInt(128, 8)

-- Unpacking the unsigned integer
local unpacked_integer = libpack.unpackUInt(packed_integer, 8)
print(unpacked_integer) -- prints '128'



-- Other functions include:
libpack.packInt(unpacked_number, number_of_bits, byte_order) -- Remember; byte_order is optional and defaults to false
libpack.unpackInt(packed_number, number_of_bits, byte_order)

libpack.packString(unpacked_string, number_of_bits, byte_order)
libpack.unpackString(packed_string, number_of_bits, byte_order)

libpack.packFloat(unpacked_float, byte_order)
libpack.unpackFloat(packed_float, byte_order)

libpack.packDouble(unpacked_double, byte_order)
libpack.unpackDouble(packed_double, byte_order)