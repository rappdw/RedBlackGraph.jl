import Base: 
    unsigned, Unsigned, UInt8, UInt16, UInt32, UInt64, UInt128, 
    Int8, Int16, Int32, Int64, Int128,
    show, typemax, typemin, <, <=, +, *, one, zero, convert, promote_rule, promote_typeof, iseven

@doc raw"""
    AInteger (or Avus Integer)

Integers that follow Avus definition for addition and multiplication. AIntegers also have
a distinct integer, ``\color{red}1``, where:
* ``0 < {\color{red}1} < 1``
* iseven(``{\color{red}1}``) == true

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

UInt8(x::AInt8) = reinterpret(UInt8, x)
UInt16(x::AInt8) = UInt16(reinterpret(UInt8, x))
UInt16(x::AInt16) = reinterpret(UInt16, x)
UInt32(x::AInt8) = UInt32(reinterpret(UInt8, x))
UInt32(x::AInt16) = UInt32(reinterpret(UInt16, x))
UInt32(x::AInt32) = reinterpret(UInt32, x)
UInt64(x::AInt8) = UInt64(reinterpret(UInt8, x))
UInt64(x::AInt16) = UInt64(reinterpret(UInt16, x))
UInt64(x::AInt32) = UInt64(reinterpret(UInt32, x))
UInt64(x::AInt64) = reinterpret(UInt64, x)
UInt128(x::AInt8) = UInt128(reinterpret(UInt8, x))
UInt128(x::AInt16) = UInt128(reinterpret(UInt16, x))
UInt128(x::AInt32) = UInt128(reinterpret(UInt32, x))
UInt128(x::AInt64) = UInt128(reinterpret(UInt64, x))
UInt128(x::AInt128) = reinterpret(UInt128, x)

# needed because some of the alogrithms in Graphs don't distinguish the type of 
# the vertex and the type of the edges. A RedBlackGraph represents vertices as 
# Unsgined and edges as AInteger. Generally, conversion from AInteger to Integer
# shouldn't be done.
Int8(x::AInt8) = reinterpret(Int8, x)
Int16(x::AInt8) = Int16(reinterpret(Int8, x))
Int16(x::AInt16) = reinterpret(Int16, x)
Int32(x::AInt8) = Int32(reinterpret(Int8, x))
Int32(x::AInt16) = Int32(reinterpret(Int16, x))
Int32(x::AInt32) = reinterpret(Int32, x)
Int64(x::AInt8) = Int64(reinterpret(Int8, x))
Int64(x::AInt16) = Int64(reinterpret(Int16, x))
Int64(x::AInt32) = Int64(reinterpret(Int32, x))
Int64(x::AInt64) = reinterpret(Int64, x)
Int128(x::AInt8) = Int128(reinterpret(Int8, x))
Int128(x::AInt16) = Int128(reinterpret(Int16, x))
Int128(x::AInt32) = Int128(reinterpret(Int32, x))
Int128(x::AInt64) = Int128(reinterpret(Int64, x))
Int128(x::AInt128) = reinterpret(Int128, x)

function _print(io::IO, x::AInteger, y::Unsigned)
    if y == 0
        printstyled(io, "0"; color = :black)
    elseif x == red_one(x)
        printstyled(io, "1"; color = :red)
    else
        printstyled(io, Base.dec(y, 0, false); color = :black)
    end
end

Base.show(io::IO, x::AInt8) = _print(io, x, reinterpret(UInt8, x))
Base.show(io::IO, x::AInt16) = _print(io, x, reinterpret(UInt16, x))
Base.show(io::IO, x::AInt32) = _print(io, x, reinterpret(UInt32, x))
Base.show(io::IO, x::AInt64) = _print(io, x, reinterpret(UInt64, x))
Base.show(io::IO, x::AInt128) = _print(io, x, reinterpret(UInt128, x))

## integer promotions ##

# with different sizes, promote to larger type
promote_rule(::Type{AInt16}, ::Union{Type{Int8}, Type{UInt8}, Type{AInt8}}) = AInt16
promote_rule(::Type{AInt32}, ::Union{Type{Int16}, Type{Int8}, Type{UInt16}, Type{UInt8}, Type{AInt16}, Type{AInt8}}) = AInt32
promote_rule(::Type{AInt64}, ::Union{Type{Int16}, Type{Int32}, Type{Int8}, Type{UInt16}, Type{UInt32}, Type{UInt8}, Type{AInt16}, Type{AInt32}, Type{AInt8}}) = AInt64
promote_rule(::Type{AInt128}, ::Union{Type{Int16}, Type{Int32}, Type{Int64}, Type{Int8}, Type{UInt16}, Type{UInt32}, Type{UInt64}, Type{UInt8}, Type{AInt16}, Type{AInt32}, Type{AInt64}, Type{AInt8}}) = AInt128

promote_rule(::Type{Int16}, ::Type{AInt8}) = AInt16
promote_rule(::Type{Int32}, ::Union{Type{AInt16}, Type{AInt8}}) = AInt32
promote_rule(::Type{Int64}, ::Union{Type{AInt16}, Type{AInt32}, Type{AInt8}}) = AInt64
promote_rule(::Type{Int128}, ::Union{Type{AInt16}, Type{AInt32}, Type{AInt64}, Type{AInt8}}) = AInt128

# with mixed signed/unsigned/Avus and same size, Avus wins
promote_rule(::Type{AInt8}, ::Union{Type{Int8}, Type{UInt8}}) = AInt8
promote_rule(::Type{AInt16}, ::Union{Type{Int16}, Type{UInt16}}) = AInt16
promote_rule(::Type{AInt32}, ::Union{Type{Int32}, Type{UInt32}}) = AInt32
promote_rule(::Type{AInt64}, ::Union{Type{Int64}, Type{UInt64}}) = AInt64
promote_rule(::Type{AInt128}, ::Union{Type{Int128}, Type{UInt128}}) = AInt128


@doc raw"""
    red_one(x)
    red_one(T::type)

Return a ``\color{red}1`` for `x`: a value such that
``{\color{red}1} + 1 == {\color{red}1}``.
"""
function red_one(::AInteger) end

# now define min, max and red_one for each width of AInteger
typemin(::Type{AInt8}) = AInt8(0)
typemax(::Type{AInt8}) = AInt8(254)
red_one(::AInt8) = AInt8(255)
red_one(::Type{AInt8}) = AInt8(255)
red_one(x::Int8) = red_one(AInt8(x))
red_one(x::UInt8) = red_one(AInt8(x))
typemin(::Type{AInt16}) = AInt16(0)
typemax(::Type{AInt16}) = AInt16(65534)
red_one(::AInt16) = AInt16(65535)
red_one(::Type{AInt16}) = AInt16(65535)
red_one(x::Int16) = red_one(AInt16(x))
red_one(x::UInt16) = red_one(AInt16(x))
typemin(::Type{AInt32}) = AInt32(0)
typemax(::Type{AInt32}) = AInt32(4294967294)
red_one(::AInt32) = AInt32(4294967295)
red_one(::Type{AInt32}) = AInt32(4294967295)
red_one(x::Int32) = red_one(AInt32(x))
red_one(x::UInt32) = red_one(AInt32(x))
typemin(::Type{AInt64}) = AInt64(0)
typemax(::Type{AInt64}) = AInt64(0xfffffffffffffffe)
red_one(::AInt64) = AInt64(0xffffffffffffffff)
red_one(::Type{AInt64}) = AInt64(0xffffffffffffffff)
red_one(x::Int64) = red_one(AInt64(x))
red_one(x::UInt64) = red_one(AInt64(x))
typemin(::Type{AInt128}) = reinterpret(AInt128, UInt128(0))
typemax(::Type{AInt128}) = reinterpret(AInt128, Int128(-2))
red_one(::AInt128) = reinterpret(AInt128, Int128(-1))
red_one(::Type{AInt128}) = reinterpret(AInt128, Int128(-1))
red_one(x::Int128) = red_one(AInt128(x))
red_one(x::UInt128) = red_one(AInt128(x))

unsigned(x::AInt8) = x % UInt8
unsigned(x::AInt16) = x % UInt16
unsigned(x::AInt32) = x % UInt32
unsigned(x::AInt64) = x % UInt64
unsigned(x::AInt128) = x % UInt128

function string(x::AInteger)
    s = IOBuffer()
    _print(s, x, unsigned(x))
    String(take!(s))
end

@doc raw"""
    <(x::AInteger, y::AInteger)

for comparison purpose, 0 compares as ∞ and ``\color{red}1`` is the least value of any
AInteger
"""
function <(x::AInteger, y::AInteger)
    T = promote_typeof(x, y)
    xT, yT = x % T, y % T
    xu, yu = unsigned(xT), unsigned(yT)

    if xu == 0 || xu == yu
        return false
    elseif yu == 0 || xu == typemax(xu)
        return true
    elseif yu == typemax(yu)
        return false
    else
        return xu < yu
    end
end

function <=(x::AInteger, y::AInteger)
    T = promote_typeof(x, y)
    xT, yT = x % T, y % T
    xu, yu = unsigned(xT), unsigned(yT)

    if xu == yu
        return true
    elseif yu == 0 || xu == typemax(xu)
        return true
    elseif yu == typemax(yu)
        return false
    else
        return xu <= yu
    end
end

@doc raw"""
    iseven(x::AInteger) -> Bool

Return `true` if `x` is even (that is, divisible by 2) or ``\color{red}1``, and `false` otherwise.

# Examples
"""
iseven(n::AInteger) = n == red_one(n) || iseven(unsigned(n))

@doc raw"""
    +(x::Integer, y::Integer)

Avus Sum or min(x, y) where min(0) == ∞ and ``{\color{red}1} < 1``.
"""
function +(x::AInteger, y::AInteger)
    x < y ? x : y
end

MSB(n::AInteger) = MSB(unsigned(n))
MSB(n::Integer) = typeof(n)(sizeof(n)<<3 - leading_zeros(n) - (1))

"""
    *(x::Integer, y::Integer)

Avus Product or transitive relationship function.

Consider 3 vertices: u, v and w. Furthermore, assume that there is a path from u to v,
represented as x, and from v to w, represented as y.

The Avus Product provides the path from u to w, represented as z, e.g. z = x ⨰ y
"""
function *(x::AInteger, y::AInteger)
    # the implementation of the Avus product simply replaces the left most significant bit
    # of arg2 with the arg1

    T = promote_typeof(x, y)
    xT, yT = x % T, y % T
    xu, yu = unsigned(xT), unsigned(yT)

    # result is 0 by default (e.g. no transitive relationship)
    product = zero(T)

    # Handle zero case
    if xu == 0 || yu == 0
        return product
    end

    # get constants that conform to type needed
    max = typemax(xu)
    eins = one(xu)
    two = eins + eins

    # Handle red one and one case
    if xu == max
        if yu == eins
            product = xT
        else
            product = yT
        end
    elseif yu == max
        if xu == eins
            product = yT
        else
            product = xT
        end
    elseif xu == eins
        product = yT
    elseif yu == eins
        product = xT
    else
        s = sizeof(xu)
        if leading_zeros(xu) + leading_zeros(yu) <= s - 2
            # check to see if operation would overflow input type
            throw(OverflowError("product overflow(2): $x, $y, $(T)"))
        end

        msb = MSB(yu)

        product = T((yu & (two^msb - eins)) | (xu << msb))
        if product == max
            # this is a special case of overflow, when product == maxvalue for type
            throw(OverflowError("product overflow(1): $x, $y, $(T)"))
        end
    end

    product
end
