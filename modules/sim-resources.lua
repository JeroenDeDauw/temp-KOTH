
local ScenarioFramework = import('/lua/ScenarioFramework.lua');

-- playerTables = {
--     armies={
--         {
--         canContest=false,
--         canControl=false,
--         commanderOnHill=false,
--         identifier=1,
--         isAllyOfKing=false,
--         isDefeated=false,
--         isKing=false,
--         massOnHill=0,
--         strArmy="ARMY_1",
--         nickname="Jip",
--         scoreAcc=0,
--         scoreSeq=0
--         }
--     },
-- }

local function countContestants(playerTables)
    local contestants = 0
    for _, player in playerTables do
        if player.isContesting then
            contestants = contestants + 1
        end
    end
    return contestants
end

local function countKings(playerTables)
    local kings = 0
    for _, player in playerTables do
        if player.isKing then
            kings = kings + 1
        end
    end
    return kings
end

local function countTotalMassEco(playerTables)
    local total = 0
    for _, player in playerTables do
        total = total + GetArmyBrain(player.strArmy):GetEconomyIncome("MASS")
    end
    return total
end

local function giveBonusToKings(playerTables, amountOfKings)
    local totalMassEco = countTotalMassEco(playerTables)

    for _, player in playerTables do
        if player.isKing then
            local amount = (1.0 / amountOfKings) * 0.10 * totalMassEco
            GetArmyBrain(player.strArmy):GiveResource('MASS', amount)
        end
    end
end

function Tick(playerTables)

    local amountOfContestants = countContestants(playerTables)
    local amountOfKings = countKings(playerTables)


    -- if there are any kings
    if amountOfKings > 0 then
        giveBonusToKings(playerTables, amountOfKings)
    else 
        -- else, if there are any contestants
        if amountOfContestants > 0 then
            for k, player in playerTables do 
                if player.isContesting then 
                    -- determine the amount
                    local amount = (1.0 / amountOfContestants) * 0.10 * totalMassEco
    
                    -- provide resources
                    local brain = GetArmyBrain(player.strArmy)
                    brain:GiveResource('MASS', amount)
                end
            end
        end
    end
end