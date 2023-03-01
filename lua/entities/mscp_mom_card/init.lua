AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_lab/clipboard.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:SetCustomCollisionCheck(true)
	self:SetTrigger(true)

	self.isSCP = true

	local phys = self:GetPhysicsObject()
	if self:IsValid() then self:Activate() end
end


function ENT:Use(ply)
	ply:PrintMessage(HUD_PRINTTALK, "Card reads: 'Letter to mom'")
	self:EmitSound("loveumom.wav", 50, math.Rand(90,110))
end

function ENT:OnTakeDamage(dmg)
	if self:IsValid() then
		self:Remove()
	end
end
