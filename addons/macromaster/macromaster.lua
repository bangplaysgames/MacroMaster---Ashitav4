--[[]
---MIT License---
Copyright 2022 Banggugyangu

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]--

addon.name    = 'MacroMaster';
addon.author  = 'banggugyangu';
addon.version = '1.0.1';

--Dependencies--
require('ffi');
require('common');
local chat = require('chat');
local settings = require('settings');

local default_settings = T{
    book = T{
        ['WAR'] = 1,
        ['MNK'] = 2,
        ['WHM'] = 3,
        ['BLM'] = 4,
        ['RDM'] = 5,
        ['THF'] = 6,
        ['PLD'] = 7,
        ['DRK'] = 8,
        ['BST'] = 9,
        ['BRD'] = 10,
        ['RNG'] = 11,
        ['SAM'] = 12,
        ['NIN'] = 13,
        ['DRG'] = 14,
        ['SMN'] = 15,
        ['BLU'] = 16,
        ['COR'] = 17,
        ['PUP'] = 18,
        ['DNC'] = 19,
        ['SCH'] = 20,
        ['GEO'] = 21,
        ['RUN'] = 22
    },
    page = T{
        ['WAR'] = 1,
        ['MNK'] = 1,
        ['WHM'] = 1,
        ['BLM'] = 1,
        ['RDM'] = 1,
        ['THF'] = 1,
        ['PLD'] = 1,
        ['DRK'] = 1,
        ['BST'] = 1,
        ['BRD'] = 1,
        ['RNG'] = 1,
        ['SAM'] = 1,
        ['NIN'] = 1,
        ['DRG'] = 1,
        ['SMN'] = 1,
        ['BLU'] = 1,
        ['COR'] = 1,
        ['PUP'] = 1,
        ['DNC'] = 1,
        ['SCH'] = 1,
        ['GEO']= 1,
        ['RUN'] = 1
    },
}

local macromaster = T{
    settings = settings.load(default_settings)
}

settings.register('settings', 'settings_update', function(s)
    if (s ~=nil) then
        macromaster.settings = s;
    end

    settings.save();
end);




local player = AshitaCore:GetMemoryManager():GetPlayer();
local mainJob = player:GetMainJob();
local subJob = player:GetSubJob();
local pmainjob = AshitaCore:GetResourceManager():GetString("jobs.names_abbr", mainJob);
local psubjob = AshitaCore:GetResourceManager():GetString("jobs.names_abbr", subJob);



local changeMacro = function()
    local bookset = macromaster.settings.book[pmainjob];
    local pageset = macromaster.settings.page[psubjob];
    if (bookset == nil or pageset == nil) then
        return;
    else
        local strBookCommand = ('/macro book '..bookset);
        local strPageCommand = ('/macro set '..pageset);
        AshitaCore:GetChatManager():QueueCommand(-1, strBookCommand);
        AshitaCore:GetChatManager():QueueCommand(-1, strPageCommand);
    end
end

    ashita.events.register('packet_in', 'packet_in_cb', function ()
    local tempMJ = AshitaCore:GetResourceManager():GetString("jobs.names_abbr", player:GetMainJob());
    local tempSJ = AshitaCore:GetResourceManager():GetString("jobs.names_abbr", player:GetSubJob());


    if (tempMJ ~= nil and tempSJ ~= nil) then
        if(tempMJ ~= pmainjob) then
            pmainjob = tempMJ;
            changeMacro();
        elseif(tempSJ ~= psubjob) then
            psubjob = tempSJ;
            changeMacro();
        else
            return;
        end
    end
end);

ashita.events.register('unload', 'unload_cb', function()
    settings.save();
end);

ashita.events.register('command', 'command_cb', function(e)
    --Parse Args
    local args = e.command:args();
    if (#args == 0 or not args[1]:any('/macromaster')) then
        return;
    end

    --Block Related Commands
    e.blocked = true;

    --Handle Commands
    if(#args <= 3) then
        print(chat.header('Set your macro book and page defaults for your current job and subjob by using the command "/macromaster set [book/page] #"'))
        print(chat.message('Replace the [book/page] with the desired change and # with the desired book or page.'))
    end
    if(#args > 3 and args[2]:any('set')) then



        if(args[3]:any('book')) then
            print(chat.header('Setting Macro Settings'));
            print(chat.message(args[3] .. ' set to ' .. args[3] .. ' ' .. args[4]));
            macromaster.settings.book[pmainjob] = ToInt(args[4]);
            return;
        elseif (args[3]:any('page')) then
            print(chat.header('Setting Macro Settings'));
            print(chat.message(args[3] .. ' set to ' .. args[3] .. ' ' .. args[4]));
            macromaster.settings.page[psubjob] = ToInt(args[4]);
            return;
        else
            print(chat.header('Please follow the correct syntax to set your macro management.'));
            return;
        end

    end
    end)