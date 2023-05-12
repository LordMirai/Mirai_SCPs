AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/fiileri/stiletto.mdl") -- couldn't find spindle/needle model, so i went with this
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:SetCustomCollisionCheck(true)
	self:SetTrigger(true)

	self.isSCP = true
	self.canUse = true
	self.useCooldown = 1

	self.scanValid = false -- set to true to enable scanning
	self.scanRadius = 300
	self.scanPeriod = 1

	local phys = self:GetPhysicsObject()
	if self:IsValid() then self:Activate() end
	if phys:IsValid() then phys:Wake() end

	self:scan()
end

function ENT:Use(ply)
	if not self.canUse then return end
	self.canUse = false
	timer.Simple(math.Clamp(self.useCooldown,0.1,3600), function()
		if not self:IsValid() then return end
		self.canUse = true
	end)

	if ply:Alive() then
		if ply:Health() <= 1 then
			MSCP.Message(ply, "I don't think you're in any condition to use this.", Color(180,0,0))
		else
			ply:SetHealth(math.Clamp(ply:Health() - 1, 1, ply:GetMaxHealth()))
			MSCP.Message(ply, "*You pricked your finger*\n It doesn't hurt that bad...")
			self:playRandSound(100, 0)
			timer.Simple(math.random(0.4,0.8), function()
				if ply:IsValid() then
					MSCP.Message(ply, "...but you scream anyway.")
				end
			end)
		end
	end
end

function ENT:scan()
	if not self:IsValid() then return end
	if self.scanValid then
		local entList = ents.FindInSphere(self:GetPos(), self.scanRadius)
		for k, v in pairs(entList) do
			if v:IsPlayer() then -- alter target as needed
				self:scanCB(v)
			end
		end
	end

	timer.Simple(math.Clamp(self.scanPeriod,0.0001,3600), function()
		if self:IsValid() then
			self:scan()
		end
	end)
end

function ENT:scanCB(ply)end

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

function ENT:playRandSound(volume, pitchVariance)
	local snd = table.Random(self.sounds)
	self:EmitSound(snd, volume, math.random(100-pitchVariance, 100+pitchVariance))
end