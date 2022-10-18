module Charm

export getpitch, getonset, getduration

using Chakra

# CHARM ATTRIBUTES

__attributes__(::Val{a}) where a = error("Attribute $a is not defined in Charm.")
__attributes__(a::Symbol) = __attributes__(Val{a}())

struct Attribute{N,T} <: Chakra.Attribute{N,T}
    Attribute(a::Symbol) = new{a,__attributes__(a)}()
end

# CHARM PROPERTIES

__properties__(::Val{p}) where p = error("Property $p is not defined in Charm.")
__properties__(p::Symbol) = __properties__(Val{p}())

struct Property{N,T} <: Chakra.Property{N,T}
    Property(p::Symbol) = new{p,__properties__(p)}()
end

# Defining Charm Abstract Data Types
include("Operations.jl")
include("Pitch.jl")
include("Time.jl")

# Defining Charm Attributes
__attributes__(::Val{:pitch}) = Pitch
__attributes__(::Val{:onset}) = Time
__attributes__(::Val{:duration}) = Duration

Chakra.__attributes__(::Val{Symbol("Charm.pitch")}) = Attribute(:pitch)
Chakra.__attributes__(::Val{Symbol("Charm.onset")}) = Attribute(:onset)
Chakra.__attributes__(::Val{Symbol("Charm.duration")}) = Attribute(:duration)

# Defining Charm Properties
abstract type Domain end
struct Graphemic <: Domain end
struct Auditory <: Domain end
struct Acoustic <: Domain end

__properties__(::Val{:domain}) = Domain
__properties__(::Val{:level}) = Int

Chakra.__properties__(::Val{Symbol("Charm.domain")}) = Property(:domain)
Chakra.__properties__(::Val{Symbol("Charm.level")}) = Property(:level)

# Attribute Interface
getpitch(c::Chakra.Constituent)::Option{Pitch} = Chakra.Error(getpitch,c,Option{Pitch})
getonset(c::Chakra.Constituent)::Option{Time} = Chakra.Error(getonset,c,Option{Time})
getduration(c::Chakra.Constituent)::Option{Duration} = Chakra.Error(getduration,c,Option{Duration})

Chakra.geta(::Attribute{:pitch,Pitch},c::Chakra.Constituent)::Option{Pitch} = getpitch(c)
Chakra.geta(::Attribute{:onset,Time},c::Chakra.Constituent)::Option{Time} = getonset(c)
Chakra.geta(::Attribute{:duration,Duration},c::Chakra.Constituent)::Option{Duration} = getduration(c)

# Property Interface
getdomain(c::Chakra.Constituent)::Option{Domain} = Chakra.Error(getdomain,c,Option{Domain})
getlevel(c::Chakra.Constituent)::Option{Int} = Chakra.Erro(getlevel,c,Option{Int})

Chakra.getp(::Property{:domain,Domain},c::Chakra.Constituent)::Option{Domain} = getdomain(c)
Chakra.getp(::Property{:level,Int},c::Chakra.Constituent)::Option{Int} = getlevel(c)


# CONCRETE IMPLEMENTATIONS

include("Midi.jl")


end # module
