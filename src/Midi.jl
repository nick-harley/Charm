module Midi

using MIDI, DataStructures
using Chakra
using ..Charm




# CONCRETE ATTRIBUTE TYPES

struct Pitch <: Charm.Pitch
    value::Int
end

struct Interval <: Charm.Interval
    value::Int
end

struct Time <: Charm.Time
    value::Int
end

struct Duration <: Charm.Duration
    value::Int
end



# ABSTRACT TYPES

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

# CONSTITUENTS

struct Note{F,T,N} <: Constituent

    # Type of Midi notes
    
    pitch
    velocity
    position
    duration
    channel

    Note(F,T,N,note) = begin
        new{F,T,N}(Pitch(note.pitch),
                   note.velocity,
                   Time(note.position),
                   Duration(note.duration),
                   note.channel)
    end
end

struct Track{F,T} <: Constituent

    # Type of Midi tracks
    
    notes::OrderedDict{Int,Note{F,T}}

    Track(F,T,t) = begin
        notes = OrderedDict{Int,Note{F,T}}()

        for (N,note) in enumerate(getnotes(t))
            notes[N] = Note(F,T,N,note)
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
            tracks[TrackId(F,T)] = Track(F,T,t)
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

function addFile(F::Symbol,f::MIDIFile,d::DataSet)

    # Insert a file to a data set
    
    d.files[FileId(F)] = File(F,f)
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
Chakra.fnd(x::TrackId{F},h::DataSet) where F = obind(fnd(FileId(F),h),f -> Base.get(f.tracks,x,none))
Chakra.fnd(x::NoteId{F,T},h::DataSet) where {F,T}= obind(fnd(TrackId{F,T}),t -> Base.get(t.notes,x,none))



end
