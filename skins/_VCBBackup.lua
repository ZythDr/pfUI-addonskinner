pfUI.addonskinner:RegisterSkin("VCB", function()
  local penv = pfUI:GetEnvironment()
  local StripTextures = penv.StripTextures
  local CreateBackdrop = penv.CreateBackdrop
  local CreateBackdropShadow = penv.CreateBackdropShadow
  local SetAllPointsOffset = penv.SetAllPointsOffset
  local HookScript = penv.HookScript
  local HookAddonOrVariable = penv.HookAddonOrVariable

  local ICON_INSET = 1

  local function makeOverlayBorder(btn)
    if btn._pfuiBorder then return btn._pfuiBorder end
    if not btn.backdrop then return end
    -- For consolidated children, parent the overlay to the button itself to avoid backdrop occlusion
    local parent = btn
    if not (btn:GetParent() == VCB_BF_CONSOLIDATED_BUFFFRAME) and btn.backdrop then parent = btn.backdrop end
    local pname = "pfUI_VCBOverlay_" .. (btn:GetName() or tostring(btn))
    local f = CreateFrame("Frame", pname, parent)
    f:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)
    f:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", 0, 0)
    pcall(function()
      if f.SetBackdrop then
        f:SetBackdrop(pfUI.backdrop_thin)
        f:SetBackdropColor(0,0,0,0)
        f:SetBackdropBorderColor(0,0,0,1)
      end
    end)
    f:SetFrameStrata("HIGH")
    local baseLevel = (parent.GetFrameLevel and parent:GetFrameLevel() or (btn:GetFrameLevel() or 0))
    f:SetFrameLevel(baseLevel + 50)
    if f.SetDrawLayer then f:SetDrawLayer("OVERLAY", 60) end
    btn._pfuiBorder = f
    return f
  end

  local function skinButton(btn)
    if not btn or btn._pfuiSkinned then return end

    StripTextures(btn, true)
    CreateBackdrop(btn)
    CreateBackdropShadow(btn)

    -- keep VCB border (for color) but hide it visually
    local name = btn:GetName() or ""
    local vcbBorder = _G[name .. "Border"]
    if vcbBorder and vcbBorder.SetAlpha then pcall(function() vcbBorder:SetAlpha(0) end) end

    -- icon
    local icon = _G[name .. "Icon"]
    if icon then
      pcall(function() icon:Show() end)
      icon:SetTexCoord(.07, .93, .07, .93)
      if btn.backdrop then
        SetAllPointsOffset(icon, btn.backdrop, ICON_INSET)
      else
        SetAllPointsOffset(icon, btn, ICON_INSET)
      end
      -- parent to the button (not the backdrop) so backdrop alpha doesn't affect the icon
      icon:SetParent(btn)
      if icon.SetDrawLayer then icon:SetDrawLayer("OVERLAY", 15) end
      if icon.SetFrameLevel then icon:SetFrameLevel((btn:GetFrameLevel() or 0) + 20) end
    end

    -- count/duration above icon
    local cnt = _G[name .. "Count"]
    if cnt and cnt.SetDrawLayer then cnt:SetDrawLayer("OVERLAY", 16) end
    local dur = _G[name .. "Duration"]
    if dur and dur.SetDrawLayer then dur:SetDrawLayer("OVERLAY", 16) end

    -- overlay border for colored debuffs/weapons
    makeOverlayBorder(btn)

    btn._pfuiSkinned = true
  end

  local function skinAll()
    if VCB_MAXINDEX then
      for i = 0, VCB_MAXINDEX.buff or -1 do skinButton(_G["VCB_BF_BUFF_BUTTON" .. i]) end
      for i = 0, VCB_MAXINDEX.debuff or -1 do skinButton(_G["VCB_BF_DEBUFF_BUTTON" .. i]) end
      for i = 0, VCB_MAXINDEX.weapon or -1 do skinButton(_G["VCB_BF_WEAPON_BUTTON" .. i]) end
    end

    -- consolidated
    if VCB_BF_CONSOLIDATED_ICON then
      StripTextures(VCB_BF_CONSOLIDATED_ICON, true)
      CreateBackdrop(VCB_BF_CONSOLIDATED_ICON)
      CreateBackdropShadow(VCB_BF_CONSOLIDATED_ICON)
      if VCB_BF_CONSOLIDATED_ICONIcon then
        VCB_BF_CONSOLIDATED_ICONIcon:Show()
        VCB_BF_CONSOLIDATED_ICONIcon:SetTexCoord(.14, .86, .14, .86)
        pcall(function()
          local lvl = VCB_BF_CONSOLIDATED_ICON:GetFrameLevel() or 0
          local backTarget = math.max(0, lvl - 20)
          -- lower the backdrop further so the icon is not occluded
          if VCB_BF_CONSOLIDATED_ICON.backdrop then
            VCB_BF_CONSOLIDATED_ICON.backdrop:SetFrameLevel(backTarget)
            if VCB_BF_CONSOLIDATED_ICON.backdrop.SetDrawLayer then VCB_BF_CONSOLIDATED_ICON.backdrop:SetDrawLayer("BACKGROUND", 0) end
            SetAllPointsOffset(VCB_BF_CONSOLIDATED_ICONIcon, VCB_BF_CONSOLIDATED_ICON.backdrop, ICON_INSET)
          else
            SetAllPointsOffset(VCB_BF_CONSOLIDATED_ICONIcon, VCB_BF_CONSOLIDATED_ICON, ICON_INSET)
          end

          -- ensure the icon texture itself is above everything
          VCB_BF_CONSOLIDATED_ICONIcon:SetParent(VCB_BF_CONSOLIDATED_ICON)
          if VCB_BF_CONSOLIDATED_ICONIcon.SetDrawLayer then VCB_BF_CONSOLIDATED_ICONIcon:SetDrawLayer("OVERLAY", 120) end
          if VCB_BF_CONSOLIDATED_ICONIcon.SetFrameLevel then VCB_BF_CONSOLIDATED_ICONIcon:SetFrameLevel(lvl + 120) end
          VCB_BF_CONSOLIDATED_ICONIcon:SetVertexColor(1,1,1,1)
          VCB_BF_CONSOLIDATED_ICONIcon:SetAlpha(1)

          if VCB_BF_CONSOLIDATED_ICON.backdrop and VCB_BF_CONSOLIDATED_ICON.backdrop.SetBackdropBorderColor then
            pcall(function() VCB_BF_CONSOLIDATED_ICON.backdrop:SetBackdropBorderColor(1, 0.85, 0, 1) end)
          end
        end)

        if VCB_BF_CONSOLIDATED_ICONCount and VCB_BF_CONSOLIDATED_ICONCount.SetDrawLayer then
          VCB_BF_CONSOLIDATED_ICONCount:SetDrawLayer("OVERLAY", 130)
          if VCB_BF_CONSOLIDATED_ICONCount.SetFrameLevel then VCB_BF_CONSOLIDATED_ICONCount:SetFrameLevel((VCB_BF_CONSOLIDATED_ICON:GetFrameLevel() or 0) + 140) end
        end

        -- ensure consolidated visuals persist if VCB reassigns textures or layers
        if HookScript and VCB_BF_CONSOLIDATED_ICON and VCB_BF_CONSOLIDATED_ICONIcon then
          HookScript(VCB_BF_CONSOLIDATED_ICON, "OnShow", function()
            pcall(function()
              SetAllPointsOffset(VCB_BF_CONSOLIDATED_ICONIcon, VCB_BF_CONSOLIDATED_ICON, ICON_INSET)
              VCB_BF_CONSOLIDATED_ICONIcon:SetParent(VCB_BF_CONSOLIDATED_ICON)
              if VCB_BF_CONSOLIDATED_ICONIcon.SetFrameLevel then VCB_BF_CONSOLIDATED_ICONIcon:SetFrameLevel((VCB_BF_CONSOLIDATED_ICON:GetFrameLevel() or 0) + 120) end
              if VCB_BF_CONSOLIDATED_ICONIcon.SetDrawLayer then VCB_BF_CONSOLIDATED_ICONIcon:SetDrawLayer("OVERLAY", 120) end
              if VCB_BF_CONSOLIDATED_ICON.backdrop then VCB_BF_CONSOLIDATED_ICON.backdrop:SetFrameLevel(math.max(0, (VCB_BF_CONSOLIDATED_ICON:GetFrameLevel() or 0) - 20)) end
            end)
          end)
        end
      end
      if VCB_BF_CONSOLIDATED_BUFFFRAME then
        VCB_BF_CONSOLIDATED_BUFFFRAME:SetFrameStrata("HIGH")
        pcall(function()
          if not VCB_BF_CONSOLIDATED_BUFFFRAME.backdrop then CreateBackdrop(VCB_BF_CONSOLIDATED_BUFFFRAME) end
          VCB_BF_CONSOLIDATED_BUFFFRAME:SetFrameLevel(math.max(1, (VCB_BF_CONSOLIDATED_BUFFFRAME:GetFrameLevel() or 10) - 20))
          -- hide internal border textures if present
          local b = _G["VCB_BF_CONSOLIDATED_BUFFFRAMEBorder"]
          if b and b.SetAlpha then pcall(function() b:SetAlpha(0) end) end
        end)

        -- If the consolidated buffframe is shown, reapply icon/backdrop ordering for its children
        if HookScript then
          HookScript(VCB_BF_CONSOLIDATED_BUFFFRAME, "OnShow", function()
            pcall(function()
              local baseLvl = VCB_BF_CONSOLIDATED_BUFFFRAME:GetFrameLevel() or 0
              for i = 0, (VCB_MAXINDEX and VCB_MAXINDEX.buff) or 0 do
                local btn = _G["VCB_BF_BUFF_BUTTON" .. i]
                if btn and btn:GetParent() == VCB_BF_CONSOLIDATED_BUFFFRAME then
                  local icon = _G[btn:GetName() .. "Icon"]
                  if icon and icon.SetFrameLevel then icon:SetFrameLevel(baseLvl + 160) end
                  local ob = btn._pfuiBorder
                  if ob and ob.SetFrameLevel then ob:SetFrameLevel(baseLvl + 170) end
                end
              end
            end)
          end)
        end
      end
    end
  end

  HookAddonOrVariable("VCB", function()
    pcall(skinAll)

    if VCB_BF_CreateBuffButtons then
      local orig = VCB_BF_CreateBuffButtons
      VCB_BF_CreateBuffButtons = function()
        orig()
        pcall(skinAll)
      end
    end

    -- Wrap weapon update events to force skinning, icon visibility and color copy to pfUI overlays (optimized to avoid flicker)
    local VCB_WEAPON_DEBUG = false
    if VCB_BF_WEAPON_BUTTON_OnEvent then
      local orig_wp = VCB_BF_WEAPON_BUTTON_OnEvent
      VCB_BF_WEAPON_BUTTON_OnEvent = function(bool)
        orig_wp(bool)
        pcall(function()
          for i = 0, (VCB_MAXINDEX and VCB_MAXINDEX.weapon) or 1 do
            local name = "VCB_BF_WEAPON_BUTTON" .. i
            local btn = _G[name]
            if btn then
              -- ensure the button is skinned (in case it was created after our initial skin pass)
              if not btn._pfuiSkinned and skinButton then pcall(skinButton, btn) end

              -- copy border color only if it changed
              local vcbBorder = _G[name .. "Border"]
              if vcbBorder and vcbBorder.GetVertexColor then
                local okc, r,g,b,a = pcall(function() return vcbBorder:GetVertexColor() end)
                if okc and r then
                  a = a or 1
                  local last = btn._pfuiWeaponBorderColor
                  if not last or last.r ~= r or last.g ~= g or last.b ~= b or last.a ~= a then
                    if btn.backdrop and btn.backdrop.SetBackdropBorderColor then pcall(function() btn.backdrop:SetBackdropBorderColor(r,g,b,a) end) end
                    local ob = btn._pfuiBorder
                    if ob and ob.SetBackdropBorderColor then pcall(function() ob:SetBackdropBorderColor(r,g,b,a) end) end
                    btn._pfuiWeaponBorderColor = {r=r,g=g,b=b,a=a}
                    if VCB_WEAPON_DEBUG then DEFAULT_CHAT_FRAME:AddMessage(string.format("VCB weapon %s border color set: %s,%s,%s,%s", name, tostring(r), tostring(g), tostring(b), tostring(a))) end
                  end
                end
              end

              -- ensure icon parent/alpha/layers but only if necessary
              local icon = _G[name .. "Icon"]
              if icon then
                local needsFix = false
                if icon:GetParent() ~= btn then needsFix = true end
                if icon.GetAlpha and icon:GetAlpha() ~= 1 then needsFix = true end
                if needsFix then
                  pcall(function() icon:SetParent(btn) end)
                  pcall(function() if icon.SetAlpha then icon:SetAlpha(1) end end)
                  pcall(function() if icon.SetDrawLayer then icon:SetDrawLayer("OVERLAY", 120) end end)
                  pcall(function() if icon.SetFrameLevel then icon:SetFrameLevel((btn:GetFrameLevel() or 0) + 120) end end)
                end
              end
            end
          end
        end)
      end
    end

    -- Ensure border colors are reapplied after VCB's own weapon OnUpdate (cheap idempotent pass)
    if VCB_BF_WEAPON_BUTTON_OnUpdate then
      local orig_wpu = VCB_BF_WEAPON_BUTTON_OnUpdate
      VCB_BF_WEAPON_BUTTON_OnUpdate = function(elapsed)
        orig_wpu(elapsed)
        pcall(function()
          for i = 0, (VCB_MAXINDEX and VCB_MAXINDEX.weapon) or 1 do
            local name = "VCB_BF_WEAPON_BUTTON" .. i
            local btn = _G[name]
            if btn and btn.backdrop then
              local vcbBorder = _G[name .. "Border"]
              if vcbBorder and vcbBorder.GetVertexColor then
                local okc, r,g,b,a = pcall(function() return vcbBorder:GetVertexColor() end)
                if okc and r then
                  a = a or 1
                  local last = btn._pfuiWeaponBorderColor
                  if not last or last.r ~= r or last.g ~= g or last.b ~= b or last.a ~= a then
                    pcall(function() btn.backdrop:SetBackdropBorderColor(r,g,b,a) end)
                    local ob = btn._pfuiBorder
                    if ob and ob.SetBackdropBorderColor then pcall(function() ob:SetBackdropBorderColor(r,g,b,a) end) end
                    if ob and ob.Show then pcall(function() ob:Show() end) end
                    btn._pfuiWeaponBorderColor = {r=r,g=g,b=b,a=a}
                  end
                end
              end

              -- ensure icon z-order/parent/alpha only if needed
              local icon = _G[name .. "Icon"]
              if icon then
                local needsFix = false
                if icon:GetParent() ~= btn then needsFix = true end
                if icon.GetAlpha and icon:GetAlpha() ~= 1 then needsFix = true end
                if needsFix then
                  pcall(function() icon:SetParent(btn) end)
                  pcall(function() if icon.SetAlpha then icon:SetAlpha(1) end end)
                  pcall(function() if icon.SetDrawLayer then icon:SetDrawLayer("OVERLAY", 120) end end)
                  pcall(function() if icon.SetFrameLevel then icon:SetFrameLevel((btn:GetFrameLevel() or 0) + 120) end end)
                end
              end
            end
          end
        end)
      end
    end

    if VCB_BF_BUFF_BUTTON_Update then
      local orig = VCB_BF_BUFF_BUTTON_Update
      VCB_BF_BUFF_BUTTON_Update = function(btn)
        orig(btn)
        if not btn or not btn.backdrop then return end
        local name = btn:GetName() or ""
        local vcbBorder = _G[name .. "Border"]
        local icon = _G[name .. "Icon"]
        local is_debuff = btn.cat == "debuff" or (name and string.find(name, "DEBUFF"))
        local is_weapon = btn.cat == "weapon" or (name and string.find(name, "WEAPON"))
        -- passthrough color for debuffs & weapon buffs
        if (is_debuff or is_weapon) and vcbBorder and vcbBorder.GetVertexColor then
          local ok, r,g,b,a = pcall(function() return vcbBorder:GetVertexColor() end)
          if ok and r then
            local a2 = (a and a > 0) and a or 1
            pcall(function() btn.backdrop:SetBackdropBorderColor(r,g,b,a2) end)
            local ob = makeOverlayBorder(btn)
            if ob and ob.SetBackdropBorderColor then
              pcall(function() ob:SetBackdropBorderColor(r,g,b,a2) end)
              pcall(function() if ob.SetDrawLayer then ob:SetDrawLayer("OVERLAY", 50) end end)
              pcall(function()
                local base = (btn.backdrop and (btn.backdrop:GetFrameLevel() or 0)) or (btn:GetFrameLevel() or 0)
                if ob.SetFrameLevel then ob:SetFrameLevel(base + 50) end
              end)
            end
          end
        else
          pcall(function() btn.backdrop:SetBackdropBorderColor(0,0,0,1) end)
        end

        -- reapply crop & parenting deterministically
        local icon = _G[name .. "Icon"]
        if icon then
          icon:SetTexCoord(.07, .93, .07, .93)
          if btn.backdrop then
            SetAllPointsOffset(icon, btn.backdrop, ICON_INSET)
          else
            SetAllPointsOffset(icon, btn, ICON_INSET)
          end

          -- If the button is inside the consolidated frame, make aggressive z-ordering adjustments
          if btn:GetParent() == VCB_BF_CONSOLIDATED_BUFFFRAME then
            -- ensure the button's backdrop sits under the consolidated frame
            pcall(function()
              if btn.backdrop and VCB_BF_CONSOLIDATED_BUFFFRAME and VCB_BF_CONSOLIDATED_BUFFFRAME.GetFrameLevel then
                btn.backdrop:SetFrameLevel(math.max(0, (VCB_BF_CONSOLIDATED_BUFFFRAME:GetFrameLevel() or 0) - 5))
              end
            end)
            icon:SetParent(btn)
            if icon.SetDrawLayer then icon:SetDrawLayer("OVERLAY", 160) end
            if icon.SetFrameLevel and VCB_BF_CONSOLIDATED_BUFFFRAME and VCB_BF_CONSOLIDATED_BUFFFRAME.GetFrameLevel then icon:SetFrameLevel((VCB_BF_CONSOLIDATED_BUFFFRAME:GetFrameLevel() or 0) + 160) end
            -- ensure overlay border for consolidated child is parented to button and above icon
            local ob = makeOverlayBorder(btn)
            if ob and ob.SetFrameLevel and VCB_BF_CONSOLIDATED_BUFFFRAME and VCB_BF_CONSOLIDATED_BUFFFRAME.GetFrameLevel then ob:SetFrameLevel((VCB_BF_CONSOLIDATED_BUFFFRAME:GetFrameLevel() or 0) + 170) end
            if ob and ob.SetDrawLayer then ob:SetDrawLayer("OVERLAY", 170) end
          else
            -- normal case
            icon:SetParent(btn)
            if icon.SetDrawLayer then icon:SetDrawLayer("OVERLAY", 50) end
            if icon.SetFrameLevel then icon:SetFrameLevel((btn:GetFrameLevel() or 0) + 60) end
          end
        end
      end
    end

    -- When VCB enters dummy mode it sets border textures/colors but doesn't call per-button updates.
    -- Wrap the DummyConfigMode enable function to force a color-copy/update so pfUI overlays get the VCB colors immediately.
    if VCB_BF_DummyConfigMode_Enable then
      local orig_dummy = VCB_BF_DummyConfigMode_Enable
      VCB_BF_DummyConfigMode_Enable = function()
        orig_dummy()
        pcall(function()
          -- reapply our consolidated frame stripping and backdrop so dummy mode doesn't show blizzard border
          if VCB_BF_CONSOLIDATED_BUFFFRAME then
            StripTextures(VCB_BF_CONSOLIDATED_BUFFFRAME, true)
            if not VCB_BF_CONSOLIDATED_BUFFFRAME.backdrop then CreateBackdrop(VCB_BF_CONSOLIDATED_BUFFFRAME) end
            local b = _G["VCB_BF_CONSOLIDATED_BUFFFRAMEBorder"]
            if b and b.SetAlpha then b:SetAlpha(0) end
            VCB_BF_CONSOLIDATED_BUFFFRAME:SetFrameLevel(math.max(1, (VCB_BF_CONSOLIDATED_BUFFFRAME:GetFrameLevel() or 10) - 20))
          end

          if VCB_BUTTONNAME then
            for cat, templateName in pairs(VCB_BUTTONNAME) do
              for i = VCB_MININDEX[cat], VCB_MAXINDEX[cat] do
                local btn = _G[templateName..i]
                if btn then pcall(function() if VCB_BF_BUFF_BUTTON_Update then VCB_BF_BUFF_BUTTON_Update(btn) end end) end
              end
            end
          end
        end)
      end
    end

    -- Ensure when dummy mode is disabled we re-strip any blizzard border that may have been re-added
    if VCB_BF_DummyConfigMode_Disable then
      local orig_disable = VCB_BF_DummyConfigMode_Disable
      VCB_BF_DummyConfigMode_Disable = function()
        orig_disable()
        pcall(function()
          if VCB_BF_CONSOLIDATED_BUFFFRAME then
            StripTextures(VCB_BF_CONSOLIDATED_BUFFFRAME, true)
            if not VCB_BF_CONSOLIDATED_BUFFFRAME.backdrop then CreateBackdrop(VCB_BF_CONSOLIDATED_BUFFFRAME) end
            local b = _G["VCB_BF_CONSOLIDATED_BUFFFRAMEBorder"]
            if b and b.SetAlpha then b:SetAlpha(0) end
          end
          if VCB_BUTTONNAME then
            for cat, templateName in pairs(VCB_BUTTONNAME) do
              for i = VCB_MININDEX[cat], VCB_MAXINDEX[cat] do
                local btn = _G[templateName..i]
                if btn then pcall(function() if VCB_BF_BUFF_BUTTON_Update then VCB_BF_BUFF_BUTTON_Update(btn) end end) end
              end
            end
          end

          -- Force weapon buttons to be skinned and have their borders reapplied immediately
          for i = 0, (VCB_MAXINDEX and VCB_MAXINDEX.weapon) or 1 do
            local name = "VCB_BF_WEAPON_BUTTON" .. i
            local btn = _G[name]
            if btn then
              if not btn._pfuiSkinned and skinButton then pcall(skinButton, btn) end
              local vcbBorder = _G[name .. "Border"]
              if vcbBorder and vcbBorder.GetVertexColor then
                local okc, r,g,b,a = pcall(function() return vcbBorder:GetVertexColor() end)
                if okc and r then
                  a = a or 1
                  if btn.backdrop and btn.backdrop.SetBackdropBorderColor then pcall(function() btn.backdrop:SetBackdropBorderColor(r,g,b,a) end) end
                  local ob = btn._pfuiBorder
                  if ob and ob.SetBackdropBorderColor then pcall(function() ob:SetBackdropBorderColor(r,g,b,a) end) end
                  btn._pfuiWeaponBorderColor = {r=r,g=g,b=b,a=a}
                end
              end
            end
          end

          -- Force immediate weapon update to avoid waiting for UPDATETIME
          if VCB_BF_WEAPON_BUTTON_OnEvent then pcall(VCB_BF_WEAPON_BUTTON_OnEvent, false) end
          if VCB_BF_WEAPON_BUTTON_OnUpdate then pcall(VCB_BF_WEAPON_BUTTON_OnUpdate, 2.0) end
        end)
      end
    end

    -- Protect VCB's grayed-out routine from unnamed/anonymous children (caused by external skins)
    if VCB_BF_ADD_GRAYEDOUTICONS then
      local orig_gray = VCB_BF_ADD_GRAYEDOUTICONS
      VCB_BF_ADD_GRAYEDOUTICONS = function(x)
        local ok, err = pcall(function() orig_gray(x) end)
        if not ok then
          -- Fallback: perform a safe, minimal update and avoid errors
          pcall(function()
            if grayedIcons then
              for i=0,10 do
                local g = _G["GrayedIcon"..i]
                if g and g.Hide then g:Hide() end
              end
            end
            if _G["VCB_BF_CONSOLIDATED_ICONCount"] then
              pcall(function() _G["VCB_BF_CONSOLIDATED_ICONCount"]:SetText((x or 0)-1) end)
            end
            if VCB_BF_ResizeConsolidatedFrame then pcall(VCB_BF_ResizeConsolidatedFrame, (x or 0)-1) end
          end)
        end
      end
    end

    if VCB_BF_updateBuffs then pcall(VCB_BF_updateBuffs) end
    pfUI.addonskinner:UnregisterSkin("VCB")
  end)
end)