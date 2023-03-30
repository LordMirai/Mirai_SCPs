AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/hunter/blocks/cube025x05x025.mdl")
	self:SetModelScale(0.2, 0)
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
	if not (self.canUse and ply:Alive()) or ply.isOnSpeedPill then return end
	self.canUse = false
	timer.Simple(math.Clamp(self.useCooldown,0.1,3600), function()
		if not self:IsValid() then return end
		self.canUse = true
	end)

	self:applySpeed(ply)
	self:Remove()
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

function ENT:applySpeed(ply)
	ply.isOnSpeedPill = true
	ply.initialWalkSpeed = ply:GetWalkSpeed()
	ply.initialRunSpeed = ply:GetRunSpeed()

	local tmID = "speedPill"..ply:SteamID64()

	local period = math.random(50, 100)
	local postPeriod = math.random(1.5, 5)

	local ticks = 0

	MSCP.Message(ply, "Omg, I feel so fast!")

	timer.Create(tmID, 0.1, period, function()
		if not ply:IsValid() then return end
		ply:SetWalkSpeed(ply:GetWalkSpeed() * 1.1)
		ply:SetRunSpeed(ply:GetRunSpeed() * 1.1)
		ticks = ticks + 1
		if ticks == (period - 2) then
			MSCP.Message(ply, "FULL SPEED!")
		end
	end)


	timer.Simple(0.1 * period + postPeriod, function()
		if not ply:IsValid() or not ply.isOnSpeedPill then return end

		MSCP.Message(ply, "I'm slowing down...")
		
		timer.Create(tmID, 0.1, 30, function()
			if not ply:IsValid() then return end
			ply:SetWalkSpeed(ply:GetWalkSpeed() * 0.3)
			ply:SetRunSpeed(ply:GetRunSpeed() * 0.3)
		end)

		timer.Simple(math.random(5,10), function()
			if not ply:IsValid() then return end
			ply.isOnSpeedPill = false
			ply:SetWalkSpeed(ply.initialWalkSpeed)
			ply:SetRunSpeed(ply.initialRunSpeed)

			MSCP.Message(ply, "I'm back to normal.")
		end)
	end)
	

end

hook.Add("PlayerDeath", "speedPillDeath", function(ply)
	if ply.isOnSpeedPill then
		ply.isOnSpeedPill = false
		ply:SetWalkSpeed(ply.initialWalkSpeed)
		ply:SetRunSpeed(ply.initialRunSpeed)
		if timer.Exists("speedPill"..ply:SteamID64()) then
			timer.Remove("speedPill"..ply:SteamID64())
		end
	end
end)