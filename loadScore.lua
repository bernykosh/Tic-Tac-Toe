--------------------------------------------------------
--STUDENT NAME  :   BERNEDETTE KOSHILA PERERA           
--STUDENT ID    :   10449314                             
--UNIT TITLE    :   MOBILE APPLICATIONS DEVELOPMENT     
--UNIT CODE     :   CSG3303                            
--ASSIGNMENT 02 :   CUMULATIVE MODIFICATION OF CODE       
--CAMPUS        :   ACBT / COLOMBO    
--SCENE 		:	SCORES CLEARING SCREEN                
--------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

--- Go To Scores Scene
local function gotoScore()
	composer.gotoScene("gameScore", { time=800, effect="crossFade" })
end

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

-- create()
function scene:create( event )

	local sceneGroup = self.view

--- Background image
	local background = display.newImageRect( sceneGroup, "background.png", 400, 800 )
    background.x = display.contentCenterX
    background.y = display.contentCenterY
	
--- Scores clearing text
	local loadScore = display.newText( sceneGroup, "Scores Clearing...", 155, 250, native.systemFontBold, 35 )
		loadScore:setFillColor(0.8,0,0.3) 
end

-- show()
function scene:show( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)

	elseif ( phase == "did" ) then
		timer.performWithDelay(1100, gotoScore)	  --Goes to the Scores scene after few seconds
	end
end

-- hide()
function scene:hide( event )

	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)

	elseif ( phase == "did" ) then
		 composer.removeScene("loadScore")

	end
end


-- destroy()
function scene:destroy( event )

	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
