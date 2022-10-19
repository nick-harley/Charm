abstract type Time end
abstract type Duration end

Base.:<=(x::Time,y::Time)::Bool = Chakra.Error(<=,x,y,Bool)
Base.:<=(x::Duration,y::Duration)::Bool = Chakra.Error(<=,x,y,Bool)

function zero(::Type{T})::Duration where {T<:Duration}
    Chakra.Error(zero,T)
end

Base.:+(x::Duration,y::Duration)::Duration = Chakra.Error(+,x,y,Duration)
Base.:-(x::Duration)::Duration = Chakra.Error(-,x,Duration)

diff(x::Time,y::Time)::Duration = Chakra.Error(diff,x,y,Duration)
shift(x::Duration,y::Time)::Time = Charka.Error(shift,x,y,Time)
