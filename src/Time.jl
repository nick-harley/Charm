abstract type Time end
abstract type Duration end

lt(x::Time,y::Time) = Chakra.Error(lt,x,y,Bool)
gt(x::Time,y::Time) = Chakra.Error(gt,x,y,Bool)
lte(x::Time,y::Time) = Chakra.Error(lte,x,y,Bool)
gte(x::Time,y::Time) = Chakra.Error(gte,x,y,Bool)

lt(x::Duration,y::Duration)::Bool = Chakra.Error(lt,x,y,Bool)
gt(x::Duration,y::Duration)::Bool = Chakra.Error(gt,x,y,Bool)
lte(x::Duration,y::Duration)::Bool = Chakra.Error(lte,x,y,Bool)
gte(x::Duration,y::Duration)::Bool = Chakra.Error(gte,x,y,Bool)

function zero(::Type{T})::Duration where {T<:Duration}
    Chakra.Error(zero,T)
end
add(x::Duration,y::Duration)::Duration = Chakra.Error(add,x,y,Duration)
inv(x::Duration)::Duration = Chakra.Error(inv,x,Duration)

diff(x::Time,y::Time)::Duration = Chakra.Error(diff,x,y,Duration)
shift(x::Duration,y::Time)::Time = Charka.Error(shift,x,y,Time)
