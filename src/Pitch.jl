abstract type Pitch end
abstract type Interval end

Base.:<=(x::Pitch,y::Pitch)::Bool = Chakra.Error(<=,x,y,Bool)
Base.:<=(x::Interval,y::Interval)::Bool = Chakra.Error(<=,x,y,Bool)

function zero(::Type{T})::Interval where {T<:Interval}
    Chakra.Error(zero,T)
end

Base.:+(x::Interval,y::Interval)::Interval = Chakra.Error(+,x,y,Interval)
Base.:-(x::Interval)::Interval = Chakra.Error(-,x,Interval)

diff(x::Pitch,y::Pitch)::Interval = Chakra.Error(diff,x,y,Interval)
shift(x::Interval,y::Pitch)::Pitch = Charka.Error(shift,x,y,Pitch)
