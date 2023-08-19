AddCSLuaFile()

--Shared
ENT.Type      = "anim"
ENT.Base      = "base_gmodentity"

ENT.PrintName = "Pod"
ENT.Category  = "Claymore Gaming"
ENT.Author    = "jonjo"

ENT.Spawnable = true

if SERVER then --Server-side
    playercaptureConfig = playercaptureConfig or {}
    include("playercapture_config.lua")

    function ENT:Initialize()
        self:SetModel("models/maxib123/enclavedisplay.mdl")
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
    end

    function ENT:Use(activator, caller)
        if !self.CapturedPly then --Capture the calling ply
            caller:Pod(self)
            self:StartEffect()
            self.CapturedPly = caller
        elseif caller != self.CapturedPly then --Free the ply that is captured
            if timer.Exists("playercapture_freeTimer" .. self:EntIndex()) then return end --Already being freed
            if caller.isCaptured then return end --Don't let captured players free each other
            if caller:GetPos():Distance(self:GetPos()) > 150 then return end --Caller is too far
            self.user = caller
            net.Start("playercapture_startFree") --Start the HUD on the caller
                net.WriteInt(playercaptureConfig.timeToFree, 16)
            net.Send(caller)
            timer.Create("playercapture_freeTimer" .. self:EntIndex(), playercaptureConfig.timeToFree, 1, function()
                self:EndEffect()
                self.CapturedPly:UnAttatch()
                self.CapturedPly = nil
                self.user = nil
            end)
        end
    end

    function ENT:Think() --Halt the freeing if the player is farther than 150 units
        if !self.user then return end
        if !IsValid(self.user) then --User probably DC/ed while freeing, halt the free
            self.user = nil
            if timer.Exists("playercapture_freeTimer" .. self:EntIndex()) then
                timer.Remove("playercapture_freeTimer" .. self:EntIndex())
            end
            return
        end

        if self.user:GetPos():Distance(self:GetPos()) > 150 or self.user:GetEyeTrace().Entity != self then
            timer.Remove("playercapture_freeTimer" .. self:EntIndex())

            net.Start("playercapture_haltFree") --Stop the HUD on the caller
            net.Send(self.user)
            self.user = nil
        end
    end

    function ENT:StartEffect()
        local effectProp = ents.Create("prop_physics")
        effectProp:SetModel("models/hunter/tubes/tube1x1x2.mdl")
        effectProp:SetPos(Vector(0, 0, -9))
        effectProp:SetMaterial("models/props_combine/portalball001_sheet")
        effectProp:SetColor(Color(0, 161, 255, 255))
        effectProp:SetCollisionGroup(COLLISION_GROUP_DEBRIS_TRIGGER)
        effectProp:SetMoveParent(self)
        effectProp:Spawn()

        local physObj = effectProp:GetPhysicsObject()
        if IsValid(physObj) then
            physObj:EnableMotion(false)
        end

        self.effectProp = effectProp
    end

    function ENT:EndEffect()
        if !self.effectProp or !IsValid(self.effectProp) then return end
        self.effectProp:SetParent()
        self.effectProp:Remove()
        self.effectProp = nil
    end

    function ENT:OnRemove() --Remove npc/timer
        if timer.Exists("playercapture_freeTimer" .. self:EntIndex()) then timer.Remove("playercapture_freeTimer" .. self:EntIndex()) end
        if self.user then net.Start("playercapture_haltFree") net.Send(self.user) end
        if self.CapturedPly then self.CapturedPly:UnAttatch() end
    end
end


if CLIENT then --Client-side
    function ENT:Draw()
        self:DrawModel()
    end
end