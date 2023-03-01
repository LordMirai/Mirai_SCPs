MSCP = MSCP or {}

function MSCP.Message(msg,col)
    chat.AddText(Color(40,20,200),"[Mirai's SCPs] ",col,msg)
end


net.Receive("MSCP_Message",function()
    local msg = net.ReadString()
    local col = net.ReadColor()
    MSCP.Message(msg,col)
end)

print("cl_mscps reloaded")