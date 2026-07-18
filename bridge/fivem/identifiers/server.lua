local identifiers = {}

local identifierTypes = {
    'license',
    'license2',
    'discord',
    'fivem',
    'steam',
    'xbl',
    'live',
    'ip',
}

local function validSource(source)
    source = tonumber(source)
    return source and source > 0 and source or nil
end

local function addUnique(list, value)
    if type(value) ~= 'string' or value == '' then return end

    for index = 1, #list do
        if list[index] == value then return end
    end

    list[#list + 1] = value
end

function identifiers.getByType(source, identifierType)
    source = validSource(source)
    if not source or type(identifierType) ~= 'string' or identifierType == '' then return nil end

    local value = GetPlayerIdentifierByType(source, identifierType)
    if value and value ~= '' then return value end
end

function identifiers.getAll(source)
    source = validSource(source)
    if not source then return {} end

    local result = {}
    for index = 1, #identifierTypes do
        local identifierType = identifierTypes[index]
        result[identifierType] = identifiers.getByType(source, identifierType)
    end

    result.source = source
    result.primaryLicense = result.license2 or result.license
    return result
end

function identifiers.getPrimaryLicense(source)
    local all = identifiers.getAll(source)
    return all.primaryLicense
end

function identifiers.getLicenseSet(source, extraLicenses)
    local all = identifiers.getAll(source)
    local list = {}

    addUnique(list, all.license)
    addUnique(list, all.license2)
    addUnique(list, all.primaryLicense)

    if type(extraLicenses) == 'table' then
        for index = 1, #extraLicenses do
            addUnique(list, extraLicenses[index])
        end
    else
        addUnique(list, extraLicenses)
    end

    return list
end

function identifiers.has(source, identifier)
    if type(identifier) ~= 'string' or identifier == '' then return false end

    local allIdentifiers = GetPlayerIdentifiers(validSource(source) or 0)
    for index = 1, #(allIdentifiers or {}) do
        if allIdentifiers[index] == identifier then return true end
    end

    return false
end

identifiers.GetByType = identifiers.getByType
identifiers.GetAll = identifiers.getAll
identifiers.GetPrimaryLicense = identifiers.getPrimaryLicense
identifiers.GetLicenseSet = identifiers.getLicenseSet
identifiers.Has = identifiers.has

return identifiers
