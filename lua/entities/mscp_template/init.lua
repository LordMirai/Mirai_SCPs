AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_phx/construct/metal_tubex2.mdl")
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

function ENT:Think()
	
end

function ENT:Use(ply)
	if not self.canUse then return end

end

function ENT:OnTakeDamage(dmg)

end


hook.Add("ShouldCollide", "", function(scp, ent)
	
end)

function ENT:StartTouch(otherEnt)

end