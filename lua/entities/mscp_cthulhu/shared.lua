ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Call of Cthulhu"
ENT.Category = "Mirai's SCPs"
ENT.Spawnable = true
ENT.AdminOnly = true

ENT.Author = "Lord Mirai　(未来)"
ENT.Purpose = "Smacks people with rocks"
ENT.Instructions = "If read alone, you hear whispers. If not, you get smacked"
ENT.Contact = "lordmiraithegod@gmail.com | Lord Mirai(未来)#0039"

ENT.Editable = true

MSCP = MSCP or {}

function ENT:SetupDataTables()
	
end

MSCP.CtulhuLines = {
    '"The most merciful thing in the world, I think, is the inability of the human mind to correlate all its contents."',
    '"That is not dead which can eternal lie, and with strange aeons even death may die."',
    "\"Ph'nglui mglw'nafh Cthulhu R'lyeh wgah'nagl fhtagn.\"",
    '"Theosophists have guessed at the awesome grandeur of the cosmic cycle wherein our world and human race form transient incidents."',
    '"It seemed to be a sort of monster, or symbol representing a monster, of a form which only a diseased fancy could conceive."',
    '"The actuality of the unearthly revelation becomes apparent only in the subsequent and later sequels."',
    '"Then, bolder than the storied Cyclops, great Cthulhu slid greasily into the water and began to pursue with vast wave-raising strokes of cosmic potency."',
    '"It lumbered slobberingly into sight and groped about with its paw-like hands before it noticed the T-shaped glittering emblem held in the great paws."',
    '"It was from the artists and poets that the pertinent answers came, and I know that panic would have broken loose had they been able to compare notes."',
    '"It was a monstrous and sightless blasphemy with gaping mouths that appeared to suck in and swallow up everything within its immediate radius."',
    '"The Thing cannot be described - there is no language for such abysms of shrieking and immemorial lunacy, such eldritch contradictions of all matter, force, and cosmic order."',
    '"Its soul is in the house of the future, and in that future shall it suffer more keenly than ever a human soul hath suffered on the earth."',
    '"But it is not from this angle alone that we can infer what is likely to happen as a result of this guarded research."',
    '"We live on a placid island of ignorance in the midst of black seas of infinity, and it was not meant that we should voyage far."',
    '"Cthulhu still lives, too, I suppose, again in that chasm of stone which has shielded him since the sun was young."'
}

ENT.sounds = {
    "cthulhu/whisper1.wav",
    "cthulhu/whisper2.wav",
    "cthulhu/whisper3.wav",
}