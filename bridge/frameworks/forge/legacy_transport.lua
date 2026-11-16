-- Only native Forge endpoints. Source-contract translation belongs to bridge/compat.
return function(e)
    assert(e.GetCurrentResourceName()=='pr_bridge','QBX public transport context required')
    local target=e.exports['forge-core']
    return{
        Status=function()return target:ForgeRuntimeStatus()end,
        Describe=function()return target:ForgeQbxCompatDescribe()end,
        DescribeQB=function()return target:ForgeQbxCompatQBDescribe()end,
        Call=function(...)return target:ForgeQbxCompatCall(...)end,
        CallQB=function(...)return target:ForgeQbxCompatQBCall(...)end,
    }
end
