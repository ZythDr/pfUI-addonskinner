-- Skin recipe frame text elements
local function pfui_skin_recipe_frame_text()
  if not pfUI or not pfUI.font_default then return end
  local font = pfUI.font_default
  
  for i = 1, 20 do
    local name = getglobal("ATSWReagent" .. i .. "Title")
    local count = getglobal("ATSWReagent" .. i .. "Amount")
    if name then name:SetFont(font, 12, "OUTLINE"); name:SetTextColor(1, 1, 1, 1) end
    if count then count:SetFont(font, 12, "OUTLINE"); count:SetTextColor(1, 1, 1, 1) end
  end
  
  for i = 1, 4 do
    local toolText = getglobal("ATSWTool" .. i .. "Text")
    if toolText then toolText:SetFont(font, 12, "OUTLINE"); toolText:SetTextColor(1, 1, 1, 1) end
  end
  
  local simpleTexts = { ATSWRecipeName, ATSWAmountBox, ATSWCostText, ATSWCraftDescription }
  for _, t in ipairs(simpleTexts) do
    if t then t:SetFont(font, t == ATSWRecipeName and 14 or 12, "OUTLINE"); t:SetTextColor(1, 1, 1, 1) end
  end
  
  local yellowTexts = { ATSWToolsLabel, ATSWReagentsLabel }
  for _, t in ipairs(yellowTexts) do
    if t then t:SetFont(font, 12, "OUTLINE"); t:SetTextColor(1, 0.82, 0, 1) end
  end
end

-- Hook update functions
for _, funcName in ipairs({"ATSW_UpdateRecipes", "ATSW_UpdateListScroll"}) do
  local hookFlag = "pfUI_" .. funcName .. "_Hooked"
  if getglobal(funcName) and not getglobal(hookFlag) then
    local orig = getglobal(funcName)
    setglobal(funcName, function(...) local r = orig(unpack(arg)); pfui_skin_recipe_frame_text(); return r end)
    setglobal(hookFlag, true)
  end
end

pfui_skin_recipe_frame_text()

pfUI.addonskinner:RegisterSkin("AdvancedTradeSkillWindow2", function()
  local font = pfUI and pfUI.font_default or "Fonts\\FRIZQT__.ttf"
  if ATSWYellowFontThin then
    ATSWYellowFontThin:SetFont(font, 12, "OUTLINE")
    ATSWYellowFontThin:SetTextColor(1, 1, 1, 1)
  end

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

  -- Generic dynamic button skinner
  local function SkinDynamicButton(button, hasDeleteBtn)
    if not button or button.pfui_skinned then return end
    StripTextures(button)
    local icon = getglobal(button:GetName() .. "Icon")
    if icon then icon:SetTexCoord(.08, .92, .08, .92) end
    if hasDeleteBtn then
      local del = getglobal(button:GetName() .. "DeleteButton")
      if del then SkinCloseButton(del) end
    end
    button.pfui_skinned = true
  end

  -- Scroll frames helper
  local function SkinScrollFrame(frameName)
    local frame = getglobal(frameName)
    if frame then
      StripTextures(frame)
      local scrollBar = getglobal(frameName .. "ScrollBar")
      if scrollBar then SkinScrollbar(scrollBar) end
    end
  end

  -- Frame skinning helper
  local function SkinSubFrame(frameName, closeBtn)
    local frame = getglobal(frameName)
    if frame then
      StripTextures(frame, true)
      CreateBackdrop(frame, nil, nil, .75)
      frame.backdrop:SetAllPoints(frame)
      if closeBtn then
        local btn = getglobal(closeBtn)
        if btn then SkinCloseButton(btn, frame.backdrop, -6, -6) end
      end
    end
  end

  -- Main frame
  ATSWFrame:DisableDrawLayer("BACKGROUND")
  StripTextures(ATSWFrame, true)
  CreateBackdrop(ATSWFrame, nil, nil, .75)
  ATSWFrame.backdrop:SetAllPoints(ATSWFrame)
  if ATSWFramePortrait then ATSWFramePortrait:SetAlpha(0) end
  SkinCloseButton(ATSWFrameCloseButton, ATSWFrame.backdrop, -6, -6)

  -- Strip background textures
  for _, name in ipairs({"ATSWScrollBackgroundTop", "ATSWScrollBackgroundMiddle", "ATSWScrollBackgroundBottom", "ATSWHorizontalBar1Left", "ATSWHorizontalBar1LeftAddon", "ATSWHorizontalBar2Left", "ATSWHorizontalBar2LeftAddon", "ATSWParchment", "ATSWWeb", "ATSWBackground", "ATSWBackgroundShadow"}) do
    local tex = getglobal(name)
    if tex then tex:SetTexture(nil); tex:SetAlpha(0) end
  end

  -- Rank bar
  if ATSWRankFrame then
    StripTextures(ATSWRankFrame)
    if ATSWRankFrameBorder then StripTextures(ATSWRankFrameBorder) end
    ATSWRankFrame:SetStatusBarTexture("Interface\\AddOns\\pfUI\\img\\bar")
    ATSWRankFrame:SetHeight(12)
    CreateBackdrop(ATSWRankFrame)
  end

  -- Sort radio buttons
  for _, name in ipairs({"ATSWCategorySortCheckbox", "ATSWDifficultySortCheckbox", "ATSWNameSortCheckbox", "ATSWCustomSortCheckbox"}) do
    local btn = getglobal(name)
    if btn then
      SkinCheckbox(btn, 20)
      local check = getglobal(name .. "Check")
      if check then check:SetTexture("Interface\\AddOns\\pfUI\\img\\check"); check:SetTexCoord(0, 1, 0, 1); check:SetVertexColor(1, 1, 1, 1); check:SetWidth(20); check:SetHeight(20) end
      local bg = getglobal(name .. "BG")
      if bg then bg:SetTexture("") end
      if btn.SetHighlightTexture then btn:SetHighlightTexture("") end
      if btn.SetPushedTexture then btn:SetPushedTexture("") end
    end
  end

  -- Dropdowns
  for _, dd in ipairs({ATSWSubClassDropDown, ATSWInvSlotDropDown}) do
    if dd then StripTextures(dd); SkinDropDown(dd) end
  end

  -- Search box
  if ATSWSearchBox then
    StripTextures(ATSWSearchBox, true, "BACKGROUND")
    CreateBackdrop(ATSWSearchBox, nil, true)
    ATSWSearchBox:SetHeight(20)
    if ATSWSearchIcon then ATSWSearchIcon:SetAlpha(0) end
  end
  if ATSWSearchBoxClear then SkinButton(ATSWSearchBoxClear); ATSWSearchBoxClear:SetHeight(20) end
  if ATSWSearchHelpButton then SkinButton(ATSWSearchHelpButton); ATSWSearchHelpButton:SetHeight(20); ATSWSearchHelpButton:SetWidth(20) end
  if ATSWAttributesButton then SkinCheckbox(ATSWAttributesButton, 20) end

  -- Main buttons
  for _, name in ipairs({"ATSWCreateButton", "ATSWTaskButton", "ATSWReagentsButton", "ATSWCustomEditorButton", "ATSWProgressBarStop"}) do
    local btn = getglobal(name)
    if btn then SkinButton(btn) end
  end

  -- Amount controls
  if ATSWIncrementButton then SkinArrowButton(ATSWIncrementButton, "right", 16) end
  if ATSWAmountBox then
    StripTextures(ATSWAmountBox, true, "BACKGROUND")
    CreateBackdrop(ATSWAmountBox, nil, true)
    ATSWAmountBox:SetHeight(20); ATSWAmountBox:SetWidth(42)
  end
  if ATSWDecrementButton then SkinArrowButton(ATSWDecrementButton, "left", 16) end

  -- Recipe icon
  if ATSWRecipeIcon then
    StripTextures(ATSWRecipeIcon)
    SkinButton(ATSWRecipeIcon, nil, nil, nil, nil, true)
    local iconTex = ATSWRecipeIcon:GetNormalTexture()
    if iconTex then iconTex:SetTexCoord(.08, .92, .08, .92) end
  end
  if ATSWPreviousItemButton then SkinButton(ATSWPreviousItemButton) end

  -- Reagent slots
  for i = 1, 8 do
    local btn = getglobal("ATSWReagent" .. i)
    if btn then
      local btnIcon, btnCount, btnName = getglobal("ATSWReagent" .. i .. "IconTexture"), getglobal("ATSWReagent" .. i .. "Count"), getglobal("ATSWReagent" .. i .. "Name")
      StripTextures(btn)
      CreateBackdrop(btn, nil, nil, .75)
      SetAllPointsOffset(btn.backdrop, btn, 4)
      SetHighlight(btn)
      if btnIcon then
        local size = btn:GetHeight() - 10
        btnIcon:SetWidth(size); btnIcon:SetHeight(size)
        btnIcon:ClearAllPoints(); btnIcon:SetPoint("LEFT", 5, 0)
        btnIcon:SetTexCoord(.08, .92, .08, .92)
        btnIcon:SetParent(btn.backdrop); btnIcon:SetDrawLayer("OVERLAY")
      end
      if btnCount and pfUI.font_default then
        btnCount:SetParent(btn.backdrop); btnCount:SetDrawLayer("OVERLAY")
        btnCount:ClearAllPoints(); btnCount:SetPoint("BOTTOMRIGHT", btnIcon, "BOTTOMRIGHT", 0, 0)
        btnCount:SetFont(pfUI.font_default, 12, "OUTLINE"); btnCount:SetTextColor(1, 1, 1, 1)
      end
      if btnName and pfUI.font_default then
        btnName:SetParent(btn.backdrop)
        btnName:SetFont(pfUI.font_default, 12, "OUTLINE"); btnName:SetTextColor(1, 1, 1, 1)
      end
    end
  end

  -- Labels
  for _, lbl in ipairs({ATSWReagentLabel, ATSWToolLabel, ATSWToolName}) do
    if lbl and pfUI.font_default then
      lbl:SetFont(pfUI.font_default, 12, "OUTLINE"); lbl:SetTextColor(1, 1, 1, 1)
    end
  end

  -- Recipe list scroll
  SkinScrollFrame("ATSWListScrollFrame")
  if ATSWListScrollFrame then
    HookScript(ATSWListScrollFrame, "OnShow", function()
      local sb = getglobal("ATSWListScrollFrameScrollBar")
      if sb and not sb.pfui_skinned then SkinScrollbar(sb); sb.pfui_skinned = true end
    end)
  end

  -- Misc elements
  if ATSWExpandButtonFrame then StripTextures(ATSWExpandButtonFrame) end
  if ATSWHighlight then StripTextures(ATSWHighlight) end
  if ATSWHighlightMouseOver then StripTextures(ATSWHighlightMouseOver) end

  -- Task scroll frame
  if ATSWTaskScrollFrameBackground then StripTextures(ATSWTaskScrollFrameBackground) end
  if ATSWTaskScrollFrame then
    StripTextures(ATSWTaskScrollFrame)
    local function SkinTaskScrollBar()
      local scrollBar = getglobal("ATSWTaskScrollFrameScrollBar") or ATSWTaskScrollFrame.ScrollBar
      if not scrollBar then
        for _, child in ipairs({ATSWTaskScrollFrame:GetChildren()}) do
          if child and child:GetObjectType() == "Slider" then scrollBar = child; break end
        end
      end
      if scrollBar and not scrollBar.pfui_skinned then SkinScrollbar(scrollBar); scrollBar.pfui_skinned = true end
    end
    SkinTaskScrollBar()
    HookScript(ATSWTaskScrollFrame, "OnShow", SkinTaskScrollBar)
    hooksecurefunc("ATSW_UpdateTasks", SkinTaskScrollBar, true)
  end

  -- Progress bar
  if ATSWProgressBar then
    StripTextures(ATSWProgressBar)
    ATSWProgressBar:SetStatusBarTexture("Interface\\AddOns\\pfUI\\img\\bar")
    CreateBackdrop(ATSWProgressBar)
  end
  if ATSWProgressBarBorder then StripTextures(ATSWProgressBarBorder) end
  if ATSWTrainingPointsFrame then StripTextures(ATSWTrainingPointsFrame) end

  -- Side tabs
  local function SkinSideTab(tab)
    if not tab or tab.pfui_skinned then return end
    for _, region in ipairs({tab:GetRegions()}) do
      if region and region:GetObjectType() == "Texture" and region:GetDrawLayer() == "BACKGROUND" then
        region:SetTexture(nil)
      end
    end
    CreateBackdrop(tab, nil, nil, .75)
    if tab.backdrop then
      tab.backdrop:SetFrameLevel(tab:GetFrameLevel() - 1)
      tab.backdrop:EnableMouse(false)
    end
    SetHighlight(tab)
    tab:EnableMouse(true)
    tab:SetFrameLevel(tab:GetParent():GetFrameLevel() + 2)
    local function UpdateIcon()
      local tex = tab:GetNormalTexture()
      if tex then tex:SetTexCoord(.08, .92, .08, .92); tex:SetDrawLayer("ARTWORK") end
    end
    UpdateIcon()
    local orig = tab:GetScript("OnShow")
    tab:SetScript("OnShow", function() if orig then orig() end; UpdateIcon() end)
    tab.pfui_skinned = true
  end

  for i = 1, 20 do
    local tab = getglobal("ATSWFrameTab" .. i)
    if tab then SkinSideTab(tab) end
  end

  -- Skin existing dynamic buttons
  for i = 1, 30 do
    SkinDynamicButton(getglobal("ATSWRecipe" .. i))
    SkinDynamicButton(getglobal("ATSWTool" .. i))
    SkinDynamicButton(getglobal("ATSWTask" .. i), true)
  end

  -- Hook dynamic button creation
  hooksecurefunc("ATSW_CreateRecipeButtons", function()
    for i = 1, 30 do SkinDynamicButton(getglobal("ATSWRecipe" .. i)) end
  end, true)
  hooksecurefunc("ATSW_CreateToolButtons", function()
    for i = 1, 10 do SkinDynamicButton(getglobal("ATSWTool" .. i)) end
  end, true)
  hooksecurefunc("ATSW_CreateTaskButtons", function()
    for i = 1, 10 do SkinDynamicButton(getglobal("ATSWTask" .. i), true) end
  end, true)

  -- Sub frames
  SkinSubFrame("ATSWReagentsFrame", "ATSWReagentsFrameCloseButton")
  SkinScrollFrame("ATSWRFScrollFrame")

  -- Config frame
  if ATSWConfigFrame then
    SkinSubFrame("ATSWConfigFrame")
    if ATSWOptionsMenuHeader then ATSWOptionsMenuHeader:SetAlpha(0) end
  end

  for _, name in ipairs({"ATSWOFUnifiedButton", "ATSWOFSeparateButton", "ATSWOFIncludeBankButton", "ATSWOFIncludeAltsButton", "ATSWOFIncludeMerchantsButton", "ATSWOFAutoBuyButton", "ATSWOFTooltipButton", "ATSWOFShoppingListButton"}) do
    local cb = getglobal(name)
    if cb then SkinCheckbox(cb, 20) end
  end

  for _, name in ipairs({"ATSWOptionsTotalDisplayed", "ATSWOptionsTotalInclude", "ATSWOptionsAddonsCompat", "ATSWOptionsAddonsCompatTable"}) do
    local frame = getglobal(name)
    if frame then StripTextures(frame); CreateBackdrop(frame, nil, nil, .85) end
  end

  if ATSWConfigFrameOKButton then SkinButton(ATSWConfigFrameOKButton) end

  -- Search help frame
  if ATSWSearchHelpFrame then
    StripTextures(ATSWSearchHelpFrame, true)
    CreateBackdrop(ATSWSearchHelpFrame, nil, nil, .75)
    if ATSWHelpMenuHeader then ATSWHelpMenuHeader:SetAlpha(0) end
    if ATSWSearchHelpFrameOKButton then SkinButton(ATSWSearchHelpFrameOKButton) end
  end

  -- Shopping list frame
  SkinSubFrame("ATSWShoppingListFrame", "ATSWShoppingListFrameCloseButton")
  SkinScrollFrame("ATSWSLScrollFrame")

  -- Buy necessary frame
  if ATSWBuyNecessaryFrame then
    StripTextures(ATSWBuyNecessaryFrame, true)
    CreateBackdrop(ATSWBuyNecessaryFrame, nil, nil, .75)
    if ATSWBuyButton then SkinButton(ATSWBuyButton) end
  end

  -- Custom sorting frame
  SkinSubFrame("ATSWCSFrame", "ATSWCSFrameCloseButton")
  SkinScrollFrame("ATSWCSUListScrollFrame")
  SkinScrollFrame("ATSWCSSListScrollFrame")

  for _, name in ipairs({"ATSWCSButton", "ATSWCSAddButton", "ATSWCSDeleteButton", "ATSWCSUpButton", "ATSWCSDownButton", "ATSWCSOKButton", "ATSWCSCancelButton"}) do
    local btn = getglobal(name)
    if btn then SkinButton(btn) end
  end

  -- Dialog and compat
  if ATSWDialogBoxFrame_OnlyOK then
    StripTextures(ATSWDialogBoxFrame_OnlyOK, true)
    CreateBackdrop(ATSWDialogBoxFrame_OnlyOK, nil, nil, .75)
  end

  for i = 1, 10 do
    local installed = getglobal("ATSWCompatAddon" .. i .. "Installed")
    if installed then StripTextures(installed) end
  end

  if ATSWBuyPrice then
    StripTextures(ATSWBuyPrice)
    for _, suffix in ipairs({"GoldButton", "SilverButton", "CopperButton"}) do
      local btn = getglobal("ATSWBuyPrice" .. suffix)
      if btn then StripTextures(btn) end
    end
  end

  -- Main update hook
  hooksecurefunc("ATSW_Update", function()
    for i = 1, 50 do
      SkinDynamicButton(getglobal("ATSWRecipe" .. i))
      SkinDynamicButton(getglobal("ATSWTool" .. i))
      SkinDynamicButton(getglobal("ATSWTask" .. i), true)
      local rf = getglobal("ATSWRFReagent" .. i)
      if rf and not rf.pfui_skinned then StripTextures(rf); rf.pfui_skinned = true end
      local slf = getglobal("ATSWSLFReagent" .. i)
      if slf and not slf.pfui_skinned then StripTextures(slf); slf.pfui_skinned = true end
    end
  end, true)

  -- Cleanup on show
  HookScript(ATSWFrame, "OnShow", function()
    for _, region in ipairs({ATSWFrame:GetRegions()}) do
      if region and region:GetObjectType() == "Texture" then
        local tex = region:GetTexture()
        if tex and (string.find(tex, "TaxiFrame") or string.find(tex, "DialogBox") or string.find(tex, "Parchment") or string.find(tex, "ClassTrainer")) then
          region:SetTexture(nil); region:SetAlpha(0)
        end
      end
    end
  end)

  -- Combined OnUpdate timer
  local updateTimer = CreateFrame("Frame")
  updateTimer:SetScript("OnUpdate", function()
    if not ATSWFrame or not ATSWFrame:IsVisible() then return end
    
    pfui_skin_recipe_frame_text()
    
    -- Tab updates
    for i = 1, 20 do
      local tab = getglobal("ATSWFrameTab" .. i)
      if tab and tab:IsVisible() then
        if not tab.clickabilityChecked then
          tab:EnableMouse(true)
          tab:SetFrameLevel(tab:GetParent():GetFrameLevel() + 2)
          tab.clickabilityChecked = true
        end
        local tex = tab:GetNormalTexture()
        if tex then tex:SetTexCoord(.08, .92, .08, .92) end
      end
    end
    
    -- Recipe/task list fonts
    for i = 1, 30 do
      local btnText = getglobal("ATSWRecipe" .. i .. "Text")
      if btnText then btnText:SetFont(pfUI.font_default, 12, "OUTLINE") end
      local subText = getglobal("ATSWRecipe" .. i .. "SubText")
      if subText then subText:SetFont(pfUI.font_default, 11, "OUTLINE") end
      local taskText = getglobal("ATSWTask" .. i .. "Text")
      if taskText then taskText:SetFont(pfUI.font_default, 12, "OUTLINE"); taskText:SetTextColor(1, 1, 1, 1) end
      local taskSub = getglobal("ATSWTask" .. i .. "SubText")
      if taskSub then taskSub:SetFont(pfUI.font_default, 11, "OUTLINE"); taskSub:SetTextColor(1, 1, 1, 1) end
    end
    
    if ATSWAttributesLabel then
      ATSWAttributesLabel:SetFont(pfUI.font_default, 12)
      ATSWAttributesLabel:SetTextColor(1, 0.82, 0, 1)
    end
  end)

  pfUI.addonskinner:UnregisterSkin("AdvancedTradeSkillWindow2")
end)
