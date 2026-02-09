pfUI.addonskinner:RegisterSkin("DoiteAuras", function()
  -- Import pfUI environment
  local penv = pfUI:GetEnvironment()
  local StripTextures = penv.StripTextures
  local CreateBackdrop = penv.CreateBackdrop
  local SkinButton = penv.SkinButton
  local SkinCheckbox = penv.SkinCheckbox
  local SkinCloseButton = penv.SkinCloseButton
  local SkinScrollbar = penv.SkinScrollbar
  local SkinDropDown = penv.SkinDropDown
  local SkinSlider = penv.SkinSlider
  
  -- ============================================
  -- MAIN DOITEAURAS FRAME (DoiteAuras.lua)
  -- ============================================
  local function SkinMainFrame()
    local mainFrame = getglobal("DoiteAurasFrame")
    if mainFrame and not mainFrame.pfui_skinned then
      StripTextures(mainFrame, true)
      CreateBackdrop(mainFrame, nil, nil, .75)
      mainFrame.backdrop:SetAllPoints(mainFrame)
      
      -- Skin named buttons
      local btns = {"DoiteAurasExportButton", "DoiteAurasImportButton", "DoiteAurasSettingsButton", "DoiteAurasAddBtn"}
      for _, btnName in ipairs(btns) do
        local btn = getglobal(btnName)
        if btn then SkinButton(btn) end
      end
      
      -- Skin unnamed buttons (close button and test all button)
      local children = {mainFrame:GetChildren()}
      for i = 1, table.getn(children) do
        local child = children[i]
        if child and child:GetObjectType() == "Button" and not child:GetName() then
          -- Check if it's the close button (TOPRIGHT) or test all (BOTTOMLEFT)
          local point = child:GetPoint(1)
          if point == "TOPRIGHT" then
            SkinCloseButton(child, mainFrame.backdrop, -6, -6)
          else
            SkinButton(child)  -- Test All button
          end
        elseif child and child:GetObjectType() == "CheckButton" then
          SkinCheckbox(child, 20)
        end
      end
      
      -- Skin dropdowns - use SkinDropDown
      local dropdowns = {"DoiteAurasAbilityDropDown", "DoiteAurasItemDropDown", "DoiteAurasBarDropDown"}
      for _, ddName in ipairs(dropdowns) do
        local dd = getglobal(ddName)
        if dd then
          StripTextures(dd)
          SkinDropDown(dd)
        end
      end
      
      -- Skin input box
      local input = getglobal("DoiteAurasInput")
      if input then
        StripTextures(input, true, "BACKGROUND")
        CreateBackdrop(input, nil, true)
      end
      
      -- Skin scrollbar
      local scrollBar = getglobal("DoiteAurasScrollScrollBar")
      if scrollBar then SkinScrollbar(scrollBar) end
      
      mainFrame.pfui_skinned = true
    end
    
    -- Skin dynamic list elements
    local listContent = getglobal("DoiteAurasListContent")
    if listContent then
      local listChildren = {listContent:GetChildren()}
      for i = 1, table.getn(listChildren) do
        local row = listChildren[i]
        if row then
          if row.editBtn and not row.editBtn.pfui_skinned then
            SkinButton(row.editBtn)
            row.editBtn.pfui_skinned = true
          end
          if row.removeBtn and not row.removeBtn.pfui_skinned then
            SkinButton(row.removeBtn)
            row.removeBtn.pfui_skinned = true
          end
          if row.upBtn and not row.upBtn.pfui_skinned then
            CreateBackdrop(row.upBtn, nil, nil, .75)
            if row.upBtn.backdrop then
              row.upBtn.backdrop:SetAllPoints(row.upBtn)
              row.upBtn.backdrop:SetFrameLevel(row.upBtn:GetFrameLevel() - 1)
            end
            local tex = row.upBtn:GetNormalTexture()
            if tex then tex:SetTexCoord(.2, .8, .2, .8) end
            row.upBtn.pfui_skinned = true
          end
          if row.downBtn and not row.downBtn.pfui_skinned then
            CreateBackdrop(row.downBtn, nil, nil, .75)
            if row.downBtn.backdrop then
              row.downBtn.backdrop:SetAllPoints(row.downBtn)
              row.downBtn.backdrop:SetFrameLevel(row.downBtn:GetFrameLevel() - 1)
            end
            local tex = row.downBtn:GetNormalTexture()
            if tex then tex:SetTexCoord(.2, .8, .2, .8) end
            row.downBtn.pfui_skinned = true
          end
          if row.disableCheck and not row.disableCheck.pfui_skinned then
            SkinCheckbox(row.disableCheck, 14)
            row.disableCheck.pfui_skinned = true
          end
          if row.sortTime and not row.sortTime.pfui_skinned then
            SkinCheckbox(row.sortTime, 14)
            row.sortTime.pfui_skinned = true
          end
          if row.sortPrio and not row.sortPrio.pfui_skinned then
            SkinCheckbox(row.sortPrio, 14)
            row.sortPrio.pfui_skinned = true
          end
          if row.fixedCheck and not row.fixedCheck.pfui_skinned then
            SkinCheckbox(row.fixedCheck, 14)
            row.fixedCheck.pfui_skinned = true
          end
        end
      end
    end
  end
  
  -- ============================================
  -- EDIT FRAME (DoiteEdit.lua - DoiteConditionsFrame)
  -- ============================================
  local function SkinEditFrame()
    local condFrame = getglobal("DoiteConditionsFrame")
    if condFrame and not condFrame.pfui_skinned then
      StripTextures(condFrame, true)
      CreateBackdrop(condFrame, nil, nil, .75)
      condFrame.backdrop:SetAllPoints(condFrame)
      
      -- Skin all dropdowns
      local dropdowns = {
        "DoiteConditions_GroupDD", "DoiteConditions_GrowthDD", "DoiteConditions_NumAurasDD",
        "DoiteCond_Ability_GroupingDD", "DoiteCond_Ability_DistanceDD", "DoiteCond_Ability_UnitTypeDD",
        "DoiteCond_Ability_SliderDir", "DoiteCond_Ability_WeaponDD", "DoiteCond_Ability_FormDD",
        "DoiteCond_Aura_GroupingDD", "DoiteCond_Aura_DistanceDD", "DoiteCond_Aura_UnitTypeDD",
        "DoiteCond_Aura_WeaponDD", "DoiteCond_Aura_FormDD", "DoiteCond_Item_GroupingDD",
        "DoiteCond_Item_Enchant", "DoiteCond_Item_DistanceDD", "DoiteCond_Item_UnitTypeDD",
        "DoiteCond_Item_WeaponDD", "DoiteCond_Item_FormDD", "DoiteCond_Category_Dropdown"
      }
      for _, ddName in ipairs(dropdowns) do
        local dd = getglobal(ddName)
        if dd then
          StripTextures(dd)
          SkinDropDown(dd)
        end
      end
      
      -- Skin sliders
      local sliders = {
        "DoiteConditions_SpacingSlider",
        "DoiteConditions_SliderX",
        "DoiteConditions_SliderY",
        "DoiteConditions_SliderSize"
      }
      for _, sliderName in ipairs(sliders) do
        local slider = getglobal(sliderName)
        if slider then SkinSlider(slider) end
      end
      
      -- Skin grid button
      local gridBtn = getglobal("DoiteConditions_GridBtn")
      if gridBtn then SkinButton(gridBtn) end
      
      -- Skin checkboxes
      if condFrame.leaderCB then SkinCheckbox(condFrame.leaderCB, 20) end
      if condFrame.categoryCheck then SkinCheckbox(condFrame.categoryCheck, 20) end
      
      -- Skin edit boxes
      if condFrame.categoryInput then
        StripTextures(condFrame.categoryInput, true, "BACKGROUND")
        CreateBackdrop(condFrame.categoryInput, nil, true)
      end
      if condFrame.sliderXBox then
        StripTextures(condFrame.sliderXBox, true, "BACKGROUND")
        CreateBackdrop(condFrame.sliderXBox, nil, true)
      end
      if condFrame.sliderYBox then
        StripTextures(condFrame.sliderYBox, true, "BACKGROUND")
        CreateBackdrop(condFrame.sliderYBox, nil, true)
      end
      if condFrame.sliderSizeBox then
        StripTextures(condFrame.sliderSizeBox, true, "BACKGROUND")
        CreateBackdrop(condFrame.sliderSizeBox, nil, true)
      end
      
      -- Skin buttons
      if condFrame.categoryButton then SkinButton(condFrame.categoryButton) end
      
      -- Skin dynamic condition row buttons (Ability/Buff/Debuff/Talent conditions)
      local anchors = {condFrame.abilityAuraAnchor, condFrame.auraAuraAnchor, condFrame.itemAuraAnchor}
      for _, anchor in ipairs(anchors) do
        if anchor then
          local anchorChildren = {anchor:GetChildren()}
          for i = 1, table.getn(anchorChildren) do
            local row = anchorChildren[i]
            if row then
              -- Skin row buttons
              if row.btn1 and not row.btn1.pfui_skinned then
                SkinButton(row.btn1)
                row.btn1.pfui_skinned = true
              end
              if row.btn2 and not row.btn2.pfui_skinned then
                SkinButton(row.btn2)
                row.btn2.pfui_skinned = true
              end
              if row.btn3 and not row.btn3.pfui_skinned then
                SkinButton(row.btn3)
                row.btn3.pfui_skinned = true
              end
              if row.closeBtn and not row.closeBtn.pfui_skinned then
                SkinButton(row.closeBtn)
                row.closeBtn.pfui_skinned = true
              end
              if row.addButton and not row.addButton.pfui_skinned then
                SkinButton(row.addButton)
                row.addButton.pfui_skinned = true
              end
              -- Skin edit box
              if row.editBox and not row.editBox.pfui_skinned then
                StripTextures(row.editBox, true, "BACKGROUND")
                CreateBackdrop(row.editBox, nil, true)
                row.editBox.pfui_skinned = true
              end
              -- Skin dropdown
              if row.abilityDD and not row.abilityDD.pfui_skinned then
                StripTextures(row.abilityDD)
                SkinDropDown(row.abilityDD)
                row.abilityDD.pfui_skinned = true
              end
            end
          end
        end
      end
      
      condFrame.pfui_skinned = true
    end
  end
  
  -- ============================================
  -- EXPORT FRAME (DoiteExport.lua)
  -- ============================================
  local function SkinExportFrame()
    local exportFrame = getglobal("DoiteAurasExportFrame")
    if exportFrame and not exportFrame.pfui_skinned then
      StripTextures(exportFrame, true)
      CreateBackdrop(exportFrame, nil, nil, .75)
      exportFrame.backdrop:SetAllPoints(exportFrame)
      
      -- Find close button
      local children = {exportFrame:GetChildren()}
      for i = 1, table.getn(children) do
        local child = children[i]
        if child and child:GetObjectType() == "Button" and not child:GetName() then
          SkinCloseButton(child, exportFrame.backdrop, -6, -6)
          break
        end
      end
      
      -- Skin scrollbars
      local scrollBar1 = getglobal("DoiteAurasExportScrollScrollBar")
      if scrollBar1 then SkinScrollbar(scrollBar1) end
      local scrollBar2 = getglobal("DoiteAurasExportTextScrollScrollBar")
      if scrollBar2 then SkinScrollbar(scrollBar2) end
      
      -- Skin edit box
      local editBox = getglobal("DoiteAurasExportEditBox")
      if editBox then
        StripTextures(editBox, true, "BACKGROUND")
        CreateBackdrop(editBox, nil, true)
      end
      
      -- Skin buttons
      local btns = {"DoiteAurasCreateExportButton", "DoiteAurasClearExportButton", "DoiteAurasCopyExportButton"}
      for _, btnName in ipairs(btns) do
        local btn = getglobal(btnName)
        if btn then SkinButton(btn) end
      end
      
      exportFrame.pfui_skinned = true
    end
  end
  
  -- ============================================
  -- IMPORT FRAME (DoiteExport.lua)
  -- ============================================
  local function SkinImportFrame()
    local importFrame = getglobal("DoiteAurasImportFrame")
    if importFrame and not importFrame.pfui_skinned then
      StripTextures(importFrame, true)
      CreateBackdrop(importFrame, nil, nil, .75)
      importFrame.backdrop:SetAllPoints(importFrame)
      
      -- Find close button
      local children = {importFrame:GetChildren()}
      for i = 1, table.getn(children) do
        local child = children[i]
        if child and child:GetObjectType() == "Button" and not child:GetName() then
          SkinCloseButton(child, importFrame.backdrop, -6, -6)
          break
        end
      end
      
      -- Skin scrollbar
      local scrollBar = getglobal("DoiteAurasImportScrollScrollBar")
      if scrollBar then SkinScrollbar(scrollBar) end
      
      -- Skin edit box
      local editBox = getglobal("DoiteAurasImportEditBox")
      if editBox then
        StripTextures(editBox, true, "BACKGROUND")
        CreateBackdrop(editBox, nil, true)
      end
      
      -- Skin button
      local btn = getglobal("DoiteAurasImportDoButton")
      if btn then SkinButton(btn) end
      
      importFrame.pfui_skinned = true
    end
  end
  
  -- ============================================
  -- SETTINGS FRAME (DoiteSettings.lua)
  -- ============================================
  local function SkinSettingsFrame()
    local settingsFrame = getglobal("DoiteAurasSettingsFrame")
    if settingsFrame and not settingsFrame.pfui_skinned then
      StripTextures(settingsFrame, true)
      CreateBackdrop(settingsFrame, nil, nil, .75)
      settingsFrame.backdrop:SetAllPoints(settingsFrame)
      
      -- Skin buttons - first unnamed is close button, rest are regular buttons
      local children = {settingsFrame:GetChildren()}
      local unnamedCount = 0
      for i = 1, table.getn(children) do
        local child = children[i]
        if child and child:GetObjectType() == "Button" then
          if not child:GetName() then
            unnamedCount = unnamedCount + 1
            if unnamedCount == 1 then
              -- First unnamed button is the close button
              SkinCloseButton(child, settingsFrame.backdrop, -6, -6)
            else
              -- Other unnamed buttons are regular buttons (pfUI icons button)
              SkinButton(child)
            end
          else
            -- Named buttons
            SkinButton(child)
          end
        end
      end
      
      settingsFrame.pfui_skinned = true
    end
  end
  
  -- ============================================
  -- IMMEDIATE SKINNING WITH ONSHOW HOOKS
  -- ============================================
  
  -- Hook OnShow for instant skinning
  local function HookOnShow(frameName, skinFunc)
    local frame = getglobal(frameName)
    if frame and not frame.pfui_onshow_hooked then
      local origOnShow = frame:GetScript("OnShow")
      frame:SetScript("OnShow", function()
        if origOnShow then origOnShow() end
        skinFunc()
      end)
      frame.pfui_onshow_hooked = true
    end
  end
  
  -- Periodic checker
  local updateFrame = CreateFrame("Frame")
  updateFrame.elapsed = 0
  updateFrame:SetScript("OnUpdate", function()
    this.elapsed = this.elapsed + arg1
    if this.elapsed > 0.5 then
      this.elapsed = 0
      
      SkinMainFrame()
      SkinEditFrame()
      SkinExportFrame()
      SkinImportFrame()
      SkinSettingsFrame()
      
      -- Also skin dynamic condition rows in edit frame
      local condFrame = getglobal("DoiteConditionsFrame")
      if condFrame then
        local anchors = {condFrame.abilityAuraAnchor, condFrame.auraAuraAnchor, condFrame.itemAuraAnchor}
        for _, anchor in ipairs(anchors) do
          if anchor then
            local anchorChildren = {anchor:GetChildren()}
            for i = 1, table.getn(anchorChildren) do
              local row = anchorChildren[i]
              if row then
                if row.btn1 and not row.btn1.pfui_skinned then
                  SkinButton(row.btn1)
                  row.btn1.pfui_skinned = true
                end
                if row.btn2 and not row.btn2.pfui_skinned then
                  SkinButton(row.btn2)
                  row.btn2.pfui_skinned = true
                end
                if row.btn3 and not row.btn3.pfui_skinned then
                  SkinButton(row.btn3)
                  row.btn3.pfui_skinned = true
                end
                if row.closeBtn and not row.closeBtn.pfui_skinned then
                  SkinButton(row.closeBtn)
                  row.closeBtn.pfui_skinned = true
                end
                if row.addButton and not row.addButton.pfui_skinned then
                  SkinButton(row.addButton)
                  row.addButton.pfui_skinned = true
                end
                if row.editBox and not row.editBox.pfui_skinned then
                  StripTextures(row.editBox, true, "BACKGROUND")
                  CreateBackdrop(row.editBox, nil, true)
                  row.editBox.pfui_skinned = true
                end
                if row.abilityDD and not row.abilityDD.pfui_skinned then
                  StripTextures(row.abilityDD)
                  SkinDropDown(row.abilityDD)
                  row.abilityDD.pfui_skinned = true
                end
              end
            end
          end
        end
      end
      
      -- Hook OnShow after frames exist
      HookOnShow("DoiteAurasFrame", SkinMainFrame)
      HookOnShow("DoiteConditionsFrame", SkinEditFrame)
      HookOnShow("DoiteAurasExportFrame", SkinExportFrame)
      HookOnShow("DoiteAurasImportFrame", SkinImportFrame)
      HookOnShow("DoiteAurasSettingsFrame", SkinSettingsFrame)
    end
  end)
  
  pfUI.addonskinner:UnregisterSkin("DoiteAuras")
end)
