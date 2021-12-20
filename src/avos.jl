import Base: show, typemax, typemin, <, +, *, -, one, zero, convert, promote_rule
"""
    AInteger

    Integers that follow Avos definition for addition and multiplication
    also introduces a secondary value of 1, red one, which is greater than zero and less than
    one.
"""
abstract type AInteger <: Unsigned end
primitive type AInt8 <: AInteger 8 end
primitive type AInt16 <: AInteger 16 end
primitive type AInt32 <: AInteger 32 end
primitive type AInt64 <: AInteger 64 end
primitive type AInt128 <: AInteger 128 end

AInt8(x::Integer) = reinterpret(AInt8, convert(UInt8, x))
AInt16(x::Integer) = reinterpret(AInt16, convert(UInt16, x))
AInt32(x::Integer) = reinterpret(AInt32, convert(UInt32, x))
AInt64(x::Integer) = reinterpret(AInt64, convert(UInt64, x))
AInt128(x::Integer) = reinterpret(AInt128, convert(UInt128, x))

function _print(io::IO, x::AInteger, y::Unsigned)
    if y == 0
        print(io, "0")
    elseif x == red_one(x)
        printstyled(io, "1"; color = :red)
    else
        print(io, Base.dec(y, 0, false))
    end
end

Base.show(io::IO, x::AInt8) = _print(io, x, reinterpret(UInt8, x))
Base.show(io::IO, x::AInt16) = _print(io, x, reinterpret(UInt16, x))
Base.show(io::IO, x::AInt32) = _print(io, x, reinterpret(UInt32, x))
Base.show(io::IO, x::AInt64) = _print(io, x, reinterpret(UInt64, x))
Base.show(io::IO, x::AInt128) = _print(io, x, reinterpret(UInt128, x))

"""
    red_one(x)
    red_one(T::type)

Return a avos "red one" for `x`: a value such that
`red_one(x)+one(x) == red_one(x)`.
"""
function red_one(::AInteger) end

# now define min, max and red_one for each width of AInteger
typemin(::Type{AInt8 }) = AInt8(0)
typemax(::Type{AInt8 }) = AInt8(254)
red_one(::AInt8) = AInt8(255)
red_one(::Type{AInt8}) = AInt8(255)
typemin(::Type{AInt16}) = AInt16(0)
typemax(::Type{AInt16}) = AInt16(65534)
red_one(::AInt16) = AInt16(65535)
red_one(::Type{AInt16}) = AInt16(65535)
typemin(::Type{AInt32}) = AInt32(0)
typemax(::Type{AInt32}) = AInt32(4294967294)
red_one(::AInt32) = AInt32(4294967295)
red_one(::Type{AInt32}) = AInt32(4294967295)
typemin(::Type{AInt64}) = AInt64(0)
typemax(::Type{AInt64}) = AInt64(0xfffffffffffffffe)
red_one(::AInt64) = AInt64(0xffffffffffffffff)
red_one(::Type{AInt64}) = AInt64(0xffffffffffffffff)
typemin(::Type{AInt128}) = reinterpret(AInt128, UInt128(0))
typemax(::Type{AInt128}) = reinterpret(AInt128, Int128(-2))
red_one(::AInt128) = reinterpret(AInt128, Int128(-1))
red_one(::Type{AInt128}) = reinterpret(AInt128, Int128(-1))

promote_rule(::Type{Int8}, ::Type{AInt8}) = AInt8
promote_rule(::Type{UInt8}, ::Type{AInt8}) = AInt8
promote_rule(::Type{Int16}, ::Type{AInt16}) = AInt16
promote_rule(::Type{UInt16}, ::Type{AInt16}) = AInt16
promote_rule(::Type{Int32}, ::Type{AInt32}) = AInt32
promote_rule(::Type{UInt32}, ::Type{AInt32}) = AInt32
promote_rule(::Type{Int64}, ::Type{AInt64}) = AInt64
promote_rule(::Type{UInt64}, ::Type{AInt64}) = AInt64
promote_rule(::Type{Int128}, ::Type{AInt128}) = AInt128
promote_rule(::Type{UInt128}, ::Type{AInt128}) = AInt128

# """
#     <(x::Integer, y::Integer)
#
# for comparison purpose, 0 compares as ∞ and red_one(::T{AInteger}) is the least value of any
# AInteger
# """
# function <(x::AInteger, y::AInteger)
#     z = Base.zero(x)
#     if x == z
#         return false
#     elseif y == z && x != z
#         return true
#     elseif x == red_one(x)
#         if y == red_one(x)
#             return false
#         else
#             return true
#         end
#     elseif x == y
#         return false
#     else
#         return !(x > y)
#     end
# end
#
# """
#     +(x::Integer, y::Integer)
#
# Avos Sum or min of x, y where min(0) == ∞.
# """
# function +(x::AInteger, y::AInteger)
#     if typeof(x) != typeof(y)
#         throw(DomainError((x,y), "arguments not of same type"))
#     end
#     x < y ? x : y
# end
#
# MSB(n::Integer) = typeof(n)(sizeof(n)<<3 - leading_zeros(n) - (1))
#
# """
#     *(x::Integer, y::Integer)
#
# Avos Product or transitive relationship function.
#
# Consider 3 vertices: u, v and w. Furthermore, assume that there is a path from u to v,
# represented as x, and from v to w, represented as y.
#
# The Avos Product provides the path from u to w, represented as z, e.g. z = x ⨰ y
# """
# function *(x::AInteger, y::AInteger)
#     if typeof(x) != typeof(y)
#         throw(DomainError((x,y), "arguments not of same type"))
#     end
#     # the implementation of the avos product simply replaces the left most significant bit
#     # of arg2 with the arg1
#
#     # get constants that conform to type needed
#     z = zero(x)
#     o = one(x)
#     two = o + o
#     r1 = red_one(x)
#
#     # result is 0 by default (e.g. no transitive relationship)
#     product = z # (x == 0 || y == 0)
#
#     if x != z && y != z
#         if x == o
#             product = y
#         elseif y == o
#             product = x
#         else
#             # remove "redness" for next calculation
#             if x == r1
#                 x = o
#             end
#             if y == r1
#                 y = o
#             end
#
#             s = sizeof(x)
#             if leading_zeros(x) + leading_zeros(y) <= s - 2
#                 # check to see if operation would overflow input type
#                 throw(OverflowError("product overflow(2): $x, $y, $(typeof(x))"))
#             end
#
#             msb = MSB(y)
#             product = (y & (two^msb - one)) | (x << msb)
#             if product == r1
#                 # this is a special case of overflow, when product == maxvalue for
#                 # type, which is defined as red 1
#                 throw(OverflowError("product overflow(1): $x, $y, $(typeof(x))"))
#             end
#         end
#     end
#
#     product
# end
