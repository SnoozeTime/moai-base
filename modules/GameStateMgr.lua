
--Classic game manager. stack of states.
--push a state to use it, and pop to stop it.
        
GameStateMgr = {}

local states = {}

local function setStateLayers(state)
   local layers = {}
   
   if state then
      layers = state:getLayers()
   end
   
   if layers then
      MOAIRenderMgr.setRenderTable(layers)
   else
      MOAIRenderMgr.setRenderTable({})

   end
end

function GameStateMgr.pushState(state)
   table.insert(states, state)
   
   -- initialize the state
   states[#states]:initialize()
   -- Display its layers
   setStateLayers(states[#states])
end

function GameStateMgr.popState(state)
   -- clean and remove
   if #states > 0 then
      states[#states]:clean()
      table.remove(states, #states)
   end
   
   -- then display the state below
   if #states > 0 then
      setStateLayers(states[#states])
   else
      setStateLayers(nil)
   end
end
   
function GameStateMgr.update()
   if #states > 0 then
      states[#states]:update()
   end
end
   
return GameStateMgr
   
