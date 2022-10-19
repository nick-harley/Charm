module Midi

using MIDI, DataStructures
using Chakra
using ..Charm

# CONCRETE ATTRIBUTE TYPES

# PITCH

struct Pitch <: Charm.Pitch
    value::Int
end

Base.:<=(x::Pitch,y::Pitch)::Bool = x.value <= y.value 

struct Interval <: Charm.Interval
    value::Int
end

Base.:<=(x::Interval,y::Interval)::Bool = x.value <= y.value
zero(::Type{Interval})::Interval = Interval(0)
Base.:+(x::Interval,y::Interval)::Interval = Interval(x.value + y.value)
Base.:-(x::Interval)::Interval = Interval(-x.value)

Charm.diff(x::Pitch,y::Pitch)::Interval = Interval(y.value-x.value)
Charm.shift(x::Interval,y::Pitch)::Pitch = Pitch(y.value+x.value)

# TIME

struct Time <: Charm.Time
    value::Int
end

Base.:<=(x::Time,y::Time)::Bool = x.value <= y.value

struct Duration <: Charm.Duration
    value::Int
end

Base.:<=(x::Duration,y::Duration)::Bool = x.value <= y.value
zero(::Type{Duration})::Duration = Duration(0)
Base.:+(x::Duration,y::Duration)::Duration = Duration(x.value+y.value)
Base.:-(x::Duration)::Duration = Duration(-x.value)

Charm.diff(x::Time,y::Time)::Duration = Interval(y.value-x.value)
Charm.shift(x::Duration,y::Time)::Time = Time(y.value+x.value)



# CHAKRA TYPES

abstract type Id <: Chakra.Id end

abstract type Constituent <: Chakra.Constituent end

abstract type Hierarchy <: Chakra.Hierarchy end




# IDS

struct FileId{F} <: Id
    FileId(F::Symbol) = new{F}()
    FileId(F::String) = FileId(Symbol(F))
end

struct TrackId{F,T} <: Id
    TrackId(F::Symbol,T::Int) = new{F,T}()
    TrackId(F::String,T::Int) = TrackId(Symbol(F),T)
end

struct NoteId{F,T,N} <: Id
    NoteId(F::Symbol,T::Int,N::Int) = new{F,T,N}()
    NoteId(F::String,T::Int,N::Int) = NoteId(Symbol(F),T,N)
end

id(F) = FileId(F)
id(F,T) = TrackId(F,T)
id(F,T,N) = NoteId(F,T,N)


# CONSTITUENTS

struct Note{F,T,N} <: Constituent

    # Type of Midi notes

    pitch::Pitch
    velocity::Int
    position::Time
    duration::Duration
    channel::Int

    Note(F,T,N,note) = begin
        new{F,T,N}(Pitch(note.pitch),
                   Int(note.velocity),
                   Time(note.position),
                   Duration(note.duration),
                   Int(note.channel))
    end
end

struct Track{F,T} <: Constituent

    # Type of Midi tracks
    
    notes::OrderedDict{NoteId{F,T},Note{F,T}}

    Track(F,T,t) = begin
        
        notes = OrderedDict{NoteId{F,T},Note{F,T}}()

        for (N,note) in enumerate(getnotes(t))
            notes[id(F,T,N)] = Note(F,T,N,note)
        end

        return new{F,T}(notes)
    end
end

struct File{F} <: Constituent

    # Type of Midi files
    
    tracks::OrderedDict{TrackId{F},Track{F}}
    File(F::Symbol,f::MIDIFile) = begin

        tracks = OrderedDict{TrackId{F},Track{F}}()
        
        for (T,t) in enumerate(f.tracks)
            tracks[id(F,T)] = Track(F,T,t)
        end
        
        return new{F}(tracks)
    end
end

# HIERARCHIES

struct DataSet <: Hierarchy

    # Type of Midi Data Sets
    
    files::OrderedDict{FileId,File}
    
    DataSet() = new(OrderedDict{FileId,File}())
end



# ADD MIDI FILE TO DATASET

function addFile(F::Symbol,f::MIDIFile,d::DataSet)

    # Insert a file to a data set
    
    d.files[id(F)] = File(F,f)
end

function addFile(path::String,d::DataSet)

    # Read file 

    F = Symbol(basename(path))
    f = readMIDIFile(path)
    addFile(F,f,d)
end

function addFile(paths::Vector{String},d::DataSet)
    for p in paths
        addFile(p,d)
    end
end


Chakra.pts(c::File) = collect(keys(c.tracks))
Chakra.pts(c::Track) = collect(keys(c.notes))
Chakra.pts(c::Note) = Id[]

Chakra.fnd(x::FileId,h::DataSet) = Base.get(h.files,x,none)
Chakra.fnd(x::TrackId{F},h::DataSet) where F = obind(fnd(id(F),h),f->Base.get(f.tracks,x,none))
Chakra.fnd(x::NoteId{F,T},h::DataSet) where {F,T} = obind(fnd(id(F,T),h),t->Base.get(t.notes,x,none))

Charm.getpitch(n::Note)::Pitch = n.pitch
Charm.getonset(n::Note)::Time = n.position
Charm.getduration(n::Note)::Duration = n.duration

Charm.getpitch(c::Constituent) = none
Charm.getonset(c::Constituent) = none
Charm.getduration(c::Constituent) = none

end
