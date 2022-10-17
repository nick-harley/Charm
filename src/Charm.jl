module Charm

export getpitch, getonset, getduration

using Chakra

abstract type Pitch end
abstract type Interval end
abstract type Time end 
abstract type Duration end

function lt end
function gt end
function lte end
function gte end
function zero end
function add end
function one end
function mult end
function inv end
function diff end
function shift end

function diff(x::Pitch,y::Pitch)::Interval
    Chakra.Error(diff,x,y,Interval)
end

function diff(x::Time,y::Time)::Duration
    Chakra.Error(diff,x,y,Duration)
end

function shift(x::Interval,y::Pitch)::Pitch
    Charka.Error(shift,x,y,Pitch)
end

function shift(x::Duration,y::Time)::Time
    Chakra.Error(shift,x,y,Time)
end


__attributes__(::Val{a}) where a = error("Attribute $a is not defined in Charm.")
__attributes__(a::Symbol) = __attributes__(Val{a}())

__attributes__(::Val{:pitch}) = Pitch
__attributes__(::Val{:onset}) = Time
__attributes__(::Val{:duration}) = Duration

struct Attribute{N,T} <: Chakra.Attribute{N,T}
    Attribute(a::Symbol) = new{a,__attributes__(a)}()
end

Chakra.__attributes__(::Val{Symbol("Charm.pitch")}) = Attribute(:pitch)
Chakra.__attributes__(::Val{Symbol("Charm.onset")}) = Attribute(:onset)
Chakra.__attributes__(::Val{Symbol("Charm.duration")}) = Attribute(:duration)

__properties__(::Val{p}) where p = error("Attribute $p is not defined in Charm.")
__properties__(p::Symbol) = __properties__(Val{p}())



struct Property{N,T} <: Chakra.Property{N,T}
    Property(p::Symbol) = new{p,__properties__(p)}()
end


# TODO: Defined chakra properties

function getpitch(c::Chakra.Constituent)::Option{Pitch} 
    error("No implementation of Charm.getpitch : $(typeof(c)) -> Option{Pitch}")
end

function getonset(c::Chakra.Constituent)::Option{Time}
    error("No implementation of Charm.getonset : $(typeof(c)) -> Option{Time}")
end

function getduration(c::Chakra.Constituent)::Option{Duration}
    error("No implementation of Charm.getduration : $(typeof(c)) -> Option{Duration}")
end

function Chakra.geta(a::Attribute{:pitch,Pitch},c::Chakra.Constituent)::Option{Pitch}
    getpitch(c)
end

function Chakra.geta(a::Attribute{:onset,Time},c::Chakra.Constituent)::Option{Time}
    getonset(c)
end

function Chakra.geta(a::Attribute{:duration,Duration},c::Chakra.Constituent)::Option{Duration}
    getduration(c)
end


include("Midi.jl")




end # module
