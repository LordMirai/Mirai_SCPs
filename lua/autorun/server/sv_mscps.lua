

hook.Run("PlayerInitialSpawn","InitFreeman",function(ply)
    ply.saidFreeman = false
end)

function MSCP.Message(ply,msg,col)
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

print("sv_mscps reloaded")