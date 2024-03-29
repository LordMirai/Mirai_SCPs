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

function ENT:scanCB(ply)
	
end

-- function ENT:OnTakeDamage(dmg)

-- end


-- hook.Add("ShouldCollide", "", function(scp, ent)
	
-- end)

-- function ENT:StartTouch(otherEnt)

-- end

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