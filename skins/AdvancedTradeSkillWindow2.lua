pfUI.addonskinner:RegisterSkin("AdvancedTradeSkillWindow2", function()
  -- Import pfUI environment
  local penv = pfUI:GetEnvironment()
  local StripTextures, CreateBackdrop, SkinButton, SkinCheckbox, SkinCloseButton, 
        SkinTab, SkinScrollbar, SkinArrowButton, SkinDropDown, SkinSlider, 
        SkinCollapseButton, SetAllPointsOffset, SetHighlight, EnableMovable,
        HookScript, hooksecurefunc = 
    penv.StripTextures, penv.CreateBackdrop, penv.SkinButton, penv.SkinCheckbox,
    penv.SkinCloseButton, penv.SkinTab, penv.SkinScrollbar, penv.SkinArrowButton,
    penv.SkinDropDown, penv.SkinSlider, penv.SkinCollapseButton,
    penv.SetAllPointsOffset, penv.SetHighlight, penv.EnableMovable,
    penv.HookScript, penv.hooksecurefunc

  -- Utility
  local noop = function() end

  -- ============================================
  -- MAIN FRAME
  -- ============================================
  ATSWFrame:DisableDrawLayer("BACKGROUND")
  StripTextures(ATSWFrame, true)
  CreateBackdrop(ATSWFrame, nil, nil, .75)
  ATSWFrame.backdrop:SetAllPoints(ATSWFrame)
  
  -- Portrait and Title
  if ATSWFramePortrait then
    ATSWFramePortrait:SetAlpha(0)
  end
  -- Don't reposition title - it's at TOP of ATSWFrame, y=-17 originally
  
  -- Close button
  SkinCloseButton(ATSWFrameCloseButton, ATSWFrame.backdrop, -6, -6)
  
  -- Don't call EnableMovable - addon handles this itself

  -- Strip all background textures
  local bgTextures = {
    "ATSWScrollBackgroundTop",
    "ATSWScrollBackgroundMiddle", 
    "ATSWScrollBackgroundBottom",
    "ATSWHorizontalBar1Left",
    "ATSWHorizontalBar1LeftAddon",
    "ATSWHorizontalBar2Left",
    "ATSWHorizontalBar2LeftAddon",
    "ATSWParchment",
    "ATSWWeb",
    "ATSWBackground",
    "ATSWBackgroundShadow"
  }
  
  for _, texName in ipairs(bgTextures) do
    local tex = getglobal(texName)
    if tex then
      tex:SetTexture(nil)
      tex:SetAlpha(0)
    end
  end

  -- ============================================
  -- RANK BAR / SKILL LEVEL BAR
  -- ============================================
  if ATSWRankFrame then
    StripTextures(ATSWRankFrame)
    if ATSWRankFrameBorder then
      StripTextures(ATSWRankFrameBorder)
    end
    ATSWRankFrame:SetStatusBarTexture("Interface\\AddOns\\pfUI\\img\\bar")
    ATSWRankFrame:SetHeight(12)
    -- Don't reposition - the Lua code handles position dynamically
    CreateBackdrop(ATSWRankFrame)
  end

  -- ============================================
  -- SORT RADIO BUTTONS (Keep original positioning)
  -- ============================================
  local sortButtons = {
    "ATSWCategorySortCheckbox",
    "ATSWDifficultySortCheckbox", 
    "ATSWNameSortCheckbox",
    "ATSWCustomSortCheckbox"
  }
  
  for _, btnName in ipairs(sortButtons) do
    local btn = getglobal(btnName)
    if btn then
      SkinCheckbox(btn, 20)
    end
  end
  
  -- DON'T reposition - let them stay in original positions
  -- Original positions from XML:
  -- Category: TOPLEFT ATSWFrame x=142 y=-33
  -- Difficulty: LEFT of Category + 72
  -- Name: LEFT of Difficulty + 72  
  -- Custom: LEFT of Name + 63

  -- ============================================
  -- DROPDOWNS (Keep original positioning)
  -- ============================================
  if ATSWSubClassDropDown then
    StripTextures(ATSWSubClassDropDown)
    SkinDropDown(ATSWSubClassDropDown)
    -- Original: TOPLEFT x=427 y=-40 (don't move it)
  end
  
  if ATSWInvSlotDropDown then
    StripTextures(ATSWInvSlotDropDown)
    SkinDropDown(ATSWInvSlotDropDown)
    -- Original: LEFT of SubClass, RIGHT, x=-27 y=0 (don't move it)
  end

  -- ============================================
  -- SEARCH BOX AND BUTTONS (Keep original positioning)
  -- ============================================
  if ATSWSearchBox then
    StripTextures(ATSWSearchBox, true, "BACKGROUND")
    CreateBackdrop(ATSWSearchBox, nil, true)
    ATSWSearchBox:SetHeight(20)
    -- Original: TOPLEFT x=75 y=-51 (don't move it)
    
    -- Hide search icon if exists
    if ATSWSearchIcon then
      ATSWSearchIcon:SetAlpha(0)
    end
  end
  
  if ATSWSearchBoxClear then
    SkinButton(ATSWSearchBoxClear)
    ATSWSearchBoxClear:SetHeight(20)
    -- Original: RIGHT of SearchBox, RIGHT, x=-2 y=0 (don't move it)
  end
  
  if ATSWSearchHelpButton then
    SkinButton(ATSWSearchHelpButton)
    ATSWSearchHelpButton:SetHeight(20)
    ATSWSearchHelpButton:SetWidth(20)
    -- Original: LEFT of SearchBox, RIGHT, x=1 y=0 (don't move it)
  end

  -- Attributes button (Keep original positioning)
  if ATSWAttributesButton then
    SkinCheckbox(ATSWAttributesButton, 20)
    -- Original: LEFT of SearchHelpButton, RIGHT, x=5 y=0 (don't move it)
  end

  -- ============================================
  -- MAIN ACTION BUTTONS (Keep original positioning)
  -- ============================================
  local mainButtons = {
    "ATSWCreateButton",      -- BOTTOMRIGHT of Frame, x=-42 y=18
    "ATSWTaskButton",        -- RIGHT of CreateButton, LEFT, x=0 y=-0.5
    "ATSWReagentsButton",    -- BOTTOM of Frame, BOTTOM, x=9 y=19.5
    "ATSWCustomEditorButton", -- TOPLEFT of CustomSort, BOTTOMLEFT, x=0 y=4
    "ATSWProgressBarStop"
  }
  
  for _, btnName in ipairs(mainButtons) do
    local btn = getglobal(btnName)
    if btn then
      SkinButton(btn)
      -- Don't reposition - they're already correctly anchored
    end
  end

  -- ============================================
  -- AMOUNT CONTROLS (Keep original relative positioning)
  -- ============================================
  if ATSWIncrementButton then
    SkinArrowButton(ATSWIncrementButton, "right", 16)
    -- Original: RIGHT of TaskButton, LEFT, x=-1 y=-0.5 (don't move it)
  end
  
  if ATSWAmountBox then
    StripTextures(ATSWAmountBox, true, "BACKGROUND")
    CreateBackdrop(ATSWAmountBox, nil, true)
    ATSWAmountBox:SetHeight(20)
    ATSWAmountBox:SetWidth(42)
    -- Original: RIGHT of IncrementButton, LEFT, x=2 y=0.5 (don't move it)
  end
  
  if ATSWDecrementButton then
    SkinArrowButton(ATSWDecrementButton, "left", 16)
    -- Original: RIGHT of AmountBox, LEFT, x=-3 y=-0.5 (don't move it)
  end

  -- ============================================
  -- RECIPE ICON
  -- ============================================
  if ATSWRecipeIcon then
    StripTextures(ATSWRecipeIcon)
    SkinButton(ATSWRecipeIcon, nil, nil, nil, nil, true)
    local iconTex = ATSWRecipeIcon:GetNormalTexture()
    if iconTex then
      iconTex:SetTexCoord(.08, .92, .08, .92)
    end
  end

  -- Previous item button
  if ATSWPreviousItemButton then
    SkinButton(ATSWPreviousItemButton)
  end

  -- ============================================
  -- REAGENT SLOTS (Dynamic)
  -- ============================================
  for i = 1, 8 do
    local btn = getglobal("ATSWReagent" .. i)
    if btn then
      local btnIcon = getglobal("ATSWReagent" .. i .. "IconTexture")
      local btnCount = getglobal("ATSWReagent" .. i .. "Count")
      local btnName = getglobal("ATSWReagent" .. i .. "Name")
      
      StripTextures(btn)
      CreateBackdrop(btn, nil, nil, .75)
      SetAllPointsOffset(btn.backdrop, btn, 4)
      SetHighlight(btn)
      
      if btnIcon then
        local size = btn:GetHeight() - 10
        btnIcon:SetWidth(size)
        btnIcon:SetHeight(size)
        btnIcon:ClearAllPoints()
        btnIcon:SetPoint("LEFT", 5, 0)
        btnIcon:SetTexCoord(.08, .92, .08, .92)
        btnIcon:SetParent(btn.backdrop)
        btnIcon:SetDrawLayer("OVERLAY")
      end
      
      if btnCount then
        btnCount:SetParent(btn.backdrop)
        btnCount:SetDrawLayer("OVERLAY")
        btnCount:ClearAllPoints()
        btnCount:SetPoint("BOTTOMRIGHT", btnIcon, "BOTTOMRIGHT", 0, 0)
      end
      
      if btnName then
        btnName:SetParent(btn.backdrop)
      end
    end
  end

  -- ============================================
  -- RECIPE LIST SCROLL FRAME
  -- ============================================
  if ATSWListScrollFrame then
    StripTextures(ATSWListScrollFrame)
    local scrollBar = getglobal("ATSWListScrollFrameScrollBar")
    if scrollBar then
      SkinScrollbar(scrollBar)
    end
    
    -- Hook OnShow to ensure scrollbar is always skinned
    HookScript(ATSWListScrollFrame, "OnShow", function()
      local sb = getglobal("ATSWListScrollFrameScrollBar")
      if sb and not sb.pfui_skinned then
        SkinScrollbar(sb)
        sb.pfui_skinned = true
      end
    end)
  end

  -- Expand button frame
  if ATSWExpandButtonFrame then
    StripTextures(ATSWExpandButtonFrame)
  end

  -- Highlight frames (these are Frame objects, not Texture objects)
  if ATSWHighlight then
    StripTextures(ATSWHighlight)
  end
  if ATSWHighlightMouseOver then
    StripTextures(ATSWHighlightMouseOver)
  end

  -- ============================================
  -- TASK SCROLL FRAME
  -- ============================================
  if ATSWTaskScrollFrameBackground then
    StripTextures(ATSWTaskScrollFrameBackground)
  end
  
  if ATSWTaskScrollFrame then
    StripTextures(ATSWTaskScrollFrame)
    
    -- Function to skin the scrollbar
    local function SkinTaskScrollBar()
      -- Try multiple ways to get the scrollbar
      local scrollBar = getglobal("ATSWTaskScrollFrameScrollBar")
      if not scrollBar then
        scrollBar = ATSWTaskScrollFrame.ScrollBar
      end
      if not scrollBar then
        -- Check children
        local children = {ATSWTaskScrollFrame:GetChildren()}
        for i = 1, table.getn(children) do
          local child = children[i]
          if child and child:GetObjectType() == "Slider" then
            scrollBar = child
            break
          end
        end
      end
      
      if scrollBar and not scrollBar.pfui_skinned then
        SkinScrollbar(scrollBar)
        scrollBar.pfui_skinned = true
        return true
      end
      return false
    end
    
    -- Try immediately
    SkinTaskScrollBar()
    
    -- Hook OnShow
    HookScript(ATSWTaskScrollFrame, "OnShow", function()
      SkinTaskScrollBar()
    end)
    
    -- Also check when tasks are updated
    hooksecurefunc("ATSW_UpdateTasks", function()
      SkinTaskScrollBar()
    end, true)
  end

  -- ============================================
  -- PROGRESS BAR
  -- ============================================
  if ATSWProgressBar then
    StripTextures(ATSWProgressBar)
    ATSWProgressBar:SetStatusBarTexture("Interface\\AddOns\\pfUI\\img\\bar")
    CreateBackdrop(ATSWProgressBar)
  end
  
  if ATSWProgressBarBorder then
    StripTextures(ATSWProgressBarBorder)
  end

  -- ============================================
  -- TRAINING POINTS FRAME
  -- ============================================
  if ATSWTrainingPointsFrame then
    StripTextures(ATSWTrainingPointsFrame)
  end

  -- ============================================
  -- SIDE TABS (Dynamically Created) - SIMPLIFIED APPROACH
  -- ============================================
  
  -- Simple function that just skins without interfering
  local function SkinSideTab(tab)
    if not tab or tab.pfui_skinned then return end
    
    -- Remove spellbook background texture (in BACKGROUND layer)
    local regions = {tab:GetRegions()}
    for i = 1, table.getn(regions) do
      local region = regions[i]
      if region and region:GetObjectType() == "Texture" and region:GetDrawLayer() == "BACKGROUND" then
        region:SetTexture(nil)
      end
    end
    
    -- Create backdrop BEHIND the button, not on top
    CreateBackdrop(tab, nil, nil, .75)
    if tab.backdrop then
      tab.backdrop:SetFrameLevel(tab:GetFrameLevel() - 1)  -- Put backdrop BEHIND tab
      tab.backdrop:EnableMouse(false)  -- Backdrop shouldn't intercept clicks
    end
    
    SetHighlight(tab)
    
    -- Make sure the tab itself can receive clicks
    tab:EnableMouse(true)
    tab:SetFrameLevel(tab:GetParent():GetFrameLevel() + 2)  -- Above parent and backdrop
    
    -- The addon sets NormalTexture - we just need to crop it
    -- Do this via a repeating check since addon may set it later
    local function UpdateTabIcon()
      local tex = tab:GetNormalTexture()
      if tex then
        tex:SetTexCoord(.08, .92, .08, .92)
        tex:SetDrawLayer("ARTWORK")
      end
    end
    
    -- Apply immediately
    UpdateTabIcon()
    
    -- Store original OnShow if exists
    local origOnShow = tab:GetScript("OnShow")
    
    -- Apply on show
    tab:SetScript("OnShow", function()
      if origOnShow then origOnShow() end
      UpdateTabIcon()
    end)
    
    tab.pfui_skinned = true
  end
  
  -- Skin all tabs immediately
  for i = 1, 20 do
    local tab = getglobal("ATSWFrameTab" .. i)
    if tab then
      SkinSideTab(tab)
    end
  end
  
  -- Update tab icons periodically when frame is shown
  local tabUpdateFrame = CreateFrame("Frame")
  tabUpdateFrame:SetScript("OnUpdate", function()
    if ATSWFrame:IsVisible() then
      for i = 1, 20 do
        local tab = getglobal("ATSWFrameTab" .. i)
        if tab and tab:IsVisible() then
          -- Ensure clickability
          if not tab.clickabilityChecked then
            tab:EnableMouse(true)
            tab:SetFrameLevel(tab:GetParent():GetFrameLevel() + 2)
            tab.clickabilityChecked = true
          end
          
          -- Update icon cropping
          local tex = tab:GetNormalTexture()
          if tex then
            tex:SetTexCoord(.08, .92, .08, .92)
          end
        end
      end
    end
  end)

  -- ============================================
  -- DYNAMICALLY CREATED RECIPE BUTTONS
  -- ============================================
  local function SkinRecipeButton(button)
    if button and not button.pfui_skinned then
      StripTextures(button)
      local icon = getglobal(button:GetName() .. "Icon")
      if icon then
        icon:SetTexCoord(.08, .92, .08, .92)
      end
      button.pfui_skinned = true
    end
  end
  
  hooksecurefunc("ATSW_CreateRecipeButtons", function()
    for i = 1, 30 do
      local btn = getglobal("ATSWRecipe" .. i)
      if btn then
        SkinRecipeButton(btn)
      end
    end
  end, true)
  
  -- Skin existing recipe buttons
  for i = 1, 30 do
    local btn = getglobal("ATSWRecipe" .. i)
    if btn then
      SkinRecipeButton(btn)
    end
  end

  -- ============================================
  -- DYNAMICALLY CREATED TOOL BUTTONS
  -- ============================================
  local function SkinToolButton(button)
    if button and not button.pfui_skinned then
      StripTextures(button)
      local icon = getglobal(button:GetName() .. "Icon")
      if icon then
        icon:SetTexCoord(.08, .92, .08, .92)
      end
      button.pfui_skinned = true
    end
  end
  
  hooksecurefunc("ATSW_CreateToolButtons", function()
    for i = 1, 10 do
      local btn = getglobal("ATSWTool" .. i)
      if btn then
        SkinToolButton(btn)
      end
    end
  end, true)

  -- ============================================
  -- DYNAMICALLY CREATED TASK BUTTONS
  -- ============================================
  local function SkinTaskButton(button)
    if button and not button.pfui_skinned then
      StripTextures(button)
      local deleteBtn = getglobal(button:GetName() .. "DeleteButton")
      if deleteBtn then
        SkinCloseButton(deleteBtn)
      end
      button.pfui_skinned = true
    end
  end
  
  hooksecurefunc("ATSW_CreateTaskButtons", function()
    for i = 1, 10 do
      local btn = getglobal("ATSWTask" .. i)
      if btn then
        SkinTaskButton(btn)
      end
    end
  end, true)

  -- ============================================
  -- REAGENTS FRAME
  -- ============================================
  if ATSWReagentsFrame then
    StripTextures(ATSWReagentsFrame, true)
    CreateBackdrop(ATSWReagentsFrame, nil, nil, .75)
    ATSWReagentsFrame.backdrop:SetAllPoints(ATSWReagentsFrame)
    
    if ATSWReagentsFrameCloseButton then
      SkinCloseButton(ATSWReagentsFrameCloseButton, ATSWReagentsFrame.backdrop, -6, -6)
    end
    
    if ATSWReagentsFrameTitleText then
      -- Don't reposition - let it stay at original position
    end
  end

  -- Skin reagent frame scroll (if exists)
  local rfScrollFrame = getglobal("ATSWRFScrollFrame")
  if rfScrollFrame then
    StripTextures(rfScrollFrame)
    local scrollBar = getglobal("ATSWRFScrollFrameScrollBar")
    if scrollBar then
      SkinScrollbar(scrollBar)
    end
  end

  -- ============================================
  -- CONFIG/OPTIONS FRAME
  -- ============================================
  if ATSWConfigFrame then
    StripTextures(ATSWConfigFrame, true)
    CreateBackdrop(ATSWConfigFrame, nil, nil, .75)
    ATSWConfigFrame.backdrop:SetAllPoints(ATSWConfigFrame)
    
    -- Hide header texture
    if ATSWOptionsMenuHeader then
      ATSWOptionsMenuHeader:SetAlpha(0)
    end
  end

  -- Option checkboxes
  local optionCheckboxes = {
    "ATSWOFUnifiedButton",
    "ATSWOFSeparateButton",
    "ATSWOFIncludeBankButton",
    "ATSWOFIncludeAltsButton",
    "ATSWOFIncludeMerchantsButton",
    "ATSWOFAutoBuyButton",
    "ATSWOFTooltipButton",
    "ATSWOFShoppingListButton"
  }
  
  for _, cbName in ipairs(optionCheckboxes) do
    local cb = getglobal(cbName)
    if cb then
      SkinCheckbox(cb, 20)
    end
  end

  -- Option frame boxes
  local optionFrames = {
    "ATSWOptionsTotalDisplayed",
    "ATSWOptionsTotalInclude",
    "ATSWOptionsAddonsCompat",
    "ATSWOptionsAddonsCompatTable"
  }
  
  for _, frameName in ipairs(optionFrames) do
    local frame = getglobal(frameName)
    if frame then
      StripTextures(frame)
      CreateBackdrop(frame, nil, nil, .85)
    end
  end

  -- OK button for config
  local configOKBtn = getglobal("ATSWConfigFrameOKButton")
  if configOKBtn then
    SkinButton(configOKBtn)
  end

  -- ============================================
  -- SEARCH HELP FRAME
  -- ============================================
  if ATSWSearchHelpFrame then
    StripTextures(ATSWSearchHelpFrame, true)
    CreateBackdrop(ATSWSearchHelpFrame, nil, nil, .75)
    
    if ATSWHelpMenuHeader then
      ATSWHelpMenuHeader:SetAlpha(0)
    end
    
    local helpOKBtn = getglobal("ATSWSearchHelpFrameOKButton")
    if helpOKBtn then
      SkinButton(helpOKBtn)
    end
  end

  -- ============================================
  -- SHOPPING LIST FRAME
  -- ============================================
  if ATSWShoppingListFrame then
    StripTextures(ATSWShoppingListFrame, true)
    CreateBackdrop(ATSWShoppingListFrame, nil, nil, .75)
    ATSWShoppingListFrame.backdrop:SetAllPoints(ATSWShoppingListFrame)
    
    if ATSWShoppingListFrameTitleText then
      -- Don't reposition - let it stay at original position
    end
    
    local slCloseBtn = getglobal("ATSWShoppingListFrameCloseButton")
    if slCloseBtn then
      SkinCloseButton(slCloseBtn, ATSWShoppingListFrame.backdrop, -6, -6)
    end
  end
  
  if ATSWSLScrollFrame then
    StripTextures(ATSWSLScrollFrame)
    local slScrollBar = getglobal("ATSWSLScrollFrameScrollBar")
    if slScrollBar then
      SkinScrollbar(slScrollBar)
    end
  end

  -- ============================================
  -- BUY NECESSARY FRAME
  -- ============================================
  if ATSWBuyNecessaryFrame then
    StripTextures(ATSWBuyNecessaryFrame, true)
    CreateBackdrop(ATSWBuyNecessaryFrame, nil, nil, .75)
    
    local buyBtn = getglobal("ATSWBuyButton")
    if buyBtn then
      SkinButton(buyBtn)
    end
  end

  -- ============================================
  -- CUSTOM SORTING FRAME (if exists in CustomSorting.xml)
  -- ============================================
  if ATSWCSFrame then
    StripTextures(ATSWCSFrame, true)
    CreateBackdrop(ATSWCSFrame, nil, nil, .75)
    ATSWCSFrame.backdrop:SetAllPoints(ATSWCSFrame)
    
    local csCloseBtn = getglobal("ATSWCSFrameCloseButton")
    if csCloseBtn then
      SkinCloseButton(csCloseBtn, ATSWCSFrame.backdrop, -6, -6)
    end
  end

  -- Custom sorting scroll frames
  if ATSWCSUListScrollFrame then
    StripTextures(ATSWCSUListScrollFrame)
    local csScrollBar = getglobal("ATSWCSUListScrollFrameScrollBar")
    if csScrollBar then
      SkinScrollbar(csScrollBar)
    end
  end
  
  if ATSWCSSListScrollFrame then
    StripTextures(ATSWCSSListScrollFrame)
    local cssScrollBar = getglobal("ATSWCSSListScrollFrameScrollBar")
    if cssScrollBar then
      SkinScrollbar(cssScrollBar)
    end
  end

  -- Custom sorting buttons
  local csButtons = {
    "ATSWCSButton",
    "ATSWCSAddButton",
    "ATSWCSDeleteButton",
    "ATSWCSUpButton",
    "ATSWCSDownButton",
    "ATSWCSOKButton",
    "ATSWCSCancelButton"
  }
  
  for _, btnName in ipairs(csButtons) do
    local btn = getglobal(btnName)
    if btn then
      SkinButton(btn)
    end
  end

  -- ============================================
  -- ADDITIONAL BUTTONS AND ELEMENTS
  -- ============================================
  
  -- Any dialog boxes
  if ATSWDialogBoxFrame_OnlyOK then
    StripTextures(ATSWDialogBoxFrame_OnlyOK, true)
    CreateBackdrop(ATSWDialogBoxFrame_OnlyOK, nil, nil, .75)
  end

  -- Compat addon checkmarks
  for i = 1, 10 do
    local compatFrame = getglobal("ATSWCompatAddon" .. i)
    if compatFrame then
      local installedBtn = getglobal("ATSWCompatAddon" .. i .. "Installed")
      if installedBtn then
        StripTextures(installedBtn)
      end
    end
  end

  -- Money frames (if they use templates)
  local function SkinMoneyFrame(frame)
    if frame then
      StripTextures(frame)
      local goldBtn = getglobal(frame:GetName() .. "GoldButton")
      local silverBtn = getglobal(frame:GetName() .. "SilverButton")
      local copperBtn = getglobal(frame:GetName() .. "CopperButton")
      
      if goldBtn then StripTextures(goldBtn) end
      if silverBtn then StripTextures(silverBtn) end
      if copperBtn then StripTextures(copperBtn) end
    end
  end
  
  -- Skin any money displays
  if ATSWBuyPrice then
    SkinMoneyFrame(ATSWBuyPrice)
  end

  -- ============================================
  -- HOOK FOR ANY REMAINING DYNAMIC ELEMENTS
  -- ============================================
  
  -- Hook the main update function to catch any late-created elements
  hooksecurefunc("ATSW_Update", function()
    -- Check for any unskinned recipe buttons
    for i = 1, 50 do
      local btn = getglobal("ATSWRecipe" .. i)
      if btn and not btn.pfui_skinned then
        SkinRecipeButton(btn)
      end
      
      local tool = getglobal("ATSWTool" .. i)
      if tool and not tool.pfui_skinned then
        SkinToolButton(tool)
      end
      
      local task = getglobal("ATSWTask" .. i)
      if task and not task.pfui_skinned then
        SkinTaskButton(task)
      end
      
      local reagent = getglobal("ATSWRFReagent" .. i)
      if reagent and not reagent.pfui_skinned then
        StripTextures(reagent)
        reagent.pfui_skinned = true
      end
      
      local slReagent = getglobal("ATSWSLFReagent" .. i)
      if slReagent and not slReagent.pfui_skinned then
        StripTextures(slReagent)
        slReagent.pfui_skinned = true
      end
    end
  end, true)

  -- ============================================
  -- FINAL CLEANUP
  -- ============================================
  
  -- Hide any remaining Blizzard UI textures we might have missed
  HookScript(ATSWFrame, "OnShow", function()
    -- Additional cleanup on show
    local regions = {ATSWFrame:GetRegions()}
    for i = 1, table.getn(regions) do
      local region = regions[i]
      if region and region:GetObjectType() == "Texture" then
        local texPath = region:GetTexture()
        if texPath and (
          string.find(texPath, "TaxiFrame") or 
          string.find(texPath, "DialogBox") or
          string.find(texPath, "Parchment") or
          string.find(texPath, "ClassTrainer")
        ) then
          region:SetTexture(nil)
          region:SetAlpha(0)
        end
      end
    end
  end)

  pfUI.addonskinner:UnregisterSkin("AdvancedTradeSkillWindow2")
end)
