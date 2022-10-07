module CHARM

using Chakra

abstract type Pitch end
abstract type Interval end
abstract type Time end 
abstract type Duration end

# TODO: ADT interfaces

function diff(x::Pitch,y::Pitch)::Interval
    error("No implementation of diff : $(typeof(x)) -> $(typeof(y)) -> CHARM.Interval.")
end

function diff(x::Time,y::Time)::Interval
    error("No implementation of diff : $(typeof(x)) -> $(typeof(y)) -> CHARM.Interval.")
end

__attributes__(::Val{a}) where a = error("Attribute $a is not defined in Charm.")
__attributes__(a::Symbol) = __atyp__(Val{a}())

__attributes__(::AttName{:pitch}) = Pitch
__attributes__(::AttName{:onset}) = Time
__attributes__(::AttName{:duration}) = Duration

struct Attribute{N,T} <: Chakra.Attribute{N,T}
    Attribute(a::Symbol) = new{a,__attributes__(a)}()
end

Chakra.__attributes__(::Val{Symbol("CHARM.pitch")}) = Attribute(:pitch)
Chakra.__attributes__(::Val{Symbol("CHARM.onset")}) = Attribute(:onset)
Chakra.__attributes__(::Val{Symbol("CHARM.duration")}) = Attribute(:duration)

__properties__(::Val{p}) where p = error("Attribute $p is not defined in Charm.")
__properties__(p::Symbol) = __properties__(Val{p}())

struct Property{N,T} <: Chakra.Property{N,T}
    Property(p::Symbol) = new{p,__properties__(p)}()


# TODO: Defined chakra properties

function getpitch(c::Chakra.Constituent)::Option{Pitch} 
    error("No implementation of CHARM.getpitch : $(typeof(c)) -> Option{Pitch}")
end

function getonset(c::Chakra.Constituent)::Option{Time}
    error("No implementation of CHARM.getonset : $(typeof(c)) -> Option{Time}")
end

function getduration(c::Chakra.Constituent)::Option{Duration}
    error("No implementation of CHARM.getduration : $(typeof(c)) -> Option{Duration}")
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

end
