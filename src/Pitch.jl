abstract type Pitch end
abstract type Interval end

lt(x::Pitch,y::Pitch) = Chakra.Error(lt,x,y,Bool)
gt(x::Pitch,y::Pitch) = Chakra.Error(gt,x,y,Bool)
lte(x::Pitch,y::Pitch) = Chakra.Error(lte,x,y,Bool)
gte(x::Pitch,y::Pitch) = Chakra.Error(gte,x,y,Bool)

lt(x::Interval,y::Interval)::Bool = Chakra.Error(lt,x,y,Bool)
gt(x::Interval,y::Interval)::Bool = Chakra.Error(gt,x,y,Bool)
lte(x::Interval,y::Interval)::Bool = Chakra.Error(lte,x,y,Bool)
gte(x::Interval,y::Interval)::Bool = Chakra.Error(gte,x,y,Bool)

function zero(::Type{T})::Interval where {T<:Interval}
    Chakra.Error(zero,T)
end

add(x::Interval,y::Interval)::Interval = Chakra.Error(add,x,y,Interval)
inv(x::Interval)::Interval = Chakra.Error(inv,x,Interval)

diff(x::Pitch,y::Pitch)::Interval = Chakra.Error(diff,x,y,Interval)
shift(x::Interval,y::Pitch)::Pitch = Charka.Error(shift,x,y,Pitch)
