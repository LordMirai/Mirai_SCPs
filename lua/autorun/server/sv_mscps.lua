
function MSCP.Message(ply,msg,col)
    if not ply:IsValid() then return end
    if not ply:IsPlayer() then return end
    col = col or Color(250,250,250)

    net.Start("MSCP.Message")
    net.WriteString(msg)
    net.WriteColor(col)
    net.Send(ply)
end

function MSCP.Broadcast(msg,col)
    col = col or Color(250,250,250)

    net.Start("MSCP.Message")
    net.WriteString(msg)
    net.WriteColor(col)
    net.Broadcast()
end

function MSCP.removeAll()
    for k,v in pairs(ents.GetAll()) do
        if v.isSCP then
            v:Remove()
        end
    end
end

local entmeta = FindMetaTable("Entity")

function entmeta:tellInRange(range, msg, col)
    if not self.isSCP then return end

    for k,v in pairs(ents.FindInSphere(self:GetPos(), range)) do
        if v:IsPlayer() then
            MSCP.Message(v, msg, col or Color(250,250,250))
        end
    end
end

print("sv_mscps reloaded")