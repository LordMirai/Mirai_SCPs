MSCP = MSCP or {}
MSCP.activeSCPs = MSCP.activeSCPs or {}

function MSCP.Message(ply,msg,col)
    if not ply:IsValid() then return end
    if not ply:IsPlayer() then return end
    col = col or Color(250,250,250)

    net.Start("MSCP_Message")
    net.WriteString(msg)
    net.WriteColor(col)
    net.Send(ply)
end

function MSCP.Broadcast(msg,col)
    col = col or Color(250,250,250)

    net.Start("MSCP_Message")
    net.WriteString(msg)
    net.WriteColor(col)
    net.Broadcast()
end

function MSCP.removeAll()
    for k,v in pairs(ents.GetAll()) do
        if v.isSCP then
            SafeRemoveEntity(v)
        end
    end
end

-- q: make a regex to find all contained within the quotes of LSL=""
-- a: (LSL=[^"]+)

local entmeta = FindMetaTable("Entity")

function entmeta:tellInRange(range, msg, col)
    if not self.isSCP then return end

    for k,v in pairs(ents.FindInSphere(self:GetPos(), range)) do
        if v:IsPlayer() then
            MSCP.Message(v, msg, col or Color(250,250,250))
        end
    end
end

hook.Add("OnEntityCreated", "MSCP_OnEntityCreated", function(ent)
    if ent.isSCP then
        timer.Simple(0.01,function()
            if ent:IsValid() then
                table.insert(MSCP.activeSCPs, ent)
            end
        end)
    end
end)

hook.Add("EntityRemoved", "MSCP_EntityRemoved", function(ent)
    if ent.isSCP then
        for k,v in pairs(MSCP.activeSCPs) do
            if v == ent then
                table.remove(MSCP.activeSCPs, k)
            end
        end
    end
end)

hook.Add("Initialize", "MSCP_Initialize", function()
    MSCP.activeSCPs = {}
end)

print("sv_mscps reloaded")