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
	self.canUse = true

	local phys = self:GetPhysicsObject()
	if self:IsValid() then self:Activate() end
	if phys:IsValid() then phys:Wake() end
	
end


function ENT:Use(ply)
	if not self.canUse then return end
	
	MSCP.Message(ply, "Card reads: 'Letter to mom'")
	self:EmitSound("loveumom.wav", 50, math.Rand(90,110))
	if MSCP.chance(10) then -- 10% chance to get the message
		MSCP.Message(ply, "You feel loved <3", Color(255,90,200))
	end

	self.canUse = false

	timer.Simple(3, function()
		if self:IsValid() then
			self.canUse = true
		end
	end)
end

function ENT:OnTakeDamage(dmg)
	if self:IsValid() then
		SafeRemoveEntity(self)
	end
end

function ENT:OnRemove()
	timer.Simple(0, function()
		if not IsValid(self) then
			for k,v in pairs(MSCP.activeSCPs) do
				if v == ent then
					table.remove(MSCP.activeSCPs, k)
				end
			end
		end
	end)
end