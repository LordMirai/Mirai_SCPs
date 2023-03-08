AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	self:SetUseType(SIMPLE_USE)
	self:SetCustomCollisionCheck(true)
	self:SetTrigger(true)

	self.isSCP = true
	self.canUse = true
	self.useCooldown = 0

	self.scanValid = true -- set to true to enable scanning
	self.scanRadius = 300
	self.scanPeriod = 1

	self.target = nil
	self.user = nil

	local phys = self:GetPhysicsObject()
	if self:IsValid() then self:Activate() end
	if phys:IsValid() then phys:Wake() end

	timer.Simple(0.1, function()
		self:scan()
	end)

	timer.Simple(10, function()
		if self:IsValid() then
			print("Head-seeking skull did not reach its target.")
			self:Remove()
		end
	end)
end

function ENT:Use(ply)
	if not self.canUse then return end
	self.canUse = false
	timer.Simple(math.Clamp(self.useCooldown,0.1,3600), function()
		if not self:IsValid() then return end
		self.canUse = true
	end)

	if self.target == ply then
		MSCP.Message(ply, "You successfully caught the skull. It can't hurt you anymore.", Color(0,255,0))
		self:Remove()
	end

end

function ENT:scan()
	if not self:IsValid() then return end
	if self.scanValid then
		local entList = ents.FindInSphere(self:GetPos(), self.scanRadius)
		for k, v in pairs(entList) do
			if v:IsPlayer() and v:Alive() then -- alter target as needed
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
	if ply != self.user then
		if self.target == nil then
			self.target = ply -- found a target
			self.scanValid = false
		end
	end
end

hook.Add("ShouldCollide", "", function(scp, ent)
	if scp:GetClass() == "mscp_skull_projectile" then
		if ent:IsPlayer() and ent != self.user then
			return true
		end
	end
end)

function ENT:StartTouch(tg)
	if tg == self.target then
		if tg:Alive() then
			local orig = self.user
			if not orig:IsValid() then orig = self end
			MSCP.Message(tg, "*smack* the head-seeking skull gotcha!")
			tg:TakeDamage(math.random(15,30), orig, self)
		end
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

function ENT:playRandSound(volume, pitchVariance)
	local snd = table.Random(self.sounds)
	self:EmitSound(snd, volume, math.random(100-pitchVariance, 100+pitchVariance))
end