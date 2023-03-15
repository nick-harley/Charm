abstract type Time end
abstract type Duration end

Base.:<=(x::Time,y::Time)::Bool = Chakra.Error(<=,x,y,Bool)
Base.:<=(x::Duration,y::Duration)::Bool = Chakra.Error(<=,x,y,Bool)

zero(::Type{<:Duration})::Duration = Chakra.Error(zero,T)

Base.:+(x::Duration,y::Duration)::Duration = Chakra.Error(+,x,y,Duration)
Base.:-(x::Duration)::Duration = Chakra.Error(-,x,Duration)

diff(x::Time,y::Time)::Duration = Chakra.Error(diff,x,y,Duration)
shift(x::Duration,y::Time)::Time = Charka.Error(shift,x,y,Time)

Base.:-(x::Duration,y::Duration)::Duration = y + (-x)
Base.:+(x::Duration,y::Time)::Time = shift(x,t)
Base.:+(x::Time,y::Duration)::Time = shift(y,x)
Base.:-(x::Time,y::Time)::Duration = diff(x,y)
