abstract type Pitch end
abstract type Interval end

Base.:<=(x::Pitch,y::Pitch)::Bool = Chakra.Error(<=,x,y,Bool)
Base.:<=(x::Interval,y::Interval)::Bool = Chakra.Error(<=,x,y,Bool)

zero(::Type{<:Interval})::Interval = Chakra.Error(zero,T)

Base.:+(x::Interval,y::Interval)::Interval = Chakra.Error(+,x,y,Interval)
Base.:-(x::Interval)::Interval = Chakra.Error(-,x,Interval)

diff(x::Pitch,y::Pitch)::Interval = Chakra.Error(diff,x,y,Interval)
shift(x::Interval,y::Pitch)::Pitch = Charka.Error(shift,x,y,Pitch)

Base.:-(x::Interval,y::Interval)::Interval = y + (-x)
Base.:+(x::Interval,y::Pitch)::Pitch = shift(x,t)
Base.:+(x::Pitch,y::Interval)::Pitch = shift(y,x)
Base.:-(x::Pitch,y::Pitch)::Interval = diff(x,y)
